import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database_service.dart';
import '../../../core/database/market_price_model.dart';
import '../../../core/network/api_service.dart';
import 'widgets/market_price_card.dart';

// State definition for the Market Prices UI
class MarketPricesState {
  final List<MarketPrice> prices;
  final bool isLoading;
  final bool isOffline;

  MarketPricesState({
    required this.prices,
    required this.isLoading,
    required this.isOffline,
    this.errorMessage,
  });

  final String? errorMessage;

  MarketPricesState copyWith({
    List<MarketPrice>? prices,
    bool? isLoading,
    bool? isOffline,
    String? errorMessage,
  }) {
    return MarketPricesState(
      prices: prices ?? this.prices,
      isLoading: isLoading ?? this.isLoading,
      isOffline: isOffline ?? this.isOffline,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Riverpod Notifier implementation to coordinate loading, caching, and offline status
class MarketPricesNotifier extends Notifier<MarketPricesState> {
  @override
  MarketPricesState build() {
    loadPrices();
    return MarketPricesState(prices: [], isLoading: true, isOffline: false);
  }

  Future<void> loadPrices() async {
    // 1. Instantly retrieve data from local cache if present
    final cached = await DatabaseService.getCachedPrices();
    state = MarketPricesState(
      prices: cached,
      isLoading: cached.isEmpty,
      isOffline: false,
    );

    try {
      // 2. Query remote API for updated rates
      final latest = await ApiService().fetchLatestPrices();

      // 3. Overwrite local Isar cache on success
      await DatabaseService.savePrices(latest);

      state = MarketPricesState(prices: latest, isLoading: false, isOffline: false);
    } catch (e, st) {
      // 4. Fall back to cache and display the offline warning indicator
      print('APP_EXCEPTION: $e\n$st');
      state = MarketPricesState(prices: cached, isLoading: false, isOffline: true, errorMessage: e.toString());
    }
  }

  void dismissOfflineBanner() {
    state = state.copyWith(isOffline: false);
  }
}

// Expose the state notifier provider
final marketPricesProvider = NotifierProvider<MarketPricesNotifier, MarketPricesState>(() {
  return MarketPricesNotifier();
});

class MarketPriceScreen extends ConsumerWidget {
  const MarketPriceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(marketPricesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'आजको बजार भाउ',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              _showSettingsDialog(context, ref);
            },
            tooltip: 'API Settings',
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.green],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Forcefully trigger a cache reload and API refresh
          await ref.read(marketPricesProvider.notifier).loadPrices();
        },
        child: Column(
          children: [
            // Dismissible Offline/Cached Data Indicator Banner
            if (state.isOffline)
              Container(
                color: Colors.orangeAccent.withAlpha(220),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  children: [
                    const Icon(Icons.cloud_off_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'इन्टरनेट जडान छैन। पुरानो विवरण देखाइएको छ।',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    if (state.errorMessage != null)
                      Expanded(
                        child: Text(
                          state.errorMessage!,
                          style: const TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                      onPressed: () {
                        ref.read(marketPricesProvider.notifier).dismissOfflineBanner();
                      },
                    )
                  ],
                ),
              ),

            // List or blank/loading states
            Expanded(
              child: state.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : state.prices.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                            Icon(
                              Icons.cloud_off_rounded,
                              size: 64,
                              color: Theme.of(context).colorScheme.secondary.withAlpha(128),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "कुनै विवरण उपलब्ध छैन। कृपया इन्टरनेट अन गरी तान्नुहोस्।",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15, color: Colors.grey),
                            ),
                            const SizedBox(height: 24),
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  ref.read(marketPricesProvider.notifier).loadPrices();
                                },
                                icon: const Icon(Icons.refresh),
                                label: const Text('पुनः प्रयास गर्नुहोस्'),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Center(
                              child: TextButton.icon(
                                onPressed: () {
                                  _showSettingsDialog(context, ref);
                                },
                                icon: const Icon(Icons.settings),
                                label: const Text('API Base URL मिलाउनुहोस्'),
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          itemCount: state.prices.length,
                          itemBuilder: (context, index) {
                            return MarketPriceCard(price: state.prices[index]);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context, WidgetRef ref) async {
    final apiService = ApiService();
    final currentUrl = await apiService.getBaseUrl();
    final controller = TextEditingController(text: currentUrl);

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.settings, color: Colors.teal),
              SizedBox(width: 10),
              Text('API Configuration'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Configure Backend Base URL:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'e.g., http://192.168.1.100:8000',
                    labelText: 'Base URL',
                  ),
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.teal.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.teal.withAlpha(60)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '💡 Setup Guide:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.tealAccent,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '• Physical Phone: Find your computer\'s local IP address (e.g. 192.168.1.50). Make sure both phone and computer are on the same Wi-Fi. Set base URL to: http://192.168.1.50:8000',
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '• Deployed Backend: If you hosted the backend online (e.g. Render, Fly.io), use that URL: https://your-backend.onrender.com',
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '• Emulator: Use default http://10.0.2.2:8000',
                        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await apiService.setBaseUrl(ApiService.defaultBaseUrl);
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reset to default URL')),
                  );
                  ref.read(marketPricesProvider.notifier).loadPrices();
                }
              },
              child: const Text('Reset Default', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final enteredUrl = controller.text.trim();
                if (enteredUrl.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('URL cannot be empty')),
                  );
                  return;
                }
                if (!enteredUrl.startsWith('http://') && !enteredUrl.startsWith('https://')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('URL must start with http:// or https://')),
                  );
                  return;
                }
                await apiService.setBaseUrl(enteredUrl);
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Saved: $enteredUrl')),
                  );
                  ref.read(marketPricesProvider.notifier).loadPrices();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

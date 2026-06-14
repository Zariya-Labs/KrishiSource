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
  });

  MarketPricesState copyWith({
    List<MarketPrice>? prices,
    bool? isLoading,
    bool? isOffline,
  }) {
    return MarketPricesState(
      prices: prices ?? this.prices,
      isLoading: isLoading ?? this.isLoading,
      isOffline: isOffline ?? this.isOffline,
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
    } catch (e) {
      // 4. Fall back to cache and display the offline warning indicator
      state = MarketPricesState(prices: cached, isLoading: false, isOffline: true);
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
}

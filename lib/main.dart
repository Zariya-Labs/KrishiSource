import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/database/database_service.dart';
import 'core/database/market_price_model.dart';
import 'features/market_prices/price_repository.dart';

// Riverpod Notifier Provider to manage market prices list state
final marketPricesProvider = NotifierProvider<MarketPricesNotifier, List<MarketPrice>>(() {
  return MarketPricesNotifier();
});

class MarketPricesNotifier extends Notifier<List<MarketPrice>> {
  @override
  List<MarketPrice> build() {
    loadPrices();
    return [];
  }

  Future<void> loadPrices() async {
    final prices = await DatabaseService.getCachedPrices();
    state = prices;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.init();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KrishiSource',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prices = ref.watch(marketPricesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🌱 KrishiSource Dashboard',
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(80),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sync Action Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        'Keep prices updated to make informed decisions.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () async {
                          // Show loading SnackBar
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text('Syncing market prices...'),
                                ],
                              ),
                              duration: Duration(seconds: 10),
                            ),
                          );

                          try {
                            // Sync remote database records
                            await PriceRepository().syncPrices();

                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('🎉 Sync successful! Prices updated.'),
                                backgroundColor: Colors.green,
                              ),
                            );

                            // Refresh local provider state
                            ref.read(marketPricesProvider.notifier).loadPrices();
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('⚠️ Sync failed: $e'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.sync_rounded),
                        label: const Text('Sync Latest Market Prices'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Section Title
              Row(
                children: [
                  const Icon(Icons.trending_up_rounded, color: Colors.teal),
                  const SizedBox(width: 8),
                  Text(
                    'Daily Commodity Market Prices',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Prices List
              Expanded(
                child: prices.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_off_rounded,
                              size: 64,
                              color: Theme.of(context).colorScheme.secondary.withAlpha(128),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "No data cached. Please sync over the internet.",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: prices.length,
                        itemBuilder: (context, index) {
                          final price = prices[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.teal.withAlpha(25),
                                child: const Icon(Icons.agriculture_rounded, color: Colors.teal),
                              ),
                              title: Text(
                                '${price.commodityNameEn} (${price.commodityNameNp})',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'Unit: ${price.unit} | Min: Rs. ${price.minimumPrice.toStringAsFixed(0)} | Max: Rs. ${price.maximumPrice.toStringAsFixed(0)}',
                              ),
                              trailing: Text(
                                'Rs. ${price.averagePrice.toStringAsFixed(1)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.green,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

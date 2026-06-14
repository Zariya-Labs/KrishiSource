import 'package:flutter/material.dart';
import '../../market_prices/presentation/market_price_screen.dart';
import '../../crop_diagnosis/presentation/crop_diagnosis_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    MarketPriceScreen(),
    CropDiagnosisScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        indicatorColor: Colors.teal.withAlpha(80),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.trending_up_rounded),
            selectedIcon: Icon(Icons.trending_up_rounded, color: Colors.tealAccent),
            label: 'बजार भाउ',
          ),
          NavigationDestination(
            icon: Icon(Icons.psychology_rounded),
            selectedIcon: Icon(Icons.psychology_rounded, color: Colors.tealAccent),
            label: 'बिरुवा जाँच',
          ),
        ],
      ),
    );
  }
}

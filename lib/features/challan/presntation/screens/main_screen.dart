import 'package:challan_app/core/theme/app_theme.dart';
import 'package:challan_app/features/challan/presntation/screens/challan_list_screen.dart';
import 'package:challan_app/features/challan/presntation/screens/dashboard_screen.dart';
import 'package:challan_app/features/challan/presntation/screens/history_screen.dart';
import 'package:challan_app/features/workers/presentation/screens/worker_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  List screen = [
    DashboardScreen(),
    ChallanListScreen(),
    HistoryScreen(),
    WorkerScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary, // saffron orange
        unselectedItemColor: AppColors.grey,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (value) => setState(() => currentIndex = value),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Challans',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Workers',
          ),
        ],
      ),
    );
  }
}

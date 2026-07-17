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
  Widget navItem(int index, IconData icon, IconData activeIcon, String label) {
    bool isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => currentIndex = index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppColors.primary : AppColors.grey,
            ),
            SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isActive ? AppColors.primary : AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[currentIndex],
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: AppColors.grey.withValues(alpha: 0.3)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            navItem(0, Icons.dashboard_outlined, Icons.dashboard, 'Home'),
            navItem(
              1,
              Icons.receipt_long_outlined,
              Icons.receipt_long,
              'Challans',
            ),
            navItem(2, Icons.history_outlined, Icons.history, 'Logs'),
            navItem(3, Icons.people_outline, Icons.people, 'Staff'),
          ],
        ),
      ),
    );
  }
}

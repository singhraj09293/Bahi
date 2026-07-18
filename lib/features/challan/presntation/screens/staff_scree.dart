import 'package:challan_app/core/theme/app_theme.dart';
import 'package:challan_app/features/seth/presentation/screen/seths_screen.dart';
import 'package:challan_app/features/workers/presentation/screens/worker_screen.dart';
import 'package:flutter/material.dart';

class StaffScree extends StatefulWidget {
  const StaffScree({super.key});

  @override
  State<StaffScree> createState() => _StaffScreeState();
}

class _StaffScreeState extends State<StaffScree> {
  bool showWorkers = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Staff')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => showWorkers = true),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: showWorkers ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black26),
                      ),
                      child: Text(
                        'Workers',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: showWorkers ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => showWorkers = false),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !showWorkers ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black26),
                      ),
                      child: Text(
                        'Masters',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: !showWorkers ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: showWorkers ? WorkerScreen() : SethsScreen()),
        ],
      ),
    );
  }
}

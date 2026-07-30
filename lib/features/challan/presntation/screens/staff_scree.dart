import 'package:challan_app/core/theme/app_theme.dart';
import 'package:challan_app/features/challan/data/repositories/staff_repository.dart';
import 'package:challan_app/features/challan/presntation/screens/otherStaff.dart';
import 'package:challan_app/features/workers/data/model/other_staff_model.dart';

import 'package:challan_app/features/workers/presentation/screens/worker_screen.dart';
import 'package:flutter/material.dart';

class StaffScree extends StatefulWidget {
  const StaffScree({super.key});

  @override
  State<StaffScree> createState() => _StaffScreeState();
}

class _StaffScreeState extends State<StaffScree> {
  bool showWorkers = true;
  void _showAddStaffBottomSheet() {
    final nameController = TextEditingController();
    final roleController = TextEditingController();
    final salaryController = TextEditingController();
    final repository = StaffRepository();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add Staff',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: roleController,
              decoration: const InputDecoration(labelText: 'Role'),
            ),
            TextField(
              controller: salaryController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Salary (₹)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    salaryController.text.isNotEmpty) {
                  final staff = OtherStaffModel(
                    id: '',
                    name: nameController.text.trim(),
                    role: roleController.text.trim(),
                    salary:
                        double.tryParse(salaryController.text.trim()) ?? 0.0,
                  );
                  await repository.addStaff(staff);
                  if (mounted) Navigator.pop(ctx);
                }
              },
              child: const Text('Save Staff'),
            ),
          ],
        ),
      ),
    );
  }

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
                        'Other Staff',
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
          Expanded(
            child: showWorkers ? const WorkerScreen() : const Otherstaff(),
          ),
        ],
      ),
      floatingActionButton: !showWorkers
          ? FloatingActionButton.extended(
              onPressed: _showAddStaffBottomSheet,
              icon: const Icon(Icons.add),
              label: const Text('Add Staff'),
            )
          : null,
    );
  }
}

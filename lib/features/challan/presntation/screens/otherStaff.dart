import 'package:challan_app/core/theme/app_theme.dart';
import 'package:challan_app/features/challan/data/repositories/staff_repository.dart';
import 'package:challan_app/features/workers/data/model/other_staff_model.dart';
import 'package:flutter/material.dart';
// Import your StaffRepository here

class Otherstaff extends StatelessWidget {
  const Otherstaff({super.key});

  @override
  Widget build(BuildContext context) {
    final staffRepository = StaffRepository();

    return StreamBuilder<List<OtherStaffModel>>(
      stream: staffRepository.getStaff(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error loading staff: ${snapshot.error}'));
        }

        final staffList = snapshot.data ?? [];

        // 💡 Live Expense Calculation
        double totalWorkerEp = staffList.fold(
          0.0,
          (sum, staff) => sum + staff.salary,
        );

        return Column(
          children: [
            // Expense Banner
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepOrange.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.deepOrange.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Staff Expense',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Monthly Salaries',
                        style: TextStyle(fontSize: 12, color: Colors.black38),
                      ),
                    ],
                  ),
                  Text(
                    '₹${totalWorkerEp.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange.shade800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Staff List
            Expanded(
              child: staffList.isEmpty
                  ? const Center(
                      child: Text(
                        'No staff added yet.\nTap + button to add staff.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      itemCount: staffList.length,
                      itemBuilder: (context, index) {
                        final staff = staffList[index];
                        return Dismissible(
                          key: Key(staff.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          confirmDismiss: (direction) async {
                            return showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Delete Staff Member'),
                                content: Text(
                                  'Are you sure you want to remove ${staff.name}?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          },
                          onDismissed: (direction) {
                            staffRepository.deleteStaff(staff.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${staff.name} removed')),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue.shade100,
                                child: Text(
                                  staff.name.isNotEmpty
                                      ? staff.name[0].toUpperCase()
                                      : '?',
                                  style: TextStyle(
                                    color: Colors.blue.shade900,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                staff.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(staff.role),
                              trailing: Text(
                                '₹${staff.salary.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

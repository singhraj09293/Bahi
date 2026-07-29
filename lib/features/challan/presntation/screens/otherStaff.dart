import 'package:challan_app/features/workers/data/model/other_staff_model.dart';
import 'package:flutter/material.dart';

class Otherstaff extends StatefulWidget {
  final List<OtherStaffModel> staffList;
  const Otherstaff({super.key, required this.staffList});

  @override
  State<Otherstaff> createState() => _OtherstaffState();
}

class _OtherstaffState extends State<Otherstaff> {
  @override
  Widget build(BuildContext context) {
    double totalWorkerEp = widget.staffList.fold(
      0.0,
      (sum, staff) => sum + staff.salary,
    );
    return Column(
      children: [
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
        SizedBox(height: 10),
        Expanded(
          child: widget.staffList.isEmpty
              ? Center(
                  child: Text(
                    'No staff added yet.\nTap + button to add staff.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: widget.staffList.length,
                  itemBuilder: ((context, index) {
                    final staff = widget.staffList[index];
                    return Card(
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
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
                    );
                  }),
                ),
        ),
      ],
    );
  }
}

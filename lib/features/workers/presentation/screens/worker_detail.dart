import 'package:challan_app/core/theme/app_theme.dart';
import 'package:challan_app/features/challan/data/models/challan_model.dart';
import 'package:challan_app/features/challan/data/models/workers_assignment.dart';
import 'package:challan_app/features/challan/presntation/provider/challan_provider.dart';
import 'package:challan_app/features/workers/data/model/worker_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkerDetail extends ConsumerStatefulWidget {
  final WorkerModel worker;
  const WorkerDetail({super.key, required this.worker});

  @override
  ConsumerState<WorkerDetail> createState() => _WorkerDetailState();
}

class _WorkerDetailState extends ConsumerState<WorkerDetail> {
  Color getBadgeColor(ChallanModel challan) {
    if (challan.isDelivered) return Colors.blue.shade50;
    if (challan.isReady == 'Ready') return Colors.green.shade50;
    return Colors.orange.shade50;
  }

  Color getBadgeTextColor(ChallanModel challan) {
    if (challan.isDelivered) return Colors.blue.shade700;
    if (challan.isReady == 'Ready') return Colors.green.shade700;
    return Colors.orange.shade700;
  }

  String getBadgeText(ChallanModel challan) {
    if (challan.isDelivered) return 'Delivered';
    if (challan.isReady == 'Ready') return 'Ready';
    return 'Pending';
  }

  assignWor(BuildContext context, WidgetRef ref, WorkerModel worker) {
    final challan = ref.read(challanProvider);
    challan.whenData((challans) {
      ChallanModel? selectedChallan;
      TextEditingController qtyController = TextEditingController();
      TextEditingController rateController = TextEditingController();
      showDialog(
        context: context,
        builder: (_) => StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text('Assign work'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<ChallanModel>(
                  initialValue: selectedChallan,
                  hint: Text('Select Challan'),
                  items: challans.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text('Challan ${e.challanNo}, ${e.totalPiece}pcs'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedChallan = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: qtyController,
                  decoration: InputDecoration(hintText: 'Quantity'),
                ),
                SizedBox(height: 10),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: rateController,
                  decoration: InputDecoration(hintText: 'Rate per price (₹)'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (selectedChallan == null ||
                      qtyController.text.isEmpty ||
                      rateController.text.isEmpty) {
                    return;
                  }
                  int qtr = int.parse(qtyController.text.trim());
                  double rate = double.parse(rateController.text.trim());

                  if (qtr < 0 || rate < 0) return;
                  List<WorkerAssignment> updatedAssignment = List.from(
                    selectedChallan!.assignments,
                  );
                  updatedAssignment.add(
                    WorkerAssignment(
                      workerId: worker.workerId,
                      workerName: worker.workerName,
                      quantity: qtr,
                      ratePerPiece: rate,
                    ),
                  );
                  ref
                      .read(challanRepositiaryProvider)
                      .updateChallan(
                        selectedChallan!.copyWith(
                          assignments: updatedAssignment,
                        ),
                      );
                  qtyController.dispose();
                  rateController.dispose();
                  Navigator.pop(context);
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final challanAsync = ref.watch(challanProvider);
    final worker = widget.worker;
    return challanAsync.when(
      data: (challan) {
        final workerChallans = challan
            .where((c) => c.workerid == worker.workerId)
            .toList();

        int total = workerChallans.length;
        int pending = workerChallans
            .where((c) => c.isReady == 'Pending')
            .length;
        int completed = workerChallans.where((c) => c.isDelivered).length;
        int piece = workerChallans.fold(0, (sum, c) => sum + c.totalPiece);
        int totalPiecesAssigned = 0;
        double totalEarned = 0;
        final List<AssignedWorkItem> workerWorkList = [];
        for (var c in challan) {
          for (var a in c.assignments) {
            if (a.workerId == worker.workerId) {
              totalPiecesAssigned = totalPiecesAssigned + a.quantity;
              totalEarned = totalEarned + a.amount;
            }
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.worker.workerName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {
                  assignWor(context, ref, worker);
                },
                icon: Icon(Icons.assignment_ind),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.black, width: 0.7),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person, color: Colors.grey),
                          Text('Name', style: TextStyle(color: Colors.grey)),
                          Spacer(),
                          Text(
                            worker.workerName,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 5),
                      Divider(color: Colors.grey),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.receipt_long, color: Colors.grey),
                          Text(
                            'Total challan',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Spacer(),
                          Text(
                            total.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Divider(color: Colors.grey),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.layers_outlined, color: Colors.grey),
                          Text(
                            'Total Pieces Assigned',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Spacer(),
                          Text(
                            '$totalPiecesAssigned pcs',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Divider(color: Colors.grey),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.timer, color: Colors.grey),
                          Text('Pending', style: TextStyle(color: Colors.grey)),
                          Spacer(),
                          Text(
                            pending.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Divider(color: Colors.grey),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.check_circle_outline, color: Colors.grey),
                          Text(
                            'Completed',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Spacer(),
                          Text(
                            completed.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Divider(color: Colors.grey),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.layers_outlined, color: Colors.grey),
                          Text(
                            'Total piece',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Spacer(),
                          Text(
                            piece.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Divider(color: Colors.grey),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.currency_rupee, color: Colors.grey),
                          Text(
                            'Total Earning',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Spacer(),
                          Text(
                            totalEarned.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(height: 10),
                Text(
                  'Assigned Work',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      for (var c in challan) {
                        for (var a in c.assignments) {
                          print(
                            'Checking: Assignment ID "${a.workerId}" vs Screen Worker ID "${worker.workerId}"',
                          );
                          if (a.workerId == worker.workerId) {
                            totalEarned = totalEarned + a.amount;
                            workerWorkList.add(
                              AssignedWorkItem(
                                challanNo: c.challanNo.toString(),
                                assignment: a,
                              ),
                            );
                          }
                        }
                      }

                      if (workerWorkList.isEmpty) {
                        return Center(child: Text('No work assigned yet.'));
                      }
                      return ListView.builder(
                        itemCount: workerWorkList.length,
                        itemBuilder: (context, index) {
                          final item = workerWorkList[index];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.black12,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Challan ${item.challanNo}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${item.assignment.quantity} pcs × ₹${item.assignment.ratePerPiece} = ₹${item.assignment.amount}',
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
      error: (e, st) => Text('Error $e'),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}

// Simple wrapper to hold the matched work cleanly
class AssignedWorkItem {
  final String challanNo;
  final WorkerAssignment assignment;

  AssignedWorkItem({required this.challanNo, required this.assignment});
}

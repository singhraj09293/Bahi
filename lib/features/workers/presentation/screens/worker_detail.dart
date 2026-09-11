import 'package:challan_app/core/theme/app_theme.dart';
import 'package:challan_app/features/challan/data/models/challan_model.dart';
import 'package:challan_app/features/challan/data/models/workers_assignment.dart';
import 'package:challan_app/features/challan/presntation/provider/challan_provider.dart';
import 'package:challan_app/features/workers/data/model/payment_entry.dart';
import 'package:challan_app/features/workers/data/model/worker_model.dart';
import 'package:challan_app/features/workers/presentation/provider/worker_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkerDetail extends ConsumerStatefulWidget {
  final WorkerModel worker;
  const WorkerDetail({super.key, required this.worker});

  @override
  ConsumerState<WorkerDetail> createState() => _WorkerDetailState();
}

class _WorkerDetailState extends ConsumerState<WorkerDetail> {
  final amount = TextEditingController();
  final notes = TextEditingController();

  @override
  void dispose() {
    amount.dispose();
    notes.dispose();
    super.dispose();
  }

  void toggleComplete(WidgetRef ref, AssignedWorkItem item) {
    final updatedAssignments = item.challan.assignments.map((a) {
      if (a.workerId == item.assignment.workerId &&
          a.quantity == item.assignment.quantity &&
          a.ratePerPiece == item.assignment.ratePerPiece) {
        return a.copyWith(isComplete: !a.isComplete);
      }
      return a;
    }).toList();

    ref
        .read(challanRepositiaryProvider)
        .updateChallan(item.challan.copyWith(assignments: updatedAssignments));
  }

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
      final qtyController = TextEditingController();
      final rateController = TextEditingController();
      final varientController = TextEditingController();
      String? errorText;

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
                SizedBox(height: 10),
                TextField(
                  controller: varientController,
                  decoration: InputDecoration(hintText: 'Color/Varient'),
                ),
                if (errorText != null) ...[
                  SizedBox(height: 10),
                  Text(
                    errorText!,
                    style: TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  qtyController.dispose();
                  rateController.dispose();
                  varientController.dispose();
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (selectedChallan == null) {
                    setDialogState(() => errorText = 'Please select a challan');
                    return;
                  }
                  if (qtyController.text.trim().isEmpty ||
                      rateController.text.trim().isEmpty ||
                      varientController.text.trim().isEmpty) {
                    setDialogState(
                      () => errorText = 'Please fill in all fields',
                    );
                    return;
                  }

                  final qty = int.tryParse(qtyController.text.trim());
                  final rate = double.tryParse(rateController.text.trim());

                  if (qty == null || rate == null) {
                    setDialogState(
                      () => errorText = 'Quantity and rate must be numbers',
                    );
                    return;
                  }
                  if (qty < 0 || rate < 0) {
                    setDialogState(
                      () => errorText = 'Quantity and rate cannot be negative',
                    );
                    return;
                  }

                  List<WorkerAssignment> updatedAssignment = List.from(
                    selectedChallan!.assignments,
                  );
                  updatedAssignment.add(
                    WorkerAssignment(
                      workerId: worker.workerId,
                      workerName: worker.workerName,
                      quantity: qty,
                      ratePerPiece: rate,
                      varient: varientController.text.trim(),
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
                  varientController.dispose();
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
    final workerAsync = ref.watch(workerProvider);
    final worker =
        workerAsync.value?.firstWhere(
          (w) => w.workerId == widget.worker.workerId,
          orElse: () => widget.worker,
        ) ??
        widget.worker;
    return challanAsync.when(
      data: (challan) {
        final workerChallans = challan
            .where(
              (c) => c.assignments.any((a) => a.workerId == worker.workerId),
            )
            .toList();

        final List<AssignedWorkItem> workerWorkList = [];
        for (var c in challan) {
          for (var a in c.assignments) {
            if (a.workerId == worker.workerId) {
              workerWorkList.add(AssignedWorkItem(challan: c, assignment: a));
            }
          }
        }
        int total = workerChallans.length;
        int pending = workerWorkList
            .where((item) => !item.assignment.isComplete)
            .length;
        int completed = workerWorkList
            .where((item) => item.assignment.isComplete)
            .length;
        int piece = workerChallans.fold(0, (sum, c) => sum + c.totalPiece);
        int totalPiecesAssigned = workerWorkList.fold(
          0,
          (sum, item) => sum + item.assignment.quantity,
        );
        double totalEarned = workerWorkList.fold(
          0.0,
          (sum, item) => sum + item.assignment.amount,
        );
        double totalPaid = worker.payments.fold(
          0.0,
          (sum, p) => sum + p.amount,
        );
        double remaining = totalEarned - totalPaid;
        return DefaultTabController(
          length: 2,
          child: Scaffold(
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
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Record Payment'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: amount,
                              decoration: InputDecoration(
                                hintText: 'Add Payment',
                                border: InputBorder.none,
                              ),
                            ),
                            TextField(
                              controller: notes,
                              decoration: InputDecoration(
                                hintText: 'Note Payment',
                                border: InputBorder.none,
                              ),
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
                              if (amount.text.trim().isEmpty) return;

                              final parsed = double.tryParse(
                                amount.text.trim(),
                              );
                              if (parsed == null) return;
                              final payment = PaymentEntry(
                                amount: parsed,
                                date: DateTime.now(),
                                note: notes.text.isEmpty
                                    ? null
                                    : notes.text.trim(),
                              );
                              List<PaymentEntry> updatedPayment = List.from(
                                worker.payments,
                              );
                              updatedPayment.add(payment);
                              ref
                                  .read(workerRepositoryProvider)
                                  .updateWorker(
                                    worker.copyWith(payments: updatedPayment),
                                  );
                              amount.clear();
                              notes.clear();
                              Navigator.pop(context);
                            },
                            child: Text('Save'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(Icons.currency_rupee),
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
                            Text(
                              'Pending',
                              style: TextStyle(color: Colors.grey),
                            ),
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
                            Icon(
                              Icons.check_circle_outline,
                              color: Colors.grey,
                            ),
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
                            Icon(Icons.trending_up, color: Colors.grey),
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
                        SizedBox(height: 5),
                        Divider(color: Colors.grey),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: Colors.grey,
                            ),
                            Text(
                              'Total Paid',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Spacer(),
                            Text(
                              totalPaid.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Divider(color: Colors.grey),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.hourglass_bottom, color: Colors.grey),
                            Text(
                              'Remaining',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Spacer(),
                            Text(
                              remaining.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(height: 10),
                  TabBar(
                    tabs: [
                      Tab(text: 'Work'),
                      Tab(text: 'Payment'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: TabBarView(
                      children: [
                        workerWorkList.isEmpty
                            ? Center(child: Text('No work assign yet.'))
                            : ListView.builder(
                                itemCount: workerWorkList.length,
                                itemBuilder: (context, index) {
                                  final item = workerWorkList[index];

                                  return GestureDetector(
                                    onTap: () => toggleComplete(ref, item),
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: item.assignment.isComplete
                                            ? Colors.grey.shade100
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.black12,
                                          width: 1,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Challan ${item.challan.challanNo}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  item.assignment.isComplete
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            '${item.assignment.quantity} pcs × ₹${item.assignment.ratePerPiece} = ₹${item.assignment.amount}',
                                            style: TextStyle(
                                              color: item.assignment.isComplete
                                                  ? Colors.grey
                                                  : Colors.black,
                                              decoration:
                                                  item.assignment.isComplete
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                        worker.payments.isEmpty
                            ? Center(child: Text('No payment yet'))
                            : ListView.builder(
                                itemCount: worker.payments.length,
                                itemBuilder: (context, index) {
                                  final p = worker.payments[index];
                                  return ListTile(
                                    leading: Icon(
                                      Icons.payment,
                                      color: Colors.green,
                                    ),
                                    title: Text('₹${p.amount}'),
                                    subtitle: Text(p.note ?? ''),
                                    trailing: Text(
                                      '${p.date.day}/${p.date.month}/${p.date.year}',
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ],
              ),
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
  final ChallanModel challan;
  final WorkerAssignment assignment;

  AssignedWorkItem({required this.challan, required this.assignment});
}

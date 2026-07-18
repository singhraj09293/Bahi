import 'package:challan_app/core/theme/app_theme.dart';
import 'package:challan_app/features/challan/data/models/challan_model.dart';
import 'package:challan_app/features/challan/presntation/provider/challan_provider.dart';
import 'package:challan_app/features/workers/data/model/worker_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
        double earning = 0;
        for (var c in workerChallans) {
          earning = earning + c.totalAmount;
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
                          Icon(Icons.build_outlined, color: Colors.grey),
                          Text(
                            'Work Type',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Spacer(),
                          Text(
                            worker.workerType,
                            style: TextStyle(fontWeight: FontWeight.bold),
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
                          Icon(Icons.timer, color: Colors.grey),
                          Text('Pending', style: TextStyle(color: Colors.grey)),
                          Spacer(),
                          Text(
                            pending.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold,color:Colors.red),
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
                            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green.shade700),
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
                            earning.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height:10),
                Text(
                  'Challan History',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    letterSpacing: 0.6,
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: workerChallans.length,
                    itemBuilder: ((context, index) {
                      final c = workerChallans[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  c.challanNo,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 23,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color: getBadgeColor(c),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    getBadgeText(c),
                                    style: TextStyle(
                                      color: getBadgeTextColor(c),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${c.workersNames} ·${c.totalPiece}pcs',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              c.classification,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),

                            Divider(color: AppColors.primary),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Given ${DateFormat('dd MMM yyyy').format(c.date)}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  c.isDelivered
                                      ? 'Delivered: ${DateFormat('dd MMM yyyy').format(c.deliveryDate!)}'
                                      : 'No delivery yet',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
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

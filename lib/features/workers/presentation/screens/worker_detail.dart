import 'package:challan_app/core/theme/app_theme.dart';
import 'package:challan_app/features/challan/presntation/provider/challan_provider.dart';
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
        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment:CrossAxisAlignment.start ,
              children: [
                Text(
                  widget.worker.workerName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      widget.worker.workerType,
                      style: TextStyle(fontSize: 15),
                    ),SizedBox(width: 10,),
                    Text('$total challans', style: TextStyle(fontSize: 15)),
                  ],
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 180,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black, width: 0.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.receipt_long, color: Colors.blue, size: 24),
                          SizedBox(height: 5),
                          Text(
                            total.toString(),
                            style: TextStyle(color: Colors.blue, fontSize: 25),
                          ),
                          Text(
                            'Total Challan',
                            style: TextStyle(color: AppColors.grey, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 180,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black, width: 0.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.pending_actions,
                            color: Colors.red,
                            size: 24,
                          ),
                          SizedBox(height: 5),
                          Text(
                            pending.toString(),
                            style: TextStyle(color: Colors.red, fontSize: 25),
                          ),
                          Text(
                            'pending',
                            style: TextStyle(color: AppColors.grey, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 180,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black, width: 0.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                            size: 24,
                          ),
                          SizedBox(height: 5),
                          Text(
                            completed.toString(),
                            style: TextStyle(color: Colors.green, fontSize: 25),
                          ),
                          Text(
                            'Delivered',
                            style: TextStyle(color: AppColors.grey, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 180,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black, width: 0.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.layers_outlined,
                            color: Colors.purple,
                            size: 24,
                          ),
                          SizedBox(height: 5),
                          Text(
                            piece.toString(),
                            style: TextStyle(color: Colors.purple, fontSize: 25),
                          ),
                          Text(
                            'Total pieces',
                            style: TextStyle(color: AppColors.grey, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
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

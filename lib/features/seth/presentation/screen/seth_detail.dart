import 'package:challan_app/features/challan/data/models/challan_model.dart';
import 'package:challan_app/features/challan/presntation/provider/challan_provider.dart';
import 'package:challan_app/features/seth/data/model/seth_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SethDetail extends ConsumerStatefulWidget {
  final SethModel seth;
  const SethDetail({super.key, required this.seth});

  @override
  ConsumerState<SethDetail> createState() => _SethDetailState();
}

class _SethDetailState extends ConsumerState<SethDetail> {
  Color getBadgeColor(ChallanModel c) {
    if (c.isDelivered) return Colors.blue.shade50;
    if (c.isReady == 'Ready') return Colors.green.shade50;
    return Colors.orange.shade50;
  }

  Color getBadgeTextColor(ChallanModel c) {
    if (c.isDelivered) return Colors.blue.shade700;
    if (c.isReady == 'Ready') return Colors.green.shade700;
    return Colors.orange.shade700;
  }

  String getBadgeText(ChallanModel c) {
    if (c.isDelivered) return 'Delivered';
    if (c.isReady == 'Ready') return 'Ready';
    return 'Pending';
  }

  @override
  Widget build(BuildContext context) {
    final challan = ref.watch(challanProvider);
    return challan.when(
      data: (challans) {
        final masterChallan = challans
            .where((m) => m.sethid == widget.seth.masterId)
            .toList();
        int total = masterChallan.length;
        int pending = masterChallan.where((m) => m.isReady == 'Pending').length;
        int completed = masterChallan.where((m) => m.isDelivered).length;
        int piece = 0;
        for (var c in masterChallan) {
          piece = piece + c.totalPiece;
        }
        return Scaffold(
          appBar: AppBar(title: Text(widget.seth.masterName)),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.black12, width: 0.7),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.storefront_outlined, color: Colors.grey),
                          Text('Name', style: TextStyle(color: Colors.grey)),
                          Spacer(),
                          Text(
                            widget.seth.masterName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Divider(),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.receipt_long, color: Colors.grey),
                          Text(
                            'Total Challans',
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
                      Divider(),
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
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Divider(),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.check_circle_outline, color: Colors.grey),
                          Text('Completed', style: TextStyle(color: Colors.grey)),
                          Spacer(),
                          Text(
                            completed.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Divider(),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.layers_outlined, color: Colors.grey),
                          Text(
                            'Total Pieces',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Spacer(),
                          Text(
                            '$piece pcs',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Challan History',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: masterChallan.length,
                    itemBuilder: ((context, index) {
                      final m = masterChallan[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.black, offset: Offset(0, 3)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  m.challanNo,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: getBadgeColor(m),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    getBadgeText(m),
                                    style: TextStyle(
                                      color: getBadgeTextColor(m),
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${m.workersNames} · ${m.totalPiece}pcs',
                              style: TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Given Date ${DateFormat('dd MMM yyyy').format(m.date)}",
                              style: TextStyle(color: Colors.grey, fontSize: 13),
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

import 'package:challan_app/features/challan/presntation/provider/challan_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final challan = ref.watch(challanProvider);

    return challan.when(
      error: (e, st) => Text('Erorr $e'),
      loading: () => Center(child: CircularProgressIndicator()),
      data: (challans) {
        final delivered = challans.where((c) => c.isDelivered == true).toList();
        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('History'),
                Text(
                  '${delivered.length} challans delivered',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(challanProvider);
                  },
                  child: ListView.builder(
                    itemCount: delivered.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          padding: EdgeInsets.all(20),
                         
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black, width: 0.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    delivered[index].challanNo,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  Spacer(),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.done,
                                          color: Colors.blue.shade700,
                                        ),
                                        SizedBox(width: 5),
                                        Text('Delivered'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${delivered[index].workersNames} · ${delivered[index].totalPiece}',
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(height: 7),
                              Text(
                                delivered[index].classification,
                                style: TextStyle(color: Colors.grey),
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Given :${DateFormat('dd MMM yyyy').format(delivered[index].date)}',
                                    style: TextStyle(
                                      color: Colors.blue.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    delivered[index].deliveryDate != null
                                        ? 'Delivered: ${DateFormat('dd MMM yyyy').format(delivered[index].deliveryDate!)}'
                                        : 'Not delivered',
                                    style: TextStyle(
                                      color: Colors.blue.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

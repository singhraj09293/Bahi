import 'package:challan_app/core/theme/app_theme.dart';
import 'package:challan_app/features/challan/data/models/challan_model.dart';
import 'package:challan_app/features/challan/presntation/provider/challan_provider.dart';
import 'package:challan_app/features/challan/presntation/screens/detail_challan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SethChallan extends ConsumerStatefulWidget {
  final String sethName;
  const SethChallan({super.key, required this.sethName});

  @override
  ConsumerState<SethChallan> createState() => _SethChallanState();
}

class _SethChallanState extends ConsumerState<SethChallan> {
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
    return challanAsync.when(
      data: (challan) {
        final seth = challan
            .where((e) => e.sethName == widget.sethName)
            .toList();
        return Scaffold(
          appBar: AppBar(title: Text(widget.sethName)),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView.builder(
              itemCount: seth.length,
              itemBuilder: (context, index) {
                final c = seth[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailChallan(challan: challan[index]),
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 4),
                        ),
                      ],
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
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                        Text(
                          c.classification,
                          style: TextStyle(color: Colors.grey, fontSize: 15),
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
                  ),
                );
              },
            ),
          ),
        );
      },
      error: (e, st) => Text('Error $e'),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}

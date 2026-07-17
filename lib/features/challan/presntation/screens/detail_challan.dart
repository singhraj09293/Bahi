import 'package:challan_app/core/theme/app_theme.dart';
import 'package:challan_app/features/challan/data/models/challan_item.dart';
import 'package:challan_app/features/challan/data/models/challan_model.dart';
import 'package:challan_app/features/challan/presntation/provider/challan_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DetailChallan extends ConsumerStatefulWidget {
  final ChallanModel challan;
  const DetailChallan({super.key, required this.challan});

  @override
  ConsumerState<DetailChallan> createState() => _DetailChallanState();
}

class _DetailChallanState extends ConsumerState<DetailChallan> {
  void editCompletedQty(int index) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController(
          text: widget.challan.items[index].completedQuantity.toString(),
        );
        return AlertDialog(
          title: Text('Update completed qty'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                int newQty = int.parse(controller.text.trim());
                List<ChallanItem> updatedItems = List.from(
                  widget.challan.items,
                );
                updatedItems[index] = updatedItems[index].copyWith(
                  completedQuantity: newQty,
                );
                ref
                    .read(challanRepositiaryProvider)
                    .updateChallan(
                      widget.challan.copyWith(items: updatedItems),
                    );
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final challanAsync = ref.watch(challanProvider);
    return challanAsync.when(
      data: (challans) {
        final challan = challans.firstWhere(
          (c) => c.challanNo == widget.challan.challanNo,
        );
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 70,
            title: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Challan ${challan.challanNo}'),
                  SizedBox(height: 5),
                  Text(
                    'Added on ${DateFormat('dd MMM yyyy').format(challan.date)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  ref
                      .read(challanRepositiaryProvider)
                      .deleteChallan(widget.challan.challanNo);
                  Navigator.pop(context);
                },
                icon: Icon(Icons.delete),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(challanProvider);
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.black, width: 0.7),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Challan info',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Icon(Icons.receipt_long, color: Colors.grey),
                              Text(
                                'Challan no',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Spacer(),
                              Text(
                                '#${challan.challanNo}',
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
                              Icon(Icons.person, color: Colors.grey),
                              Text(
                                'Worker',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Spacer(),
                              Text(
                                challan.workersNames,
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
                              Text(
                                'Total Piece',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Spacer(),
                              Text(
                                '${challan.totalPiece.toString()}pcs',
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
                              Icon(
                                Icons.grid_view_outlined,
                                color: Colors.grey,
                              ),
                              Text(
                                'Classification',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Spacer(),
                              Text(
                                challan.classification,
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
                          for (int i = 0; i < challan.items.length; i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: GestureDetector(
                                onTap: () => editCompletedQty(i),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.checkroom,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          'Material ${i + 1}',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        Spacer(),
                                        Text(
                                          challan.items[i].materialName,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${challan.items[i].completedQuantity}/${widget.challan.items[i].quantity} done',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          SizedBox(height: 5),
                          Divider(color: Colors.grey),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.grey,
                              ),
                              Text(
                                'Given Date',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Spacer(),
                              Text(
                                DateFormat('dd MMM yyyy').format(challan.date),
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
                              Icon(
                                Icons.calendar_month_outlined,
                                color: Colors.grey,
                              ),
                              Text(
                                'Lot Came',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Spacer(),
                              Text(
                                widget.challan.lotCameDate == null
                                    ? '-'
                                    : DateFormat(
                                        'dd MMM yyyy',
                                      ).format(widget.challan.lotCameDate!),
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
                              Icon(
                                Icons.calendar_month_outlined,
                                color: Colors.grey,
                              ),
                              Text(
                                'Work Started',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Spacer(),
                              Text(
                                widget.challan.afterComingDate == null
                                    ? '-'
                                    : DateFormat(
                                        'dd MMM yyyy',
                                      ).format(widget.challan.afterComingDate!),
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
                              Icon(
                                Icons.checkroom_outlined,
                                color: Colors.grey,
                              ),
                              Text(
                                'Garment',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Spacer(),
                              Text(
                                widget.challan.garmentTypes.join(', '),
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
                              Icon(Icons.currency_rupee, color: Colors.grey),
                              Text(
                                'Total',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Spacer(),
                              Text(
                                challan.totalAmount.toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.black, width: 0.7),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Status',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.timer, color: Colors.grey),
                              SizedBox(width: 5),
                              Text(
                                'Ready Status',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Spacer(),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.green.shade50,
                                ),
                                child: Text(
                                  challan.isReady,
                                  style: TextStyle(
                                    color: Colors.green.shade700,
                                  ),
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
                                Icons.local_shipping_outlined,
                                color: Colors.grey,
                              ),
                              Text(
                                'Delivery',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Spacer(),
                              Text(
                                challan.isDelivered
                                    ? 'Delivered'
                                    : 'Not delivered yet',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    if (!challan.isDelivered && challan.isReady == 'Ready')
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          fixedSize: Size(360, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(20),
                          ),
                        ),
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2024),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            ref
                                .read(challanRepositiaryProvider)
                                .updateChallan(
                                  challan.copyWith(
                                    isDelivered: true,
                                    deliveryDate: date,
                                  ),
                                );
                          }
                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.local_shipping_outlined),
                            SizedBox(width: 10),
                            Text(
                              'Mark as delivered',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 15),
                    if (!challan.isDelivered && challan.isReady == 'Pending')
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(20),
                          ),
                          fixedSize: Size(360, 60),
                          side: BorderSide(color: Colors.green.shade200),
                        ),
                        onPressed: () async {
                          final updated = challan.copyWith(isReady: 'Ready');

                          await ref
                              .read(challanRepositiaryProvider)
                              .updateChallan(updated);
                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.done, color: Colors.green.shade700),
                            SizedBox(width: 10),
                            Text(
                              'Mark as Ready',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(20),
                        ),
                        fixedSize: Size(360, 60),
                        side: BorderSide(color: Colors.red.shade200),
                      ),
                      onPressed: () {
                        ref
                            .read(challanRepositiaryProvider)
                            .deleteChallan(challan.challanNo);
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete, color: Colors.red.shade600),
                          SizedBox(width: 10),
                          Text(
                            'Delete challan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.red.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      error: (e, st) => Text('Erorr $e'),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}

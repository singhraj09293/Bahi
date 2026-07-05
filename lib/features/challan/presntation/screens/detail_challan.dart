import 'package:challan_app/core/theme/app_theme.dart';
import 'package:challan_app/features/challan/data/models/challan_model.dart';
import 'package:challan_app/features/challan/data/repositories/challan_repository.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Challan ${widget.challan.challanNo}'),
              SizedBox(height: 5),
              Text(
                'Added on ${DateFormat('dd MMM yyyy').format(widget.challan.date)}',
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
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                    Text('Challan info', style: TextStyle(color: Colors.grey)),
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
                          '#${widget.challan.challanNo}',
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
                        Text('Worker', style: TextStyle(color: Colors.grey)),
                        Spacer(),
                        Text(
                          widget.challan.workersNames,
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
                          '${widget.challan.totalPiece.toString()}pcs',
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
                        Icon(Icons.grid_view_outlined, color: Colors.grey),
                        Text(
                          'Classification',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Spacer(),
                        Text(
                          widget.challan.classification,
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
                        Icon(Icons.calendar_today_outlined, color: Colors.grey),
                        Text(
                          'Given Date',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Spacer(),
                        Text(
                          DateFormat('dd MMM yyyy').format(widget.challan.date),
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
                            widget.challan.isReady,
                            style: TextStyle(color: Colors.green.shade700),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Divider(color: Colors.grey),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.local_shipping_outlined, color: Colors.grey),
                        Text('Delivery', style: TextStyle(color: Colors.grey)),
                        Spacer(),
                        Text(
                          widget.challan.isDelivered
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
              if (!widget.challan.isDelivered &&
                  widget.challan.isReady == 'Ready')
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
                            widget.challan.copyWith(
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
              if (!widget.challan.isDelivered &&
                  widget.challan.isReady == 'Pending')
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(20),
                    ),
                    fixedSize: Size(360, 60),
                    side: BorderSide(color: Colors.green.shade200),
                  ),
                  onPressed: () {
                    ref
                        .read(challanRepositiaryProvider)
                        .updateChallan(
                          widget.challan.copyWith(isReady: 'Ready'),
                        );
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
                      .deleteChallan(widget.challan.challanNo);
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
    );
  }
}

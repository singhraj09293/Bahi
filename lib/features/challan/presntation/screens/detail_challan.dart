import 'package:challan_app/core/theme/app_theme.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Challan ${widget.challan.challanNo}'),
              SizedBox(height: 5,),
              Text(
                'Added on ${DateFormat('dd MMM yyyy').format(widget.challan.date)}',
                style: TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.w200),
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
                  border: Border.all(color: Colors.black, width: 1),
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
            ],
          ),
        ),
      ),
    );
  }
}

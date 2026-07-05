import 'package:challan_app/core/theme/app_theme.dart';
import 'package:challan_app/features/challan/data/models/challan_model.dart';
import 'package:challan_app/features/challan/presntation/provider/challan_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class NewChallanScreen extends ConsumerStatefulWidget {
  const NewChallanScreen({super.key});

  @override
  ConsumerState<NewChallanScreen> createState() => _NewChallanScreenState();
}

class _NewChallanScreenState extends ConsumerState<NewChallanScreen> {
  String selectedWorkType = 'Embroidery';
  final List<String> workTypes = ['Embroidery', 'Handwork', 'Mirrors'];
  bool isReady = false;
  TextEditingController challannoProvider = TextEditingController();
  TextEditingController workerNameController = TextEditingController();
  TextEditingController totalPieceController = TextEditingController();
  TextEditingController classificationController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    challannoProvider.dispose();
    workerNameController.dispose();
    totalPieceController.dispose();
    classificationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'New Challan',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                DateFormat('dd MMM yyyy').format(DateTime.now()),
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (challannoProvider.text.isEmpty ||
                  workerNameController.text.isEmpty ||
                  totalPieceController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill all fields',style: TextStyle(fontWeight: FontWeight.bold),),backgroundColor: AppColors.primary,),
                );
                return;
              }
              final challan = ChallanModel(
                challanNo: challannoProvider.text.trim(),
                date: DateTime.now(),
                workersNames: '${workerNameController.text.trim()} $selectedWorkType',
                totalPiece: int.parse(totalPieceController.text.trim()),
                classification: classificationController.text.trim(),
                isReady: isReady ? 'Ready' : 'Pending',
                isDelivered: false,
                id: '',
              );
              ref.read(challanRepositiaryProvider).addChallan(challan);
              Navigator.pop(context);
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.black, width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Challan No',
                      style: TextStyle(color: AppColors.primary, fontSize: 18),
                    ),
                    Row(
                      children: [
                        Icon(Icons.tag, color: AppColors.primary),
                        SizedBox(width: 5),
                        Expanded(
                          child: TextField(
                            controller: challannoProvider,
                            decoration: InputDecoration(
                              hintText: 'e.g. 1234',
                              hintStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.black, width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Worker Name',
                      style: TextStyle(color: AppColors.primary, fontSize: 18),
                    ),
                    Row(
                      children: [
                        Icon(Icons.person, color: AppColors.primary),
                        SizedBox(width: 5),
                        Expanded(
                          child: TextField(
                            controller: workerNameController,
                            decoration: InputDecoration(
                              hintText: 'e.g. Raj Embroidery',
                              hintStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.black, width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Work Type', style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedWorkType = workTypes[0];
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: selectedWorkType == 'Embroidery'
                                  ? AppColors.primary
                                  : AppColors.background,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              'Embroidery',
                              style: TextStyle(
                                fontSize: 15,
                                color: selectedWorkType == 'Embroidery'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedWorkType = workTypes[1];
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: selectedWorkType == 'Handwork'
                                  ? AppColors.primary
                                  : AppColors.background,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              'Handwork',
                              style: TextStyle(
                                fontSize: 15,
                                color: selectedWorkType == 'Handwork'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedWorkType = workTypes[2];
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: selectedWorkType == 'Mirrors'
                              ? AppColors.primary
                              : AppColors.background,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'Mirrors',
                          style: TextStyle(
                            fontSize: 15,
                            color: selectedWorkType == 'Mirrors'
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Container(
                    width: (MediaQuery.of(context).size.width - 60) / 2,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.black, width: 0.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total pieces',
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                        Row(
                          children: [
                            Icon(Icons.layers, color: AppColors.primary),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: totalPieceController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: '0',

                                  hintStyle: TextStyle(
                                    color: Colors.grey,

                                    fontSize: 18,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width - 60) / 2,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.black, width: 0.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status',
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                        Row(
                          children: [
                            SizedBox(width: 5),
                            Text(
                              isReady ? 'Ready' : 'Pending',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                            SizedBox(width: 5),
                            Switch(
                              value: isReady,
                              activeThumbColor: AppColors.primary,
                              onChanged: (value) =>
                                  setState(() => isReady = value),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.black, width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Classification',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.grid_view_outlined,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: classificationController,
                            decoration: InputDecoration(
                              hintText: 'e.g. 50pcs X 8Colors',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.black, width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Given Date',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 10),
                        Text(
                          DateFormat('dd MMM yyyy').format(DateTime.now()),
                          style: TextStyle(fontSize: 18),
                        ),
                        Spacer(),
                        Text('Auto', style: TextStyle(color: Colors.grey)),
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

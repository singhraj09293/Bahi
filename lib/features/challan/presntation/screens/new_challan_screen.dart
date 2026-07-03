import 'package:challan_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewChallanScreen extends StatefulWidget {
  const NewChallanScreen({super.key});

  @override
  State<NewChallanScreen> createState() => _NewChallanScreenState();
}

class _NewChallanScreenState extends State<NewChallanScreen> {
  String selectedWorkType = 'Embroidery';
  final List<String> workTypes = ['Embroidery', 'Handwork', 'Mirrors'];
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
                          'Status',
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                        Row(
                          children: [
                            Icon(Icons.timer, color: AppColors.primary),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'pending',
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
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(360, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(20),
                  ),
                ),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save),
                    SizedBox(width: 10),
                    Text('Save Challan',style: TextStyle(fontSize: 18),),
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

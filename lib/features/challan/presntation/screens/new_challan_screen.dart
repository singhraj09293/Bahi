import 'package:challan_app/core/theme/app_theme.dart';
import 'package:challan_app/features/challan/data/models/challan_item.dart';
import 'package:challan_app/features/challan/data/models/challan_model.dart';
import 'package:challan_app/features/challan/presntation/provider/challan_provider.dart';
import 'package:challan_app/features/workers/presentation/provider/worker_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class NewChallanScreen extends ConsumerStatefulWidget {
  const NewChallanScreen({super.key});

  @override
  ConsumerState<NewChallanScreen> createState() => _NewChallanScreenState();
}

class _NewChallanScreenState extends ConsumerState<NewChallanScreen> {
  DateTime? lotCameDate;
  DateTime? afterComingDate;
  List<String> selectedGarments = [];
  final List<String> garmentOptions = ['Kurta', 'Pajama', 'Dupatta'];
  String? selectedWorkerId;
  String? selectedWorkerName;
  List<ChallanItem> items = [];
  TextEditingController selectedMasterName = TextEditingController();
  bool isReady = false;

  TextEditingController challannoProvider = TextEditingController();
  TextEditingController workerNameController = TextEditingController();
  TextEditingController materialController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController classificationController = TextEditingController();
  TextEditingController design = TextEditingController();
  TextEditingController designer = TextEditingController();
  final List<Color> itemColors = [
    AppColors.primary.withValues(alpha: 0.1),
    Colors.green.withValues(alpha: 0.1),
    Colors.grey.withValues(alpha: 0.1),
  ];
  int getTotalPieces() {
    int total = 0;
    for (var item in items) {
      total = total + item.quantity;
    }
    return total;
  }

  double getTotalAmount() {
    double total = 0;
    for (var item in items) {
      total = total + item.subtotal;
    }
    return total;
  }

  @override
  void dispose() {
    super.dispose();
    challannoProvider.dispose();
    workerNameController.dispose();
    selectedMasterName.dispose();
    classificationController.dispose();
    design.dispose();
    designer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workerAsync = ref.watch(workerProvider);
   
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
                
                  design.text.isEmpty ||
                  designer.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Please fill all fields',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: AppColors.primary,
                  ),
                );
                return;
              }
              final challan = ChallanModel(
                challanNo: challannoProvider.text.trim(),
                date: DateTime.now(),
                workersNames: selectedWorkerName ?? '',
                totalPiece: items.fold(0, (s, i) => s + i.quantity),
                classification: classificationController.text.trim(),
                isReady: isReady ? 'Ready' : 'Pending',
                isDelivered: false,
                workerid: selectedWorkerId ?? '',
                items: items,
                lotCameDate: lotCameDate,
                afterComingDate: afterComingDate,
                garmentTypes: selectedGarments,
                sethName: selectedMasterName.text.trim(),
                design: design.text.trim(),
                designer: designer.text.trim(),
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
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
                            keyboardType: TextInputType.number,
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
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: workerAsync.when(
                  data: (worker) => DropdownButtonFormField<String>(
                    initialValue: selectedWorkerId,
                    hint: Text('Select Worker'),
                    decoration: InputDecoration(border: InputBorder.none),
                    items: worker
                        .map(
                          (w) => DropdownMenuItem(
                            value: w.workerId,
                            child: Text('${w.workerName}'),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedWorkerId = value;
                        selectedWorkerName = worker
                            .firstWhere((w) => w.workerId == value)
                            .workerName;
                      });
                    },
                  ),
                  error: (e, st) => Text('Error $e'),
                  loading: () => Center(child: CircularProgressIndicator()),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: selectedMasterName,
                  decoration: InputDecoration(
                    hintText: 'Enter Seth Name',
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Garment Type',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                    Wrap(
                      spacing: 10,
                      children: garmentOptions.map((g) {
                        final selected = selectedGarments.contains(g);
                        return FilterChip(
                          label: Text(g),
                          selected: selected,
                          selectedColor: AppColors.primary,
                          onSelected: (val) {
                            setState(() {
                              if (val) {
                                selectedGarments.add(g);
                              } else {
                                selectedGarments.remove(g);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: design,
                      decoration: InputDecoration(
                        hintText: 'Design type',
                        border: InputBorder.none
                      ),
                    ),
                    SizedBox(height: 5,),
                     TextField(
                      controller: designer,
                      decoration: InputDecoration(
                        hintText: 'Designer Name',
                        border: InputBorder.none
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
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
                          style: TextStyle(color: Colors.black, fontSize: 17),
                        ),
                        Spacer(),
                        Switch(
                          value: isReady,
                          activeThumbColor: AppColors.primary,
                          onChanged: (value) => setState(() => isReady = value),
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
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
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2030),
                        );
                        if (date != null) setState(() => lotCameDate = date);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 10),
                          Text('Lot Came Date'),
                          Spacer(),
                          Text(
                            lotCameDate == null
                                ? 'Select'
                                : DateFormat(
                                    'dd MMM yyyy',
                                  ).format(lotCameDate!),
                          ),
                        ],
                      ),
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
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

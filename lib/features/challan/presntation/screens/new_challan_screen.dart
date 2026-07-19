import 'package:challan_app/core/theme/app_theme.dart';
import 'package:challan_app/features/challan/data/models/challan_item.dart';
import 'package:challan_app/features/challan/data/models/challan_model.dart';
import 'package:challan_app/features/challan/presntation/provider/challan_provider.dart';
import 'package:challan_app/features/seth/presentation/provider/seth_provider.dart';
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
  String? selectedMasterId;
  String? selectedMasterName;
  bool isReady = false;

  TextEditingController challannoProvider = TextEditingController();
  TextEditingController workerNameController = TextEditingController();
  TextEditingController materialController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController classificationController = TextEditingController();
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

    classificationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workerAsync = ref.watch(workerProvider);
    final sethAsync = ref.watch(sethProvider);
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
                  selectedWorkerName!.isEmpty) {
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
                sethid: selectedMasterId ?? '',
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
                child: sethAsync.when(
                  data: (master) {
                    return DropdownButtonFormField<String>(
                      initialValue: selectedMasterId,
                      hint: Text('Select Master'),
                      decoration: InputDecoration(border: InputBorder.none),
                      items: master
                          .map(
                            (m) => DropdownMenuItem(
                              value: m.masterId,
                              child: Text( m.masterName),
                            ),
                          )
                          .toList(),
                          onChanged: (value) => setState(() {
                            selectedMasterId=value;
                            selectedMasterName=master.firstWhere((m)=>m.masterId==value).masterName;
                          }),
                    );
                  },
                  error: (e, st) => Text('error $e'),
                  loading: () => Center(child: CircularProgressIndicator()),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(12),
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
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Items',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),

                    TextField(
                      controller: materialController,
                      decoration: InputDecoration(
                        hintText: 'Material',
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: qtyController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Qty',
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: rateController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Rate per piece',
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (rateController.text.isEmpty ||
                                qtyController.text.isEmpty ||
                                materialController.text.isEmpty) {
                              return;
                            }
                            setState(() {
                              items.add(
                                ChallanItem(
                                  materialName: materialController.text.trim(),
                                  quantity: int.parse(
                                    qtyController.text.trim(),
                                  ),
                                  ratePerPiece: double.parse(
                                    rateController.text.trim(),
                                  ),
                                ),
                              );
                              materialController.clear();
                              qtyController.clear();
                              rateController.clear();
                            });
                          },
                          child: Text('+ Add items'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              if (items.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Items',
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      for (int i = 0; i < items.length; i++)
                        Container(
                          margin: EdgeInsets.only(bottom: 8),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: itemColors[i % itemColors.length],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(items[i].materialName),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  '${items[i].quantity} x ${items[i].ratePerPiece}',
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '₹${items[i].subtotal}',
                                  textAlign: TextAlign.right,
                                ),
                              ),

                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 23,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                onPressed: () =>
                                    setState(() => items.removeAt(i)),
                              ),
                            ],
                          ),
                        ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${getTotalPieces()} pcs · ₹${getTotalAmount()}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
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
                    Divider(),
                    GestureDetector(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2030),
                        );
                        if (date != null)
                          setState(() => afterComingDate = date);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 10),
                          Text('After Coming Date'),
                          Spacer(),
                          Text(
                            afterComingDate == null
                                ? 'Select'
                                : DateFormat(
                                    'dd MMM yyyy',
                                  ).format(afterComingDate!),
                          ),
                        ],
                      ),
                    ),
                  ],
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

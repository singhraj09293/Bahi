import 'package:challan_app/core/theme/app_theme.dart';
import 'package:challan_app/features/workers/data/model/worker_model.dart';
import 'package:challan_app/features/workers/presentation/provider/worker_provider.dart';
import 'package:challan_app/features/workers/presentation/screens/worker_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkerScreen extends ConsumerStatefulWidget {
  const WorkerScreen({super.key});

  @override
  ConsumerState<WorkerScreen> createState() => _WorkerScreenState();
}

class _WorkerScreenState extends ConsumerState<WorkerScreen> {
  String selectedWorkType = 'Embroidery';
  final List<String> workTypes = ['Embroidery', 'Handwork', 'Mirrors'];
  TextEditingController workerName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final worker = ref.watch(workerProvider);
    return worker.when(
      data: (work) {
        return Scaffold(
          appBar: AppBar(title: Text('Worker')),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: work.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => WorkerDetail(worker: work[index],)),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(15),
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black, width: 0.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Name : ${work[index].workerName}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Type ${work[index].workerType}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      await ref
                                          .read(workerRepositoryProvider)
                                          .deleteWorker(work[index].workerId);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => StatefulBuilder(
                  builder: (context, setDialogState) => AlertDialog(
                    title: Text('Add Worker'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: workerName,
                          decoration: InputDecoration(
                            hintText: 'Worker Name',
                            border: InputBorder.none,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setDialogState(() {
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
                                setDialogState(() {
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
                            setDialogState(() {
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
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await ref
                              .read(workerRepositoryProvider)
                              .addWorker(
                                WorkerModel(
                                  workerId: DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString(),
                                  workerName: workerName.text.trim(),
                                  workerType: selectedWorkType,
                                ),
                              );
                          Navigator.pop(context);
                        },
                        child: Text('Save'),
                      ),
                    ],
                  ),
                ),
              );
            },
            label: Text('Add Worker'),
            icon: Icon(Icons.add),
          ),
        );
      },
      error: (e, st) => Text('Error $e'),
      loading: (() => Center(child: CircularProgressIndicator())),
    );
  }
}

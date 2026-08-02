import 'package:challan_app/core/theme/app_theme.dart';
import 'package:challan_app/features/workers/data/model/worker_model.dart';
import 'package:challan_app/features/workers/presentation/provider/worker_provider.dart';
import 'package:challan_app/features/workers/presentation/screens/worker_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

class WorkerScreen extends ConsumerStatefulWidget {
  const WorkerScreen({super.key});

  @override
  ConsumerState<WorkerScreen> createState() => _WorkerScreenState();
}

class _WorkerScreenState extends ConsumerState<WorkerScreen> {
  TextEditingController workerName = TextEditingController();
  
  final List<Color> avatarColors = [
    Colors.orange[100]!,
    Colors.green[100]!,
    Colors.blue[100]!,
    Colors.purple[100]!,
  ];
  final List<Color> textColors = [
    Colors.orange.shade800,
    Colors.green.shade800,
    Colors.blue.shade800,
    Colors.purple.shade800,
  ];
  @override
  void dispose() {
   workerName.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    final worker = ref.watch(workerProvider);
    return worker.when(
      data: (work) {
        return Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: work.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WorkerDetail(worker: work[index]),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 7.0,
                            horizontal: 15,
                          ),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor:
                                      avatarColors[index % avatarColors.length],
                                  child: Text(
                                    work[index].workerName[0].toUpperCase(),
                                    style: TextStyle(
                                      color:
                                          textColors[index % textColors.length],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          work[index].workerName,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                        onPressed: () async {
                                          await ref
                                              .read(workerRepositoryProvider)
                                              .deleteWorker(
                                                work[index].workerId,
                                              );
                                        },
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: AppColors.primary,
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
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton.extended(
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
                                      userId: FirebaseAuth.instance.currentUser!.uid,
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
            ),
          ],
        );
      },
      error: (e, st) => Text('Error $e'),
      loading: (() => Center(child: CircularProgressIndicator())),
    );
  }
}

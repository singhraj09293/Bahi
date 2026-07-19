import 'package:challan_app/core/theme/app_theme.dart';
import 'package:challan_app/features/seth/data/model/seth_model.dart';
import 'package:challan_app/features/seth/presentation/provider/seth_provider.dart';
import 'package:challan_app/features/seth/presentation/screen/seth_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SethsScreen extends ConsumerStatefulWidget {
  const SethsScreen({super.key});

  @override
  ConsumerState<SethsScreen> createState() => _SethsScreenState();
}

class _SethsScreenState extends ConsumerState<SethsScreen> {
  TextEditingController sethName = TextEditingController();
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
  Widget build(BuildContext context) {
    final seth = ref.watch(sethProvider);
    return seth.when(
      data: (seth) {
        return Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: seth.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SethDetail(seth: seth[index]),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 7.0,
                            horizontal: 15,
                          ),
                          child: Container(
                            padding: EdgeInsets.all(20),
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
                                  radius: 35,
                                  backgroundColor:
                                      avatarColors[index % avatarColors.length],
                                  child: Text(
                                    seth[index].masterName[0].toUpperCase(),
                                    style: TextStyle(
                                      color:
                                          textColors[index % textColors.length],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 22,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            ' ${seth[index].masterName}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              height: 1.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                seth[index].masterId,
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Spacer(),
                                              IconButton(
                                                padding: EdgeInsets.zero,
                                                constraints: BoxConstraints(),
                                                onPressed: () async {
                                                  await ref
                                                      .read(
                                                        masterRepositoryProvider,
                                                      )
                                                      .deleteSeth(
                                                        seth[index].masterId,
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
                        title: Text('Add Master'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: sethName,
                              decoration: InputDecoration(
                                hintText: 'Master Name',
                                border: InputBorder.none,
                              ),
                            ),
                            SizedBox(height: 10),
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
                                  .read(masterRepositoryProvider)
                                  .addSeth(
                                    SethModel(
                                      masterId: DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString(),
                                      masterName: sethName.text.trim(),
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
                label: Text('Add Master'),
                icon: Icon(Icons.add),
              ), // unchanged
            ),
          ],
        );
      },
      error: (e, st) => Text('Erorr $e'),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}

import 'package:challan_app/core/theme/app_theme.dart';
import 'package:challan_app/features/challan/presntation/provider/challan_provider.dart';
import 'package:challan_app/features/challan/presntation/screens/detail_challan.dart';
import 'package:challan_app/features/challan/presntation/screens/new_challan_screen.dart';
import 'package:challan_app/features/challan/presntation/screens/setting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});
  Color getIconBg(dynamic c) {
    if (c.isDelivered) return Colors.blue.shade50;
    if (c.isReady == 'Ready') return Colors.green.shade50;
    return Colors.orange.shade50;
  }

  Color getIconColor(dynamic c) {
    if (c.isDelivered) return Colors.blue.shade700;
    if (c.isReady == 'Ready') return Colors.green.shade700;
    return Colors.orange.shade700;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challan = ref.watch(challanProvider);
    return challan.when(
      data: (challans) {
        int total = challans.length;
        int pending = challans.where((c) => c.isReady == 'Pending').length;
        int completed = challans.where((c) => c.isDelivered == true).length;
        int totalPiece = challans.fold(0, (sum, c) => sum + c.totalPiece);
        final recent = challans.take(3).toList();
        Map<String, int> masterCounts = {};
        for (var c in challans) {
          if (c.sethName.isNotEmpty) {
            masterCounts[c.sethName] = (masterCounts[c.sethName] ?? 0) + 1;
          }
        }
        final name = FirebaseAuth.instance.currentUser?.displayName ?? 'U';
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primary.withValues(alpha: 0.90),
            toolbarHeight: 60,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Bahi',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => Setting()),
                    );
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Text(
                      name[0].toUpperCase(),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back!',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    "Here's what's happening today.",
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.3,
                    ),
                    itemCount: masterCounts.length,
                    itemBuilder: (context, index) {
                      final name = masterCounts.keys.elementAt(index);
                      final count = masterCounts.values.elementAt(index);
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
                      return Container(
                        decoration: BoxDecoration(
                          color: avatarColors[index % avatarColors.length],
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  color: textColors[index % textColors.length],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '${count} Lotts',
                                style: TextStyle(
                                  color: textColors[index % textColors.length],
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Challan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: recent.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                DetailChallan(challan: recent[index]),
                          ),
                        ),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(
                              'Challan ${recent[index].challanNo}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            leading: Container(
                              width: 42,
                              height: 42,

                              decoration: BoxDecoration(
                                color: getIconBg(recent[index]),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.checkroom,
                                color: getIconColor(recent[index]),
                              ),
                            ),
                            subtitle: Text(recent[index].classification),
                            trailing: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: recent[index].isDelivered
                                    ? Colors.blue.shade50
                                    : recent[index].isReady == 'Pending'
                                    ? Colors.orange.shade50
                                    : Colors.green.shade50,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                recent[index].isDelivered
                                    ? 'Delivered'
                                    : recent[index].isReady == 'Pending'
                                    ? 'Pending'
                                    : 'Ready',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: recent[index].isDelivered
                                      ? Colors.blue.shade700
                                      : recent[index].isReady == 'Pending'
                                      ? Colors.orange.shade700
                                      : Colors.green.shade700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.primary,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NewChallanScreen()),
              );
            },
            child: Icon(Icons.add),
          ),
        );
      },
      error: (e, stackTrace) => Text('Error $e'),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}

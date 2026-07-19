import 'package:challan_app/core/theme/app_theme.dart';
import 'package:challan_app/features/challan/data/models/challan_model.dart';
import 'package:challan_app/features/challan/presntation/provider/challan_provider.dart';
import 'package:challan_app/features/challan/presntation/screens/detail_challan.dart';
import 'package:challan_app/features/challan/presntation/screens/new_challan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChallanListScreen extends ConsumerStatefulWidget {
  const ChallanListScreen({super.key});

  @override
  ConsumerState<ChallanListScreen> createState() => _ChallanListScreenState();
}

class _ChallanListScreenState extends ConsumerState<ChallanListScreen> {
  String selectedFilter = 'All';
  final List<String> filters = ['All', 'Pending', 'Ready', 'Delivered'];
  TextEditingController search = TextEditingController();
  String searchQuery = '';
  bool newestFirst = true;
  Color getBadgeColor(ChallanModel challan) {
    if (challan.isDelivered) return Colors.blue.shade50;
    if (challan.isReady == 'Ready') return Colors.green.shade50;
    return Colors.orange.shade50;
  }

  Color getBadgeTextColor(ChallanModel challan) {
    if (challan.isDelivered) return Colors.blue.shade700;
    if (challan.isReady == 'Ready') return Colors.green.shade700;
    return Colors.orange.shade700;
  }

  String getBadgeText(ChallanModel challan) {
    if (challan.isDelivered) return 'Delivered';
    if (challan.isReady == 'Ready') return 'Ready';
    return 'Pending';
  }

  @override
  Widget build(BuildContext context) {
    final challan = ref.watch(challanProvider);

    return challan.when(
      data: (challans) {
        int total = challans.length;
        int pending = challans.where((c) => c.isReady == 'pending').length;
        int ready = challans.where((c) => c.isReady == 'ready').length;
        int completed = challans.where((c) => c.isDelivered == true).length;
        int active = challans.where((c) => c.isDelivered == false).length;

        // After filter chips add filtered list
        final filtered = selectedFilter == 'All'
            ? challans
            : selectedFilter == 'Delivered'
            ? challans.where((c) => c.isDelivered).toList()
            : challans.where((c) => c.isReady == selectedFilter).toList();
        final sorted = [...filtered]
          ..sort(
            (a, b) => newestFirst
                ? b.date.compareTo(a.date)
                : a.date.compareTo(b.date),
          );
        final searched = searchQuery.isEmpty
            ? sorted
            : sorted
                  .where(
                    (c) =>
                        c.challanNo.toLowerCase().contains(searchQuery) ||
                        c.workersNames.toLowerCase().contains(searchQuery),
                  )
                  .toList();

        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 65,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Challans', style: TextStyle(fontSize: 23)),
                SizedBox(height: 5),
                Row(
                  children: [
                    Text('$active Active', style: TextStyle(fontSize: 12)),
                    SizedBox(width: 5),
                    Text('· $pending Pending', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text('Newest first'),
                          leading: Icon(Icons.arrow_downward),
                          trailing: newestFirst
                              ? Icon(Icons.check, color: AppColors.primary)
                              : null,
                          onTap: () {
                            print('newestFirst: $newestFirst');
                            setState(() {
                              newestFirst = true;
                            });
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text('Oldest first'),
                          leading: Icon(Icons.arrow_upward),
                          trailing: !newestFirst
                              ? Icon(Icons.check, color: AppColors.primary)
                              : null,
                          onTap: () {
                            setState(() {
                              newestFirst = false;
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(Icons.tune),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 380,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: search,
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase();
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      hintText: 'Search by worker,challan no..',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() {
                        selectedFilter = filters[0];
                      }),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          color: selectedFilter == 'All'
                              ? AppColors.primary
                              : Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          'All',
                          style: TextStyle(
                            color: selectedFilter == 'All'
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() {
                        selectedFilter = filters[1];
                      }),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          color: selectedFilter == 'Pending'
                              ? AppColors.primary
                              : Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          'Pending',
                          style: TextStyle(
                            color: selectedFilter == 'Pending'
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() {
                        selectedFilter = filters[2];
                      }),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          color: selectedFilter == 'Ready'
                              ? AppColors.primary
                              : Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          'Ready',
                          style: TextStyle(
                            color: selectedFilter == 'Ready'
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() {
                        selectedFilter = filters[3];
                      }),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          color: selectedFilter == 'Delivered'
                              ? AppColors.primary
                              : Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          'Delivered',
                          style: TextStyle(
                            color: selectedFilter == 'Delivered'
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(challanProvider);
                    },
                    child: ListView.builder(
                      itemCount: searched.length,
                      itemBuilder: ((context, index) {
                        final c = searched[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailChallan(challan: c),
                            ),
                          ),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      c.challanNo,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 23,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 15,
                                      ),
                                      decoration: BoxDecoration(
                                        color: getBadgeColor(c),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(
                                        getBadgeText(c),
                                        style: TextStyle(
                                          color: getBadgeTextColor(c),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${c.workersNames} ·${c.totalPiece}pcs',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  c.classification,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),

                                Divider(color: AppColors.primary),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Given ${DateFormat('dd MMM yyyy').format(c.date)}',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      c.isDelivered
                                          ? 'Delivered: ${DateFormat('dd MMM yyyy').format(c.deliveryDate!)}'
                                          : 'No delivery yet',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NewChallanScreen()),
              );
            },
            backgroundColor: AppColors.primary,
            label: Text('New Challan', style: TextStyle(color: Colors.white)),
            icon: Icon(Icons.add, color: Colors.white),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
      error: (e, st) => Text('Error $e'),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}

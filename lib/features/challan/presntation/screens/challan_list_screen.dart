import 'package:challan_app/core/theme/app_theme.dart';
import 'package:challan_app/features/challan/presntation/provider/challan_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChallanListScreen extends ConsumerWidget {
  const ChallanListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challan = ref.watch(challanProvider);
    return challan.when(
      data: (challans) {
        int total = challans.length;
        int pending = challans.where((c) => c.isReady == 'pending').length;
        int ready = challans.where((c) => c.isReady == 'ready').length;
        int completed = challans.where((c) => c.isDelivered == true).length;
        int active = challans.where((c) => c.isDelivered == false).length;
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
            actions: [IconButton(onPressed: () {}, icon: Icon(Icons.tune))],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
            child: Column(
              children: [
                Container(
                  width: 380,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 0.5),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      hintText: 'Search by worker,challan no..',
                      hintStyle: TextStyle(color: Colors.grey,fontSize: 20),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      error: (e, st) => Text('Error $e'),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}

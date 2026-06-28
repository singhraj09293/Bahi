import 'package:challan_app/features/challan/data/repositories/challan_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final challanRepositiaryProvider = Provider((ref) => ChallanRepository());

final challanProvider = StreamProvider((ref) {
  final repository = ref.watch(challanRepositiaryProvider);
  return repository.getChallan();
});

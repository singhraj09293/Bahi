import 'package:challan_app/features/seth/data/repositories/seth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final masterRepositoryProvider = Provider((ref) => SethRepository());

final sethProvider = StreamProvider((ref) {
  final seth = ref.watch(masterRepositoryProvider);
  return seth.getSeth();
});
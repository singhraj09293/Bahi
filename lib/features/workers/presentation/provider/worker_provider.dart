import 'package:challan_app/features/workers/data/repositories/worker_repositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final workerRepositoryProvider = Provider((ref) => WorkerRepositories());

final workerProvider = StreamProvider((ref) {
  final worker = ref.watch(workerRepositoryProvider);
  return worker.getWorker();
});

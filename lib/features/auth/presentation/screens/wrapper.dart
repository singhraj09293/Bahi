import 'package:challan_app/features/auth/presentation/provider/auth_provider.dart';
import 'package:challan_app/features/auth/presentation/screens/login_screen.dart';
import 'package:challan_app/features/challan/presntation/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Wrapper extends ConsumerWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProvider = ref.watch(authStateProvider);
    return authProvider.when(
      data: (user) => user != null ? MainScreen() : LoginScreen(),
      error: ((e, st) =>
          ScaffoldMessenger(child: SnackBar(content: Text('Oops $e')))),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}

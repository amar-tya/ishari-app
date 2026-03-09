import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/core/env/app_env.dart';
import 'package:ishari/core/router/app_router.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ishari/injection_container.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Validate all required env variables are present.
  //    Run with: flutter run --dart-define-from-file=env/dev.json
  AppEnv.validate();

  // 2. Initialize Supabase using env values
  await Supabase.initialize(
    url: AppEnv.supabaseUrl,
    anonKey: AppEnv.supabaseAnonKey,
  );

  // 3. Register all dependencies via get_it + injectable
  await configureDependencies();

  runApp(const IshariApp());
}

class IshariApp extends StatelessWidget {
  const IshariApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => sl<AuthBloc>()..add(const AuthEvent.checkAuthStatus()),
      child: Builder(
        builder: (context) {
          final router = createRouter(context.read<AuthBloc>());
          return MaterialApp.router(
            title: 'Ishari',
            debugShowCheckedModeBanner: AppEnv.isDevelopment,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
              useMaterial3: true,
            ),
            routerConfig: router,
          );
        },
      ),
    );
  }
}

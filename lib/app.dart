import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/core/analytics/analytics_service.dart';
import 'package:ishari/core/env/app_env.dart';
import 'package:ishari/core/router/app_router.dart';
import 'package:ishari/core/wizard/wizard_cubit.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ishari/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:ishari/features/update/presentation/cubit/update_cubit.dart';
import 'package:ishari/injection_container.dart';

class IshariApp extends StatelessWidget {
  const IshariApp({
    required this.authBloc,
    required this.initialLocation,
    super.key,
  });

  final AuthBloc authBloc;
  final String initialLocation;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: authBloc),
        BlocProvider<NotificationsBloc>.value(
          value: sl<NotificationsBloc>(),
        ),
        BlocProvider<UpdateCubit>.value(
          value: sl<UpdateCubit>(),
        ),
        BlocProvider<WizardCubit>.value(
          value: sl<WizardCubit>(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final router = createRouter(
            authBloc,
            sl<AnalyticsService>(),
            initialLocation: initialLocation,
          );
          return MaterialApp.router(
            title: 'Ishari',
            debugShowCheckedModeBanner: AppEnv.isDevelopment,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF51C878),
              ),
              useMaterial3: true,
            ),
            routerConfig: router,
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/core/app_state.dart';
import 'package:ishari/features/auth/domain/entities/user_entity.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const routePath = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ishari'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () {
              if (AppState.isGuestMode.value) {
                AppState.isGuestMode.value = false;
              } else {
                context.read<AuthBloc>().add(const AuthEvent.signOut());
              }
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: AppState.isGuestMode,
        builder: (context, isGuest, _) {
          if (isGuest) return const _GuestBody();
          return BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return state.maybeWhen(
                authenticated: (user) => _AuthenticatedBody(user: user),
                loading: () => const Center(child: CircularProgressIndicator()),
                orElse: () => const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}

class _GuestBody extends StatelessWidget {
  const _GuestBody();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            child: Icon(Icons.person_outline, size: 40),
          ),
          SizedBox(height: 16),
          Text('Halo, Tamu!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          Text(
            'Mode tamu aktif — bookmark tidak tersimpan.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _AuthenticatedBody extends StatelessWidget {
  const _AuthenticatedBody({required this.user});

  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (user.avatarUrl != null)
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(user.avatarUrl!),
            )
          else
            const CircleAvatar(
              radius: 40,
              child: Icon(Icons.person, size: 40),
            ),
          const SizedBox(height: 16),
          Text(
            user.displayName ?? 'Welcome!',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            user.email,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

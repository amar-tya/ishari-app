import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ishari/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:ishari/features/notifications/presentation/widgets/empty_notifications_widget.dart';
import 'package:ishari/features/notifications/presentation/widgets/notification_card.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  static const routePath = '/notifications';

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _hasMarkedSeen = false;

  @override
  void initState() {
    super.initState();
    // Guest: update last_seen_at immediately on page open, regardless of load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final isGuest = context.read<AuthBloc>().state.maybeWhen(
            authenticated: (_) => false,
            orElse: () => true,
          );
      if (isGuest && !_hasMarkedSeen) {
        _hasMarkedSeen = true;
        context.read<NotificationsBloc>().add(
              const NotificationsEvent.markAllRead(),
            );
      }
    });
  }

  void _markAllReadForAuth(BuildContext context) {
    if (_hasMarkedSeen) return;
    final userId = context.read<AuthBloc>().state.maybeWhen(
          authenticated: (user) => user.id,
          orElse: () => null,
        );
    if (userId == null) return;

    final bloc = context.read<NotificationsBloc>();
    final unreadIds = bloc.state.mapOrNull(
          loaded: (s) => s.notifications
              .where((n) => !n.isRead)
              .map((n) => n.id)
              .toList(),
        ) ??
        [];

    _hasMarkedSeen = true;
    bloc.add(
      NotificationsEvent.markAllRead(
        userId: userId,
        notificationIds: unreadIds,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111111),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          color: const Color(0xFF555555),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<NotificationsBloc, NotificationsState>(
        listener: (context, state) {
          state.mapOrNull(
            loaded: (s) {
              if (s.unreadCount > 0) {
                _markAllReadForAuth(context);
              }
            },
          );
        },
        builder: (context, state) => state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Color(0xFF51C878)),
            ),
          ),
          error: (message) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF555555)),
              ),
            ),
          ),
          loaded: (notifications, _) => notifications.isEmpty
              ? const EmptyNotificationsWidget()
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: notifications.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) =>
                      NotificationCard(notification: notifications[index]),
                ),
        ),
      ),
    );
  }
}

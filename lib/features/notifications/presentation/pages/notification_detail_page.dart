import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ishari/features/notifications/domain/entities/notification_entity.dart';
import 'package:ishari/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationDetailPage extends StatefulWidget {
  const NotificationDetailPage({required this.notification, super.key});

  final NotificationEntity notification;

  static String routePath(String id) => '/notifications/$id';

  @override
  State<NotificationDetailPage> createState() =>
      _NotificationDetailPageState();
}

class _NotificationDetailPageState extends State<NotificationDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || widget.notification.isRead) return;
      final userId = context.read<AuthBloc>().state.maybeWhen(
            authenticated: (user) => user.id,
            orElse: () => null,
          );
      if (userId == null) return;
      context.read<NotificationsBloc>().add(
            NotificationsEvent.markAllRead(
              userId: userId,
              notificationIds: [widget.notification.id],
            ),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final notification = widget.notification;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Detail Notifikasi',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111111),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          color: const Color(0xFF555555),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type badge + date
            Row(
              children: [
                _TypeBadge(type: notification.type),
                const Spacer(),
                Text(
                  _formatDate(notification.publishedAt),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Image
            if (notification.imageUrl != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  notification.imageUrl!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Card content
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE8EDE6)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    notification.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111111),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 12),

                  // Content
                  MarkdownBody(
                    data: notification.content ?? notification.body,
                    onTapLink: (_, href, _) {
                      if (href != null) unawaited(_launchUrl(href));
                    },
                    styleSheet: MarkdownStyleSheet(
                      p: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF444444),
                        height: 1.7,
                      ),
                      h1: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111111),
                        height: 1.4,
                      ),
                      h2: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111111),
                        height: 1.4,
                      ),
                      h3: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111111),
                        height: 1.4,
                      ),
                      strong: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111111),
                      ),
                      em: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF444444),
                      ),
                      code: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF111111),
                        backgroundColor: Color(0xFFF0F5EE),
                        fontFamily: 'monospace',
                      ),
                      codeblockDecoration: BoxDecoration(
                        color: const Color(0xFFF0F5EE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      blockquoteDecoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: const Color(0xFFCAFF00)
                                .withValues(alpha: 0.8),
                            width: 4,
                          ),
                        ),
                      ),
                      listBullet: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF444444),
                      ),
                      a: const TextStyle(
                        color: Color(0xFF4CAF50),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // CTA button
            if (notification.actionUrl != null) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _launchUrl(notification.actionUrl!),
                  icon: const Icon(Icons.open_in_new_rounded, size: 16),
                  label: const Text('Buka Tautan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF111111),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

  final String type;

  String get _label => switch (type) {
        'update' => 'Pembaruan',
        'warning' => 'Peringatan',
        'promo' => 'Promo',
        _ => 'Info',
      };

  Color get _bgColor => switch (type) {
        'update' => const Color(0xFFE8F4FD),
        'warning' => const Color(0xFFFFF8E1),
        'promo' => const Color(0xFFF3E5F5),
        _ => const Color(0xFFE8F5E9),
      };

  Color get _textColor => switch (type) {
        'update' => const Color(0xFF2196F3),
        'warning' => const Color(0xFFFFA000),
        'promo' => const Color(0xFF9C27B0),
        _ => const Color(0xFF4CAF50),
      };

  IconData get _icon => switch (type) {
        'update' => Icons.system_update_rounded,
        'warning' => Icons.warning_amber_rounded,
        'promo' => Icons.local_offer_rounded,
        _ => Icons.info_outline_rounded,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 12, color: _textColor),
          const SizedBox(width: 4),
          Text(
            _label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _textColor,
            ),
          ),
        ],
      ),
    );
  }
}

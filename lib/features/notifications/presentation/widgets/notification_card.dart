import 'package:flutter/material.dart';
import 'package:ishari/features/notifications/domain/entities/notification_entity.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key, required this.notification});

  final NotificationEntity notification;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            notification.isRead ? Colors.white : const Color(0xFFF0FAE8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notification.isRead
              ? const Color(0xFFE8EDE6)
              : const Color(0xFFCAFF00).withValues(alpha: 0.6),
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TypeIcon(type: notification.type),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: notification.isRead
                              ? FontWeight.w600
                              : FontWeight.w700,
                          color: const Color(0xFF111111),
                        ),
                      ),
                    ),
                    if (!notification.isRead)
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(left: 6, top: 2),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF4D4F),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification.body,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF555555),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _formatDate(notification.publishedAt),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return 'Hari ini';
    if (diff.inDays == 1) return 'Kemarin';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} minggu lalu';
    return '${(diff.inDays / 30).floor()} bulan lalu';
  }
}

class _TypeIcon extends StatelessWidget {
  const _TypeIcon({required this.type});

  final String type;

  IconData get _icon => switch (type) {
        'update' => Icons.system_update_rounded,
        'warning' => Icons.warning_amber_rounded,
        'promo' => Icons.local_offer_rounded,
        _ => Icons.info_outline_rounded,
      };

  Color get _bgColor => switch (type) {
        'update' => const Color(0xFFE8F4FD),
        'warning' => const Color(0xFFFFF8E1),
        'promo' => const Color(0xFFF3E5F5),
        _ => const Color(0xFFE8F5E9),
      };

  Color get _iconColor => switch (type) {
        'update' => const Color(0xFF2196F3),
        'warning' => const Color(0xFFFFA000),
        'promo' => const Color(0xFF9C27B0),
        _ => const Color(0xFF4CAF50),
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(color: _bgColor, shape: BoxShape.circle),
      child: Icon(_icon, color: _iconColor, size: 18),
    );
  }
}

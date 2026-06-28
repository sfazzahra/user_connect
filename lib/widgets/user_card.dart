import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../theme/app_theme.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback onTap;

  const UserCard({super.key, required this.user, required this.onTap});

  static const List<Color> _avatarColors = [
    Color(0xFF7C3AED),
    Color(0xFFF59E0B),
    Color(0xFF16A34A),
    Color(0xFFE11D48),
    Color(0xFFD946EF),
    Color(0xFFEA580C),
  ];

  Color get _avatarColor => _avatarColors[user.id % _avatarColors.length];

  String get _initials {
    final parts = user.name.trim().split(' ');
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final avatarColor = _avatarColor;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppColors.cardShadow,
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [avatarColor, avatarColor.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(color: avatarColor.withOpacity(0.28), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  _initials,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.mail_outline_rounded, size: 13, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            user.email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        user.company,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(color: AppColors.primarySoft, shape: BoxShape.circle),
                child: const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
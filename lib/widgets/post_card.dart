import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../theme/app_theme.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PostCard({super.key, required this.post, required this.onEdit, required this.onDelete});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final accentColor = post.isPending ? AppColors.accent : AppColors.primary;

    return AnimatedOpacity(
      opacity: post.isPending ? 0.6 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: AppColors.cardShadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 4,
                  color: accentColor,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 16, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                post.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15.5,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            if (post.isPending)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withOpacity(0.14),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 10,
                                      height: 10,
                                      child: CircularProgressIndicator(strokeWidth: 1.6, color: AppColors.accentDark),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Menyimpan',
                                      style: TextStyle(fontSize: 10.5, color: AppColors.accentDark, fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              )
                            else ...[
                              _RoundIconButton(icon: Icons.edit_outlined, color: AppColors.primary, onTap: widget.onEdit),
                              const SizedBox(width: 6),
                              _RoundIconButton(icon: Icons.delete_outline_rounded, color: AppColors.danger, onTap: widget.onDelete),
                            ],
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          post.body,
                          maxLines: _expanded ? null : 3,
                          overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13.5, color: AppColors.textSecondary, height: 1.45),
                        ),
                        if (post.body.length > 110)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: GestureDetector(
                              onTap: () => setState(() => _expanded = !_expanded),
                              child: Text(
                                _expanded ? 'Sembunyikan' : 'Baca selengkapnya',
                                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _RoundIconButton({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}
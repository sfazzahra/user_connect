import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../providers/post_provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/add_edit_post_sheet.dart';
import '../widgets/post_card.dart';
import '../widgets/shimmer_box.dart';
import '../widgets/state_widgets.dart';

class PostDetailScreen extends StatefulWidget {
  final UserModel user;
  const PostDetailScreen({super.key, required this.user});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PostProvider()..fetchPosts(widget.user.id),
      child: _PostDetailBody(user: widget.user),
    );
  }
}

class _PostDetailBody extends StatelessWidget {
  final UserModel user;
  const _PostDetailBody({required this.user});

  void _showSnackbar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
                color: isError ? AppColors.danger : AppColors.success, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }

  void _openAddSheet(BuildContext context) {
    final provider = context.read<PostProvider>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => AddEditPostSheet(
        onSubmit: (title, body) async {
          await provider.addPost(userId: user.id, title: title, body: body);
          if (context.mounted) _showSnackbar(context, 'Postingan berhasil ditambahkan');
        },
      ),
    );
  }

  void _openEditSheet(BuildContext context, PostModel post) {
    final provider = context.read<PostProvider>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => AddEditPostSheet(
        initialTitle: post.title,
        initialBody: post.body,
        onSubmit: (title, body) async {
          await provider.editPost(post, title: title, body: body);
          if (context.mounted) _showSnackbar(context, 'Postingan berhasil diubah');
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, PostModel post) {
    final provider = context.read<PostProvider>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Postingan?'),
        content: Text('"${post.title}" akan dihapus secara permanen. Lanjutkan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                await provider.removePost(post);
                if (context.mounted) _showSnackbar(context, 'Postingan berhasil dihapus');
              } catch (e) {
                if (context.mounted) _showSnackbar(context, 'Gagal menghapus postingan', isError: true);
              }
            },
            child: const Text('Hapus', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Detail Pengguna')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddSheet(context),
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: Column(
        children: [
          Consumer<PostProvider>(
            builder: (context, provider, _) {
              final hasCount = provider.state != ViewState.loading && provider.state != ViewState.error;
              return _UserHeader(user: user, postCount: hasCount ? provider.posts.length : null);
            },
          ),
          Expanded(
            child: Consumer<PostProvider>(
              builder: (context, provider, _) {
                if (provider.state == ViewState.loading) {
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                    itemCount: 4,
                    itemBuilder: (context, index) => const PostCardShimmer(),
                  );
                }

                if (provider.state == ViewState.error) {
                  return ErrorStateWidget(
                    message: provider.errorMessage,
                    onRetry: () => provider.fetchPosts(user.id),
                  );
                }

                if (provider.posts.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.article_outlined,
                    title: 'Belum Ada Postingan',
                    subtitle: 'Ketuk tombol "Tambah" di bawah untuk membuat postingan pertama.',
                  );
                }

                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () => provider.fetchPosts(user.id),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                    itemCount: provider.posts.length,
                    itemBuilder: (context, index) {
                      final post = provider.posts[index];
                      return PostCard(
                        post: post,
                        onEdit: () => _openEditSheet(context, post),
                        onDelete: () => _confirmDelete(context, post),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _UserHeader extends StatelessWidget {
  final UserModel user;
  final int? postCount;
  const _UserHeader({required this.user, this.postCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withOpacity(0.25), blurRadius: 18, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.35), width: 2),
            ),
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white.withOpacity(0.2),
              child: Text(
                user.name.substring(0, 1).toUpperCase(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
              ),
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
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(Icons.apartment_rounded, size: 13, color: Colors.white.withOpacity(0.85)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        user.company,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12),
                      ),
                    ),
                  ],
                ),
                if (postCount != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.16),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.article_rounded,
                          size: 13,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            '$postCount postingan',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
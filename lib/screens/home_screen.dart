import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/shimmer_box.dart';
import '../widgets/state_widgets.dart';
import '../widgets/user_card.dart';
import 'post_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<UserProvider>(
        builder: (context, provider, _) {
          final isLoading = provider.state == ViewState.loading;
          final isError = provider.state == ViewState.error;
          final isEmpty = !isLoading && !isError && provider.users.isEmpty;

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => provider.fetchUsers(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                _HomeHeader(
                  userCount: (!isLoading && !isError) ? provider.users.length : null,
                ),
                if (isLoading)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: UserCardShimmer(),
                        ),
                        childCount: 6,
                      ),
                    ),
                  )
                else if (isError)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: ErrorStateWidget(
                      message: provider.errorMessage,
                      onRetry: () => provider.fetchUsers(),
                    ),
                  )
                else if (isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyStateWidget(
                      icon: Icons.people_outline_rounded,
                      title: 'Belum Ada Pengguna',
                      subtitle: 'Daftar pengguna akan muncul di sini.',
                      actionLabel: 'Muat Ulang',
                      onAction: () => provider.fetchUsers(),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final user = provider.users[index];
                          final isLast = index == provider.users.length - 1;
                          return Padding(
                            padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
                            child: UserCard(
                              user: user,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => PostDetailScreen(user: user)),
                                );
                              },
                            ),
                          );
                        },
                        childCount: provider.users.length,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  final int? userCount;
  const _HomeHeader({this.userCount});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'UserConnect',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.6,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Jelajahi pengguna & postingan mereka',
                        style: TextStyle(color: Colors.white.withOpacity(0.78), fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.16),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.business_rounded, size: 20, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 22),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: userCount == null
                  ? const SizedBox(height: 30)
                  : Container(
                      key: ValueKey(userCount),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.groups_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              '$userCount pengguna terdaftar',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
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
    );
  }
}
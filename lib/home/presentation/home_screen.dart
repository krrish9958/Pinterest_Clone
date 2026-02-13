import 'package:cached_network_image/cached_network_image.dart';
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/features/home/presentation/providers/home_provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      ref.read(homeProvider.notifier).loadMorePins();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pinsAsync = ref.watch(homeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pinterest"),
        actions: [
          IconButton(
            onPressed: _showProfileSheet,
            icon: const Icon(Icons.account_circle_rounded),
          ),
        ],
      ),
      body: pinsAsync.when(
        data: (pins) {
          return RefreshIndicator(
            onRefresh: () => ref.read(homeProvider.notifier).refreshPins(),
            child: MasonryGridView.count(
              physics: const AlwaysScrollableScrollPhysics(),

              controller: _scrollController,
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              padding: const EdgeInsets.all(8),
              itemCount: pins.length,
              itemBuilder: (context, index) {
                final pin = pins[index];

                return GestureDetector(
                  onTap: () {
                    context.push(
                      '/detail',
                      extra: {'id': pin.id, 'imageUrl': pin.imageUrl},
                    );
                  },
                  child: Hero(
                    tag: pin.id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: pin.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => _buildShimmer(),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }

  Future<void> _showProfileSheet() async {
    final authState = ClerkAuth.of(context, listen: false);
    final user = authState.user;
    final name = [
      user?.firstName,
      user?.lastName,
    ].whereType<String>().where((v) => v.trim().isNotEmpty).join(' ');
    final email = user?.email ?? '';

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                if (name.isNotEmpty) Text(name),
                if (email.isNotEmpty) Text(email),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final shouldLogout = await showDialog<bool>(
                        context: sheetContext,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Log out?'),
                            content: const Text(
                              'Are you sure you want to log out?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Log out'),
                              ),
                            ],
                          );
                        },
                      );

                      if (shouldLogout == true) {
                        if (!sheetContext.mounted) return;
                        Navigator.of(sheetContext).pop();
                        await authState.signOut();
                      }
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmer() {
    return MasonryGridView.count(
      crossAxisCount: 2,
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 150 + (index * 20),
            margin: const EdgeInsets.all(8),
            color: Colors.white,
          ),
        );
      },
    );
  }
}

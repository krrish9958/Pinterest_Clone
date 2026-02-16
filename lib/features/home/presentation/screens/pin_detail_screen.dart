import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/features/home/presentation/providers/home_provider.dart';

class PinDetailScreen extends ConsumerWidget {
  final int id;
  final String imageUrl;
  final String author;
  final String title;

  const PinDetailScreen({
    super.key,
    required this.id,
    required this.imageUrl,
    required this.author,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(homeProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPinImage(context),
                    const SizedBox(height: 10),
                    _buildActionRow(id),
                    const SizedBox(height: 14),
                    _buildAuthorSection(),
                    const SizedBox(height: 18),
                    const Text(
                      'More to explore',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.6,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
              sliver: feedAsync.when(
                data: (pins) {
                  final recommendations = pins.where((pin) => pin.id != id).toList();
                  if (recommendations.isEmpty) {
                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  }
                  return SliverMasonryGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childCount: recommendations.length.clamp(0, 16),
                    itemBuilder: (context, index) {
                      final pin = recommendations[index];
                      return GestureDetector(
                        onTap: () {
                          context.pushReplacement(
                            '/detail',
                            extra: {
                              'id': pin.id,
                              'imageUrl': pin.imageUrl,
                              'author': pin.author,
                              'title': pin.title,
                            },
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: CachedNetworkImage(
                          imageUrl: pin.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: const Color(0xFFE9E9E9),
                            height: 180,
                          ),
                        ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Center(child: CircularProgressIndicator(strokeWidth: 2.2)),
                  ),
                ),
                error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPinImage(BuildContext context) {
    return Stack(
      children: [
        Hero(
          tag: id,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.48,
              placeholder: (context, url) => Container(
                color: const Color(0xFFE9E9E9),
                height: 360,
              ),
            ),
          ),
        ),
        Positioned(
          top: 12,
          left: 12,
          child: _CircleIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.of(context).pop(),
          ),
        ),
        Positioned(
          right: 12,
          bottom: 12,
          child: _CircleIconButton(icon: Icons.search_rounded, onTap: () {}),
        ),
      ],
    );
  }

  Widget _buildActionRow(int pinId) {
    return Row(
      children: [
        const Icon(CupertinoIcons.heart, color: Colors.black, size: 26),
        const SizedBox(width: 6),
        Text(
          '${(pinId % 80) + 20}',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 18),
        const Icon(CupertinoIcons.chat_bubble, color: Colors.black, size: 24),
        const SizedBox(width: 18),
        const Icon(CupertinoIcons.arrow_up, color: Colors.black, size: 25),
        const SizedBox(width: 14),
        const Icon(CupertinoIcons.ellipsis, color: Colors.black, size: 24),
        const Spacer(),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFE60023),
            foregroundColor: Colors.white,
            shape: const StadiumBorder(),
            minimumSize: const Size(0, 42),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          ),
          onPressed: () {},
          child: const Text(
            'Save',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildAuthorSection() {
    final displayAuthor = author.trim().isEmpty ? 'Unknown creator' : author.trim();
    final displayTitle = title.trim().isEmpty ? 'Untitled pin' : title.trim();

    return Row(
      children: [
        const CircleAvatar(
          radius: 14,
          backgroundColor: Color(0xFFE6E6E6),
          child: Icon(Icons.person_rounded, color: Colors.black54, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayAuthor,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              Text(
                displayTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 42,
        width: 42,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.46),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}

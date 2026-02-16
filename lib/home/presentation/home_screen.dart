import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/features/home/presentation/providers/home_provider.dart';
import 'package:shimmer/shimmer.dart';

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: selected ? const Color(0xFFE60023) : Colors.black87,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                fontSize: 15,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 3),
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: selected ? 22 : 0,
              height: 2.6,
              decoration: BoxDecoration(
                color: const Color(0xFFE60023),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  String selectedCategory = 'All';
  final List<String> _categories = const [
    'All',
    'Nails',
    'Outfit Inspo',
    'Home Decor',
    'Fall Outfit',
  ];

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 10,
        titleSpacing: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              children: _categories
                  .map(
                    (category) => _CategoryChip(
                      label: category,
                      selected: selectedCategory == category,
                      onTap: () => setState(() => selectedCategory = category),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
      body: pinsAsync.when(
        data: (pins) {
          final visiblePins = pins;
          return RefreshIndicator(
            onRefresh: () => ref.read(homeProvider.notifier).refreshPins(),
            child: MasonryGridView.count(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 72),
              itemCount: visiblePins.length,
              itemBuilder: (context, index) {
                final pin = visiblePins[index];

                return TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 220 + ((index % 8) * 35)),
                  curve: Curves.easeOutCubic,
                  tween: Tween(begin: 0, end: 1),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, (1 - value) * 18),
                        child: child,
                      ),
                    );
                  },
                  child: GestureDetector(
                    onTap: () {
                      context.push(
                        '/detail',
                        extra: {
                          'id': pin.id,
                          'imageUrl': pin.imageUrl,
                          'author': pin.author,
                          'title': pin.title,
                        },
                      );
                    },
                    child: Hero(
                      tag: pin.id,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: _RoundedGridImage(
                          imageUrl: pin.imageUrl,
                          placeholderHeight: 190,
                        ),
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

  Widget _buildShimmer() {
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 72),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: const Color(0xFFEAEAEA),
          highlightColor: const Color(0xFFF6F6F6),
          child: Container(
            height: 140 + ((index % 5) * 34),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}

class _RoundedGridImage extends StatelessWidget {
  final String imageUrl;
  final double placeholderHeight;

  const _RoundedGridImage({
    required this.imageUrl,
    required this.placeholderHeight,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      placeholderFadeInDuration: Duration.zero,
      imageBuilder: (context, imageProvider) => Image(
        image: imageProvider,
        fit: BoxFit.cover,
        width: double.infinity,
      ),
      placeholder: (context, url) => SizedBox(
        height: placeholderHeight,
        child: const ColoredBox(color: Color(0xFFEDEDED)),
      ),
      errorWidget: (context, url, error) => SizedBox(
        height: placeholderHeight,
        child: const ColoredBox(color: Color(0xFFE0E0E0)),
      ),
    );
  }
}

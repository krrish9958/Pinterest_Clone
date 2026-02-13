import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest_clone/features/search/presentation/providers/search_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      ref.read(searchProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchAsync = ref.watch(searchProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Rounded search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 30, 16, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),

                child: SizedBox(
                  height: 48,
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Search for ideas",
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (value) {
                      ref.read(searchProvider.notifier).search(value);
                    },
                  ),
                ),
              ),
            ),

            // Content
            Expanded(
              child: searchAsync.when(
                data: (pins) {
                  if (pins.isEmpty) {
                    return const Center(
                      child: Text(
                        "Search for ideas",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }

                  return MasonryGridView.count(
                    controller: _scrollController,
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    padding: const EdgeInsets.all(8),
                    itemCount: pins.length,
                    itemBuilder: (context, index) {
                      final pin = pins[index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: pin.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text(e.toString())),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_providers.dart';
import '../widgets/post_card.dart';
import '../widgets/story_carousel.dart';
import '../widgets/note_bubble.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _page++;
      context.read<PostProvider>().loadFeed(page: _page);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nirdist', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.message), onPressed: () {}),
        ],
      ),
      body: Consumer<PostProvider>(
        builder: (context, postProvider, _) {
          if (postProvider.isLoading && postProvider.posts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            controller: _scrollController,
            children: [
              // Stories Carousel
              SizedBox(
                height: 100,
                child: Consumer<StoryProvider>(
                  builder: (context, storyProvider, _) {
                    return StoryCarousel(stories: storyProvider.stories);
                  },
                ),
              ),
              const Divider(height: 1),
              
              // Posts Feed
              ...postProvider.posts.map((post) => PostCard(post: post)).toList(),
              
              if (postProvider.isLoading)
                const Center(child: CircularProgressIndicator()),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

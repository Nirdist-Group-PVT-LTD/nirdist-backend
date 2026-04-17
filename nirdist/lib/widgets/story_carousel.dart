import 'package:flutter/material.dart';
import '../models/models.dart';

class StoryCarousel extends StatefulWidget {
  final List<Story> stories;

  const StoryCarousel({Key? key, required this.stories}) : super(key: key);

  @override
  State<StoryCarousel> createState() => _StoryCarouselState();
}

class _StoryCarouselState extends State<StoryCarousel> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.stories.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          // Add story button
          return Padding(
            padding: const EdgeInsets.all(8),
            child: GestureDetector(
              onTap: () {
                // Open create story
              },
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    child: const Icon(Icons.add, size: 30),
                  ),
                  const SizedBox(height: 4),
                  const Text('Your story', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          );
        }

        final story = widget.stories[index - 1];
        final isExpiring = story.expiresAt.difference(DateTime.now()).inHours < 1;

        return Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Story view coming soon')),
              );
            },
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isExpiring
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      story.sLink,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade800,
                          child: const Icon(Icons.image),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(story.vUsername, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        );
      },
    );
  }
}

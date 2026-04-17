import 'package:flutter/material.dart';
import '../models/models.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isLiked = false;
  int _reactionCount = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade900,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  child: Text(widget.post.vName[0]),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.post.vName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('@${widget.post.vUsername}', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                  ],
                ),
                const Spacer(),
                IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
              ],
            ),
          ),
          // Image carousel or video
          if (widget.post.media.isNotEmpty)
            SizedBox(
              height: 300,
              child: PageView.builder(
                itemCount: widget.post.media.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    widget.post.media[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade800,
                        child: const Icon(Icons.broken_image),
                      );
                    },
                  );
                },
              ),
            ),
          // Description
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(widget.post.discription, maxLines: 3, overflow: TextOverflow.ellipsis),
          ),
          // Sound tag
          if (widget.post.sound != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.music_note, size: 14),
                    const SizedBox(width: 4),
                    Text(widget.post.sound?['s_a_name'] ?? 'Original sound', style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
          // Reaction row
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isLiked = !_isLiked;
                      _reactionCount += _isLiked ? 1 : -1;
                    });
                  },
                  child: Row(
                    children: [
                      Icon(_isLiked ? Icons.favorite : Icons.favorite_border,
                          color: _isLiked ? Colors.red : Colors.grey),
                      const SizedBox(width: 4),
                      Text('${widget.post.reactions.length + _reactionCount}'),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.chat_bubble_outline),
                    const SizedBox(width: 4),
                    Text('${widget.post.comments.length}'),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.share),
                    const SizedBox(width: 4),
                    const Text('Share'),
                  ],
                ),
                const Icon(Icons.bookmark_outline),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

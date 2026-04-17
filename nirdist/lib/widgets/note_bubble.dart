import 'package:flutter/material.dart';
import '../models/models.dart';

class NoteBubble extends StatelessWidget {
  final Note note;

  const NoteBubble({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notes coming soon')),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade800),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    child: Text(note.vName.isNotEmpty ? note.vName[0] : '?'),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(note.vName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      Text('@${note.vUsername}', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(note.noteContent, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.favorite_border, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text('${note.reactionCount}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

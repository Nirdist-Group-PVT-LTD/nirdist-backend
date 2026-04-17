import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_providers.dart';
import '../providers/auth_provider.dart';
import '../services/api_client.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({Key? key}) : super(key: key);

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedMode = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create'),
        elevation: 0,
        centerTitle: true,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Post Tab
          CreatePostTab(),
          // Story Tab
          CreateStoryTab(),
          // Sound Tab
          CreateSoundTab(),
          // Note Tab
          CreateNoteTab(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade900)),
        ),
        child: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Post'),
            Tab(text: 'Story'),
            Tab(text: 'Sound'),
            Tab(text: 'Note'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class CreatePostTab extends StatefulWidget {
  @override
  State<CreatePostTab> createState() => _CreatePostTabState();
}

class _CreatePostTabState extends State<CreatePostTab> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _mediaController = TextEditingController();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Media upload coming soon. Use a URL for now.')),
              );
            },
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_photo_alternate, size: 48, color: Colors.grey),
                  const SizedBox(height: 8),
                  const Text('Tap to add photos/videos'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _descriptionController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Write a description...',
              filled: true,
              fillColor: Colors.grey.shade900,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _mediaController,
            decoration: InputDecoration(
              hintText: 'Optional media URL(s), comma-separated',
              filled: true,
              fillColor: Colors.grey.shade900,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isSubmitting ? null : () => _handleCreatePost(context),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Post'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCreatePost(BuildContext context) async {
    final description = _descriptionController.text.trim();
    final mediaUrls = _mediaController.text
        .split(',')
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList();

    if (description.isEmpty && mediaUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add a description or media URL')),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;
    if (user == null || user.vId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to post')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await ApiClient.createPost(
        vId: user.vId,
        vName: user.vName,
        vUsername: user.vUsername,
        description: description,
        media: mediaUrls,
      );
      _descriptionController.clear();
      _mediaController.clear();
      if (mounted) {
        await context.read<PostProvider>().loadFeed(page: 1);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post created')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _mediaController.dispose();
    super.dispose();
  }
}

class CreateStoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.camera_alt, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Create a 24-hour story'),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showCreateStoryDialog(context),
            icon: const Icon(Icons.camera),
            label: const Text('Take Photo'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateStoryDialog(BuildContext context) {
    final mediaController = TextEditingController();
    final captionController = TextEditingController();
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Create Story'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: mediaController,
                    decoration: const InputDecoration(
                      labelText: 'Media URL',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: captionController,
                    decoration: const InputDecoration(
                      labelText: 'Caption (optional)',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          final mediaUrl = mediaController.text.trim();
                          if (mediaUrl.isEmpty) {
                            ScaffoldMessenger.of(dialogContext).showSnackBar(
                              const SnackBar(content: Text('Media URL is required')),
                            );
                            return;
                          }

                          final authProvider = context.read<AuthProvider>();
                          final user = authProvider.currentUser;
                          if (user == null || user.vId == 0) {
                            ScaffoldMessenger.of(dialogContext).showSnackBar(
                              const SnackBar(content: Text('Please log in to post')),
                            );
                            return;
                          }

                          setDialogState(() => isSubmitting = true);
                          try {
                            await ApiClient.createStory(
                              vId: user.vId,
                              vName: user.vName,
                              vUsername: user.vUsername,
                              mediaUrl: mediaUrl,
                              caption: captionController.text.trim(),
                            );
                            if (dialogContext.mounted) {
                              await context.read<StoryProvider>().loadStories(page: 1);
                              Navigator.pop(dialogContext);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Story created')),
                              );
                            }
                          } catch (e) {
                            if (dialogContext.mounted) {
                              ScaffoldMessenger.of(dialogContext).showSnackBar(
                                SnackBar(content: Text('Failed to create story: $e')),
                              );
                            }
                          } finally {
                            if (dialogContext.mounted) {
                              setDialogState(() => isSubmitting = false);
                            }
                          }
                        },
                  child: isSubmitting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Post'),
                ),
              ],
            );
          },
        );
      },
    ).whenComplete(() {
      mediaController.dispose();
      captionController.dispose();
    });
  }
}

class CreateSoundTab extends StatefulWidget {
  @override
  State<CreateSoundTab> createState() => _CreateSoundTabState();
}

class _CreateSoundTabState extends State<CreateSoundTab> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  bool _isRecording = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isRecording ? Icons.mic : Icons.mic_none,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(_isRecording ? 'Recording...' : 'Ready to record'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Sound name',
              filled: true,
              fillColor: Colors.grey.shade900,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Description',
              filled: true,
              fillColor: Colors.grey.shade900,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => setState(() => _isRecording = !_isRecording),
                  icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                  label: Text(_isRecording ? 'Stop' : 'Record'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sound upload coming soon')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: const Text('Upload'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }
}

class CreateNoteTab extends StatefulWidget {
  @override
  State<CreateNoteTab> createState() => _CreateNoteTabState();
}

class _CreateNoteTabState extends State<CreateNoteTab> {
  final TextEditingController _noteController = TextEditingController();
  String _visibility = 'public';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _noteController,
            maxLines: 8,
            decoration: InputDecoration(
              hintText: 'What\'s on your mind?',
              filled: true,
              fillColor: Colors.grey.shade900,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: _visibility,
            onChanged: (value) => setState(() => _visibility = value ?? 'public'),
            decoration: InputDecoration(
              labelText: 'Visibility',
              filled: true,
              fillColor: Colors.grey.shade900,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            items: const [
              DropdownMenuItem(value: 'public', child: Text('Public')),
              DropdownMenuItem(value: 'friends', child: Text('Friends')),
              DropdownMenuItem(value: 'only_me', child: Text('Only Me')),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notes coming soon')),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: const Text('Post Note'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}

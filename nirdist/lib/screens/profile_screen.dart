import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_providers.dart';
import '../providers/auth_provider.dart';
import '../models/models.dart';
import '../services/api_client.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Post> _userPosts = [];
  bool _isLoadingPosts = false;
  String? _postsError;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final currentUserId = authProvider.currentUser?.vId ?? 0;
      if (currentUserId > 0) {
        context.read<UserProvider>().loadProfile(currentUserId);
        _loadUserPosts(currentUserId);
      }
    });
  }

  Future<void> _loadUserPosts(int vId) async {
    setState(() {
      _isLoadingPosts = true;
      _postsError = null;
    });

    try {
      final posts = await ApiClient.getUserPosts(vId);
      if (mounted) {
        setState(() => _userPosts = posts);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _postsError = e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingPosts = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings coming soon')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          if (userProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = userProvider.currentUser;
          if (user == null) {
            return const Center(child: Text('Profile not found'));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: user.profilePicture.isNotEmpty
                            ? NetworkImage(user.profilePicture)
                            : null,
                        child: user.profilePicture.isEmpty
                            ? Text(user.vName.isNotEmpty ? user.vName[0] : '?')
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user.vName,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '@${user.vUsername}',
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
                      ),
                      if (user.bio.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          user.bio,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade300),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                '${user.postCount}',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const Text('Posts'),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '${user.followerCount}',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const Text('Followers'),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '${user.followingCount}',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const Text('Following'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Edit profile coming soon')),
                                );
                              },
                              child: const Text('Edit Profile'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Share profile coming soon')),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade800,
                              ),
                              child: const Text('Share Profile'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(),
                // Tab selector
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(icon: Icon(Icons.grid_3x3)),
                    Tab(icon: Icon(Icons.music_note)),
                    Tab(icon: Icon(Icons.bookmark)),
                  ],
                ),
                SizedBox(
                  height: 300,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildPostsGrid(),
                      _buildSoundsGrid(),
                      _buildSavedGrid(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPostsGrid() {
    if (_isLoadingPosts) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_postsError != null) {
      return Center(child: Text(_postsError!));
    }

    if (_userPosts.isEmpty) {
      return Center(
        child: Text(
          'No posts yet',
          style: TextStyle(color: Colors.grey.shade500),
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemCount: _userPosts.length,
      itemBuilder: (context, index) {
        final post = _userPosts[index];
        final mediaUrl = post.media.isNotEmpty ? post.media.first : null;
        return Container(
          color: Colors.grey.shade900,
          child: mediaUrl == null || mediaUrl.isEmpty
              ? Center(
                  child: Icon(Icons.image, color: Colors.grey.shade600),
                )
              : Image.network(
                  mediaUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(Icons.broken_image, color: Colors.grey.shade600),
                    );
                  },
                ),
        );
      },
    );
  }

  Widget _buildSoundsGrid() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.music_note),
          title: Text('Sound ${index + 1}'),
          subtitle: const Text('2 hours ago'),
          trailing: const Icon(Icons.play_arrow),
        );
      },
    );
  }

  Widget _buildSavedGrid() {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Container(
            width: 50,
            height: 50,
            color: Colors.grey.shade900,
          ),
          title: Text('Saved ${index + 1}'),
          subtitle: const Text('3 days ago'),
        );
      },
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.pop(context);
            },
            child: Text(
              'Logout',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

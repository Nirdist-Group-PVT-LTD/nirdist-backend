import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_providers.dart';
import 'providers/auth_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/call_provider.dart';
import 'screens/home_screen.dart';
import 'screens/discover_screen.dart';
import 'screens/create_screen.dart';
import 'screens/activity_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'services/api_client.dart';

void main() async {
  // Initialize token from persistent storage before running the app
  await ApiClient.initializeToken();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF6EB6FF),
      brightness: Brightness.dark,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => StoryProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => CallProvider()),
      ],
      child: MaterialApp(
        title: 'Nirdist',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: colorScheme,
          scaffoldBackgroundColor: const Color(0xFF0B1020),
          appBarTheme: AppBarTheme(
            backgroundColor: const Color(0xFF0B1020),
            elevation: 0,
            foregroundColor: colorScheme.onBackground,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: const Color(0xFF0B1020),
            selectedItemColor: colorScheme.primary,
            unselectedItemColor: Colors.blueGrey.shade400,
          ),
        ),
        home: const AuthGate(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _showLogin = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isAuthenticated) {
          return const MainNavigationScreen();
        }

        if (_showLogin) {
          return LoginScreen(
            onNavigateToSignup: () => setState(() => _showLogin = false),
          );
        } else {
          return SignupScreen(
            onNavigateToLogin: () => setState(() => _showLogin = true),
          );
        }
      },
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const DiscoverScreen(),
    const CreateScreen(),
    const ActivityScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Load initial data
    context.read<PostProvider>().loadFeed();
    context.read<StoryProvider>().loadStories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade900)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
          unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Discover'),
            BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Create'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Activity'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

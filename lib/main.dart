import 'package:android_reviewer_flutter/view/admin/SubjectScreen.dart';
import 'package:android_reviewer_flutter/view/login/LoginScreen.dart';
import 'package:android_reviewer_flutter/view/user/HomeScreen.dart';
import 'package:android_reviewer_flutter/view/user/SettingsScreen.dart';
import 'package:android_reviewer_flutter/viewmodel/AppViewModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(); // Initialize Firebase
    print("Firebase initialization success");
  } catch (e) {
    print("Firebase initialization failed: $e");
  }

  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => AppViewModel())],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Android Reviewer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthWidget(), // Use an AuthWidget to handle login/logout
    );
  }
}

// This widget checks the authentication status
class AuthWidget extends StatelessWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      // Listen for authentication state changes
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for the auth state
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          // User is logged in, check role in Shared Preferences
          return FutureBuilder<String?>(
            future: getUserRole(), // Get user role from Shared Preferences
            builder: (context, roleSnapshot) {
              if (roleSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (roleSnapshot.hasData) {
                // Navigate to MainScreen with the retrieved role
                return MainScreen(roleSnapshot.data);
              } else {
                // Role not found, show an error or login screen
                return const LoginScreen();
              }
            },
          );
        } else {
          // User is not logged in, show the LoginScreen
          return const LoginScreen();
        }
      },
    );
  }

  // Method to get user role from Shared Preferences
  Future<String?> getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userRole'); // Retrieve the saved role
  }
}

class MainScreen extends StatefulWidget {
  final String? role;

  const MainScreen(this.role, {super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Track which tab is selected

  // List of pages corresponding to the bottom navigation bar
  final List<Widget> userPages = [const HomeScreen(), const SettingsScreen()];
  final List<Widget> adminPages = [SubjectScreen(), const SettingsScreen()];

  // Function to handle tab change
  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected tab index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.role == 'admin'
          ? adminPages[_selectedIndex]
          : userPages[_selectedIndex], // Show the selected page
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: _selectedIndex, // Set the current index
        onTap: onItemTapped, // Handle tab change
        selectedItemColor: Colors.green, // Color for selected item
      ),
    );
  }
}

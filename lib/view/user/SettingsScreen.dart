import 'package:android_reviewer_flutter/view/login/LoginScreen.dart';
import 'package:android_reviewer_flutter/viewmodel/AppViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/widgets.dart'; // Import if you use additional widgets

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    final appViewModel = Provider.of<AppViewModel>(context, listen: false);
    appViewModel.getUserData(); // Fetch user data when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    final appViewModel = Provider.of<AppViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.green[100],
      body: Column(
        children: [
          // Add the GIF inside a SizedBox at the top
          SizedBox(
            height: 300, // Adjust the height as needed
            width: double.infinity,
            child: Image.asset(
              'assets/logo_settings.gif', // Path to your GIF
              fit: BoxFit.cover, // Adjust fit as necessary
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align to the left
              children: [
                const SizedBox(height: 10),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Text("Email: ${appViewModel.email}"),
                      ], // Display user email
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Logout button
                Container(
                  width: double.infinity, // Button width matches card width
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ElevatedButton(
                    onPressed: () async {
                      bool? isLogout = await appViewModel.logoutUser();
                      if (isLogout) {
                        SharedPreferences pref =
                        await SharedPreferences.getInstance();
                        pref.remove('userRole'); // Remove shared pref

                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red, // Button background color
                      padding: const EdgeInsets.all(1.0), // Button padding
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(5), // Match card shape
                      ),
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:android_reviewer_flutter/view/login/LoginScreen.dart';
import 'package:android_reviewer_flutter/viewmodel/AppViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          const SizedBox(
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.green),
            ),
            height: 150,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [Text(appViewModel.name)], // Display user name
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Email: ${appViewModel.email}")
                      ], // Display user email
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Space before the button
                Container(
                  width: double.infinity, // Button width matches card width
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ElevatedButton(
                    onPressed: () {
                      // Action for the button press
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Change Password Pressed'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      // Background color of the button
                      padding: const EdgeInsets.all(1.0),
                      // Padding inside the button
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5), // Match card shape
                      ),
                    ),
                    child: const Text('Change Password'),
                  ),
                ),
                const SizedBox(height: 20), // Space before the button
                Container(
                  width: double.infinity, // Button width matches card width
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ElevatedButton(
                    onPressed: () async {
                      bool? isLogout = await appViewModel.logoutUser();
                      if (isLogout) {
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        pref.remove('userRole'); //remove shared pref

                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      // Background color of the button
                      padding: const EdgeInsets.all(1.0),
                      // Padding inside the button
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5), // Match card shape
                      ),
                    ),
                    child: const Text('Logout'),
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

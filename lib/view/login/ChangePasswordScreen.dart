import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/AppViewModel.dart';

class ChangePasswordScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appViewModel = Provider.of<AppViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
        backgroundColor: Colors.green[300],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[300]!, Colors.green[100]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),

            // Email TextField
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email Address",
                // border: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(10),
                //   borderSide: BorderSide.none,
                // ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 20),



            // Send Password Reset Email Button
            ElevatedButton(
              onPressed: () {
                if (_emailController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter an email address!"),
                    ),
                  );
                } else {
                  appViewModel.sendPasswordResetEmail(context, _emailController.text.trim());
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 80,
                ),
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(10), // Squared border radius
                ),
              ),
              child: const Text(
                "Change Password",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

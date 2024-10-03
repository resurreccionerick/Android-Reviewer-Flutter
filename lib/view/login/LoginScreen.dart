import 'package:android_reviewer_flutter/view/login/ChangePasswordScreen.dart';
import 'package:android_reviewer_flutter/view/user/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../viewmodel/AppViewModel.dart';
import 'SignupScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false; // Track loading state

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appViewModel = Provider.of<AppViewModel>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3DDC84), Color(0xFF0F9D58)],
            // Android green shades
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image above "Welcome"
                  Container(
                    width: 200, // Adjust the width to fit your needs
                    height: 200, // Adjust the height to fit your needs
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle, // Keeps it as a rectangle
                      image: DecorationImage(
                        image: AssetImage('assets/android_logo.png'),
                        // Your image path
                        fit: BoxFit
                            .cover, // Adjusts the image to cover the container
                      ),
                      color: Colors
                          .transparent, // Optional: Set to transparent or any color
                    ),
                  ),

                  //const SizedBox(height: 10),

                  // const Text(
                  //   "Reviewer",
                  //   style: TextStyle(r
                  //     fontSize: 30,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.white,
                  //   ),
                  // ),
                  const SizedBox(height: 50),

                  // Email TextField
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email,
                    enabled: !_isLoading, // Disable when loading
                  ),
                  const SizedBox(height: 20),

                  // Password TextField with Eye Icon
                  _buildTextField(
                    controller: _passController,
                    label: 'Password',
                    icon: Icons.lock,
                    isPassword: true,
                    isPasswordVisible: _isPasswordVisible,
                    togglePasswordVisibility: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    enabled: !_isLoading, // Disable when loading
                  ),

                  // Change Password Text
                  Align(
                    alignment: Alignment.centerRight, // Align to the right
                    child: TextButton(
                      onPressed: _isLoading // Disable when loading
                          ? null
                          : () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ChangePasswordScreen()));
                            },
                      child: const Text(
                        "Change Password",
                        style: TextStyle(
                          color: Colors.white, // Change color as needed
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Login Button
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: _isLoading // Disable when loading
                          ? null
                          : () async {
                              if (_emailController.text.isEmpty ||
                                  _passController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please enter all fields!"),
                                  ),
                                );
                              } else {
                                setState(() {
                                  _isLoading = true; // Start loading
                                });

                                String? role = await appViewModel.loginUser(
                                  context,
                                  _emailController.text,
                                  _passController.text,
                                );

                                // Stop loading after getting the result
                                setState(() {
                                  _isLoading = false;
                                });

                                if (role != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Welcome $role")),
                                  );

                                  if (role == 'admin' || role == 'user') {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => MainScreen(role),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Something went wrong. Please try again later."),
                                      ),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Login failed. Please try again."),
                                    ),
                                  );
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 80,
                        ),
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Squared border radius
                        ),
                      ),
                      child: const Text(
                        "Login as User",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: _isLoading // Disable when loading
                          ? null
                          : () async {
                              appViewModel.signInAnonymously(context);
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => MainScreen("user"),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 80,
                        ),
                        backgroundColor: Colors.white70,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Squared border radius
                        ),
                      ),
                      child: const Text(
                        "Login as Anonymous",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Show progress indicator when loading
                  if (_isLoading)
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),

                  // Register Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "No account yet?",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: _isLoading // Disable when loading
                            ? null
                            : () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const SignupScreen(),
                                  ),
                                );
                              },
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Custom TextField builder with password toggle and flat design (no circular corners)
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? togglePasswordVisibility,
    bool enabled = true, // Enable/Disable field
  }) {
    return TextField(
      controller: controller,
      enabled: enabled, // Set enabled property
      obscureText: isPassword && !isPasswordVisible,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF0F9D58)),
        prefixIcon: Icon(icon, color: const Color(0xFF0F9D58)),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: const Color(0xFF0F9D58),
                ),
                onPressed: togglePasswordVisibility,
              )
            : null,
      ),
    );
  }
}

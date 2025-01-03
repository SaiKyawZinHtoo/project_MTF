import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 1000;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isWideScreen ? screenWidth * 0.2 : 16,
              vertical: 32,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  Center(
                    child: GestureDetector(
                      onTap: () {},
                      // Navigator.of(context).push(
                      //   // MaterialPageRoute(
                      //   //   //builder: (_) => const MyHomePage(),
                      //   // ),
                      //  ),
                      child: Image.asset(
                        'assets/mtf_logo.png',
                        height: isWideScreen
                            ? screenHeight * 0.25
                            : screenHeight * 0.15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Username Field
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      hintText: 'Enter your username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Required Username'
                        : null,
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Required Password'
                        : null,
                  ),
                  const SizedBox(height: 30),

                  // Login Button
                  ElevatedButton(
                    onPressed: () {
                      // if (_formKey.currentState!.validate()) {
                      //   Navigator.of(context).push(
                      //     // MaterialPageRoute(
                      //     //   //builder: (_) => const MyHomePage(),
                      //     // ),
                      //   );
                      // }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('LOGIN'),
                  ),
                  const SizedBox(height: 20),

                  // Register Button
                  ElevatedButton(
                    onPressed: () {
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (_) => const RegistrationForm(),
                      //   ),
                      // );
                    },
                    child: const Text('REGISTER'),
                  ),
                  const SizedBox(height: 20),

                  // QR Code Button
                  OutlinedButton(
                    onPressed: () {
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (_) => const CoachLicense(),
                      //   ),
                      // );
                    },
                    child: const Text('SCAN QR CODE'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

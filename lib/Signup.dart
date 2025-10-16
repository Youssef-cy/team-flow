import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_team/Component/nev_bar.dart';
import 'package:task_team/UserProvider.dart';
import 'package:task_team/homepage.dart';
import 'package:task_team/main.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool showPassword = false;
  bool isLoading = false; // ✅ حالة التحميل
  int selected = 0; // 0 => signup, 1 => signin

  Future<User?> _signin(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user!;
    } catch (e) {
      if (e is AuthApiException) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Wrong email or password")),
        );
      } else if (e is AuthRetryableFetchException) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⚠️ Connection unstable, try again.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Unexpected error: ${e.toString()}")),
        );
      }
      return null;
    }
  }

  Future<User?> _signup(String name, String email, String password) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      await supabase.from('profiles').insert({
        'user_id': response.user!.id,
        'full_name': name,
      });

      return response.user!;
    } catch (e) {
      if (e is AuthWeakPasswordException) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⚠️ Password must be 6+ characters")),
        );
      } else if (e is AuthApiException) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("❌ Account already exists with this email"),
          ),
        );
      } else if (e is AuthRetryableFetchException) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("⚠️ Internet unstable, try again later"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Unexpected error: ${e.toString()}")),
        );
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Image.asset("assets/login.jpg"),
            Padding(
              padding: const EdgeInsets.only(top: 250.0),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                height: 580,
                width: double.infinity,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      width: 300,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          toggleButton("Sign Up", 0),
                          const SizedBox(width: 10),
                          toggleButton("Sign In", 1),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: selected == 0
                            ? buildSignupForm(userProvider, screenWidth)
                            : buildSigninForm(userProvider, screenWidth),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Sign Up Form
  Widget buildSignupForm(UserProvider userProvider, double screenWidth) {
    return Column(
      children: [
        customInputField(
          controller: nameController,
          hint: "Enter your name",
          icon: Icons.person,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Name is required";
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        customInputField(
          controller: emailController,
          hint: "Enter your email",
          icon: Icons.email,
          validator: (value) {
            if (value == null || value.isEmpty) return "Email is required";
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return "Enter a valid email";
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        customInputField(
          controller: passwordController,
          hint: "Enter your password",
          icon: Icons.lock,
          obscureText: !showPassword,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Password is required";
            }
            if (value.length < 6) {
              return "Password must be at least 6 characters";
            }
            return null;
          },
          suffix: IconButton(
            icon: Icon(
              showPassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () => setState(() => showPassword = !showPassword),
          ),
        ),
        const SizedBox(height: 35),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(screenWidth * 0.6, 55),
            backgroundColor: const Color.fromARGB(255, 130, 178, 61),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onPressed: isLoading
              ? null
              : () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() => isLoading = true);
                    final user = await _signup(
                      nameController.text.trim(),
                      emailController.text.trim().toLowerCase(),
                      passwordController.text,
                    );
                    setState(() => isLoading = false);

                    if (user != null) {
                      userProvider.addUser(user.email!, user.id);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const Navbar(wid: HomePage()),
                        ),
                      );
                    }
                  }
                },
          icon: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : const Icon(Icons.person_add, color: Colors.white),
          label: Text(
            isLoading ? "Loading..." : "Sign Up",
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }

  // ✅ Sign In Form
  Widget buildSigninForm(UserProvider userProvider, double screenWidth) {
    return Column(
      children: [
        customInputField(
          controller: emailController,
          hint: "Enter your email",
          icon: Icons.email,
          validator: (value) {
            if (value == null || value.isEmpty) return "Email is required";
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return "Enter a valid email";
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        customInputField(
          controller: passwordController,
          hint: "Enter your password",
          icon: Icons.lock,
          obscureText: !showPassword,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Password is required";
            }
            return null;
          },
          suffix: IconButton(
            icon: Icon(
              showPassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () => setState(() => showPassword = !showPassword),
          ),
        ),
        const SizedBox(height: 35),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(screenWidth * 0.6, 55),
            backgroundColor: const Color.fromARGB(255, 130, 178, 61),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onPressed: isLoading
              ? null
              : () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() => isLoading = true);
                    final user = await _signin(
                      emailController.text.trim().toLowerCase(),
                      passwordController.text,
                    );
                    setState(() => isLoading = false);

                    if (user != null) {
                      userProvider.addUser(user.email!, user.id);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const Navbar(wid: HomePage()),
                        ),
                      );
                    }
                  }
                },
          icon: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : const Icon(Icons.login, color: Colors.white),
          label: Text(
            isLoading ? "Loading..." : "Login",
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget toggleButton(String text, int index) {
    final bool isSelected = selected == index;
    return GestureDetector(
      onTap: isLoading
          ? null
          : () => setState(() {
                selected = index;
              }),
      child: Container(
        width: 140,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget customInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    FormFieldValidator<String>? validator,
    bool obscureText = false,
    Widget? suffix,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: const Color.fromARGB(255, 130, 178, 61),
          ),
          suffixIcon: suffix,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
      ),
    );
  }
}

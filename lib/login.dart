import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmall = screenWidth < 600;
    final inputWidth = screenWidth * 0.85;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.07),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.dividerColor),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(Icons.arrow_back, color: theme.iconTheme.color),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 50),

            // العنوان
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Discover Your Style. Shop Smart. Dress Bold",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: isSmall ? 22 : 30,
                  shadows: [
                    const Shadow(
                      offset: Offset(3, 3),
                      blurRadius: 20,
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // النموذج داخل ستاك
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    height: isSmall ? screenHeight * 0.7 : 520,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: theme.cardColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Column(
                    children: [
                      // الاسم
                      customInputField(
                        controller: nameController,
                        hint: "Enter your Name",
                        width: inputWidth,
                        theme: theme,
                      ),

                      const SizedBox(height: 20),

                      // البريد الإلكتروني
                      customInputField(
                        controller: emailController,
                        hint: "Enter your email",
                        width: inputWidth,
                        theme: theme,
                      ),

                      const SizedBox(height: 20),

                      // كلمة المرور
                      customInputField(
                        controller: passwordController,
                        hint: "Enter your password",
                        width: inputWidth,
                        theme: theme,
                        obscure: true,
                      ),

                      const SizedBox(height: 35),

                      // زر تسجيل الدخول
                      SizedBox(
                        height: 60,
                        width: screenWidth * 0.6,
                        child: FloatingActionButton(
                          backgroundColor: Colors.black,
                          elevation: 20,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => Profile(
                                      name: nameController.text,
                                      email: emailController.text,
                                      phone: phoneController.text,
                                      password: passwordController.text,
                                    ),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.login, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Google & Apple login
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            socialButton(
                              label: "Google",
                              icon: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  'assets/download.png',
                                  height: 24,
                                ),
                              ),
                              theme: theme,
                            ),
                            socialButton(
                              label: "Apple",
                              icon: Icon(
                                Icons.apple,
                                color: theme.iconTheme.color,
                                size: 24,
                              ),
                              theme: theme,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Text Field Builder
  Widget customInputField({
    required TextEditingController controller,
    required String hint,
    required double width,
    required ThemeData theme,
    bool obscure = false,
  }) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(23)),
          filled: true,
          fillColor: theme.inputDecorationTheme.fillColor ?? theme.cardColor,
        ),
        style: TextStyle(color: theme.textTheme.bodyLarge?.color),
      ),
    );
  }

  // ✅ زر تسجيل الدخول بالحسابات
  Widget socialButton({
    required String label,
    required Widget icon,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton.icon(
        onPressed: () {},
        icon: icon,
        label: Text(
          label,
          style: TextStyle(color: theme.textTheme.bodyLarge?.color),
        ),
      ),
    );
  }
}

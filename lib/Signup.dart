import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_team/Component/nev_bar.dart';
import 'package:task_team/UserProvider.dart';
import 'package:task_team/main.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  Future<User?> _Signin(String name, String email, String password) async {
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
      } else if (e is AuthWeakPasswordException) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("⚠ Password too weak (must be 6+ characters)"),
          ),
        );
      } else if (e is AuthRetryableFetchException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Your connection is unstable. Please try again later",
            ),
          ),
        );
        return null;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Unexpected error: ${e.toString()}")),
        );
      }
      return null;
    }
  }

  // ignore: body_might_complete_normally_nullable
  Future<User?> _Signup(String name, String email, String password) async {
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
          const SnackBar(
            content: Text("⚠ Password is too weak, please use 6+ characters"),
          ),
        );
        return null;
      } else if (e is AuthApiException) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("❌ Account already exists with this email"),
          ),
        );
        return null;
      } else if (e is AuthRetryableFetchException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Your connection is unstable. Please try again later",
            ),
          ),
        );
        return null;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Unexpected error: ${e.toString()}")),
        );
        return null;
      }
    }
  }

  int selected = 0;
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final inputWidth = screenWidth * 0.85;
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox(height: screenHeight * 0.07),

            //photo
            Image.asset("assets/login.jpg"),

            Padding(
              padding: const EdgeInsets.only(top: 250.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                width: double.infinity,
                height: 580,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selected = 0;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      selected == 0
                                          ? Colors.white
                                          : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                height: 35,
                                width: 140,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 45.0,
                                    top: 2,
                                  ),
                                  child: Text(
                                    "sign up",
                                    style: TextStyle(
                                      fontWeight:
                                          selected == 0
                                              ? FontWeight.w600
                                              : FontWeight.w200,
                                      fontSize: 19,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selected = 1;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      selected == 1
                                          ? Colors.white
                                          : Colors.grey.shade200,

                                  borderRadius: BorderRadius.circular(20),
                                ),
                                height: 35,
                                width: 140,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 45.0,
                                    top: 2,
                                  ),
                                  child: Text(
                                    "sign in",
                                    style: TextStyle(
                                      fontWeight:
                                          selected == 1
                                              ? FontWeight.w600
                                              : FontWeight.w200,
                                      fontSize: 19,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child:
                          selected == 0
                              ? Column(
                                children: [
                                  // الاسم
                                  customInputField(
                                    icon: Icon(
                                      Icons.person,
                                      color: Color.fromARGB(255, 130, 178, 61),
                                    ),
                                    controller: nameController,
                                    hint: "Enter your Name",
                                    width: inputWidth,
                                    theme: theme,
                                  ),

                                  const SizedBox(height: 20),

                                  // البريد الإلكتروني
                                  customInputField(
                                    icon: Icon(
                                      Icons.email,
                                      color: Color.fromARGB(255, 130, 178, 61),
                                    ),

                                    controller: emailController,
                                    hint: "Enter your email",
                                    width: inputWidth,
                                    theme: theme,
                                  ),

                                  const SizedBox(height: 20),

                                  // كلمة المرور
                                  SizedBox(
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 25.0,
                                          ),
                                          child: Icon(
                                            Icons.lock,
                                            color: Color.fromARGB(
                                              255,
                                              130,
                                              178,
                                              61,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        Container(
                                          width: 270,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          child: TextField(
                                            obscureText: checked,
                                            controller: passwordController,
                                            decoration: InputDecoration(
                                              hintText: "Enter Your Password",
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    checked = !checked;
                                                  });
                                                },
                                                child: Icon(
                                                  checked == false
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                ),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 35),

                                  // زر تسجيل الدخول
                                  SizedBox(
                                    height: 60,
                                    width: screenWidth * 0.6,
                                    child: FloatingActionButton(
                                      backgroundColor: Color.fromARGB(
                                        255,
                                        130,
                                        178,
                                        61,
                                      ),
                                      elevation: 20,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      onPressed: () async {
                                        final user = await _Signup(
                                          nameController.text,
                                          emailController.text,
                                          passwordController.text,
                                        );
                                        if (user == null) {
                                          return;
                                        }
                                        userProvider.addUser(
                                          user.email!,
                                          user.id,
                                        );
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => const NavBarPage(),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.login,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            "Signup",
                                            // TODO : make a button to the Login in page Signup() component
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                              : Column(
                                children: [
                                  // البريد الإلكتروني
                                  customInputField(
                                    icon: Icon(
                                      Icons.email,
                                      color: Color.fromARGB(255, 130, 178, 61),
                                    ),
                                    controller: emailController,
                                    hint: "Enter your email",
                                    width: inputWidth,
                                    theme: theme,
                                  ),

                                  const SizedBox(height: 20),

                                  // كلمة المرور
                                  SizedBox(
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 25.0,
                                          ),
                                          child: Icon(
                                            Icons.lock,
                                            color: Color.fromARGB(
                                              255,
                                              130,
                                              178,
                                              61,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        Container(
                                          width: 270,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          child: TextField(
                                            obscureText: checked,
                                            controller: passwordController,
                                            decoration: InputDecoration(
                                              hintText: "Enter Your Password",
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    checked = !checked;
                                                  });
                                                },
                                                child: Icon(
                                                  checked == false
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                ),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 35),

                                  // زر تسجيل الدخول
                                  SizedBox(
                                    height: 60,
                                    width: screenWidth * 0.6,
                                    child: FloatingActionButton(
                                      backgroundColor: Color.fromARGB(
                                        255,
                                        130,
                                        178,
                                        61,
                                      ),
                                      elevation: 20,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      onPressed: () async {
                                        final user = await _Signin(
                                          nameController.text,
                                          emailController.text,
                                          passwordController.text,
                                        );
                                        if (user == null) {
                                          return;
                                        }
                                        userProvider.addUser(
                                          user.email!,
                                          user.id,
                                        );
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => const NavBarPage(),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.login,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            "Login",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                            // TODO : make a button to the Signup page Login() component
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 30),

                                  // Google & Apple login
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [],
                                    ),
                                  ),
                                ],
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

  // ✅ Text Field Builder
  Widget customInputField({
    required TextEditingController controller,
    required String hint,
    required double width,
    required ThemeData theme,
    required Icon icon,
    bool obscure = false,
  }) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          hoverColor: Colors.white,

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          filled: true,
          fillColor: theme.inputDecorationTheme.fillColor ?? theme.cardColor,
          icon: icon,
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

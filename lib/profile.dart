import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:task_team/Signup.dart';
import 'package:task_team/TaskProvider.dart';
import 'package:task_team/UserProvider.dart';
import 'package:task_team/main.dart';

class Profile extends StatefulWidget {
  final String name;
  final String email;
  final String phone;

  const Profile({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ImagePicker _picker = ImagePicker();

  List<Map<String, String>> get userInfo => [
    {'label': 'Name', 'value': widget.name, 'icon': 'person'},
    {'label': 'Email', 'value': widget.email, 'icon': 'email'},
  ];

  IconData getIcon(String iconName) {
    switch (iconName) {
      case 'person':
        return Icons.person;
      case 'email':
        return Icons.email;
      case 'lock':
        return Icons.lock;
      default:
        return Icons.info;
    }
  }

  // ignore: body_might_complete_normally_nullable
  Future<XFile?> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      return pickedFile;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final taskProvider = Provider.of<TaskProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 27, 27, 27),
              ),
            ),
            GestureDetector(
              onTap: () async {
                final photo = await _pickImage();
                await userProvider.updateProfilePic(photo!);
                setState(() {});
              },
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 20),

                    Text(
                      "Account",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Container(
                        height: isTablet ? 150 : 120,
                        width: isTablet ? 150 : 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Stack(
                            children: [
                              Image.network(
                                user!.profilePic!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                              Positioned(
                                bottom: 15,
                                right: 10,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    color: Colors.black,
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "${user.name} ",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),

                    Text(
                      "${user.email}",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 20),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.grey.shade800,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 280.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey.shade300,
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 15),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.grey.shade400,
                            ),
                            child: Icon(Icons.edit, size: 20),
                          ),
                          SizedBox(width: 15),
                          Text(
                            "Edit Profile",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: Icon(Icons.arrow_forward_ios, size: 20),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey.shade300,
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 15),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.grey.shade400,
                            ),
                            child: Icon(Icons.person_off, size: 20),
                          ),
                          SizedBox(width: 15),
                          Text(
                            "View Blocked Users",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: Icon(Icons.arrow_forward_ios, size: 20),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey.shade300,
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 15),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.grey.shade400,
                            ),
                            child: Icon(Icons.settings, size: 20),
                          ),
                          SizedBox(width: 15),
                          Text(
                            "Settings",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: Icon(Icons.arrow_forward_ios, size: 20),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          supabase.auth.signOut();
                          taskProvider.cleartasks();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Signup()),
                          );
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey.shade300,
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 15),
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.grey.shade400,
                              ),
                              child: Icon(
                                Icons.edit,
                                size: 20,
                                color: Colors.redAccent,
                              ),
                            ),
                            SizedBox(width: 15),
                            Text(
                              "Logout",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.redAccent,
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: Icon(Icons.arrow_forward_ios, size: 20),
                            ),
                          ],
                        ),
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
}

                  //   const SizedBox(height: 16),
                  //   ...userInfo.asMap().entries.map((entry) {
                  //     final index = entry.key;
                  //     final item = entry.value;

                  //     return Column(
                  //       children: [
                  //         ListTile(
                  //           leading: Icon(
                  //             getIcon(item['icon']!),
                  //             size: isTablet ? 30 : 24,
                  //           ),
                  //           title: Text(
                  //             item['label']!,
                  //             style: TextStyle(fontSize: isTablet ? 18 : 16),
                  //           ),
                  //           subtitle: Text(
                  //             item['value']!,
                  //             style: TextStyle(fontSize: isTablet ? 16 : 14),
                  //           ),
                  //         ),
                  //         if (index != userInfo.length - 1)
                  //           const Divider(), // ✅ Only show divider if NOT last
                  //       ],
                  //     );
                  //   }).toList(),

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_team/main.dart';

class UserClass {
  String id;
  String? name;
  String email;
  String? profilePic;
  UserClass({
    required this.id,
    this.name,
    required this.email,
    this.profilePic,
  });
}

class UserProvider with ChangeNotifier {
  UserClass? _user;
  UserClass? get user => _user;
  Future<void> addUser(String email, String id) async {
    try {
      print(id);
      // Fetch User from Supabase
      final response = await supabase
          .from("profiles")
          .select()
          .eq('user_id', id);

      print("Fetched taskssssss: $response");
      _user = UserClass(
        id: id,
        email: email,
        name: response[0]["full_name"],
        profilePic:
            response[0]["profile_pic"] ??
            "https://ui-avatars.com/api/?name=${response[0]["full_name"]}",
      );

      print(_user.toString());

      // Notify listeners so UI rebuilds
      notifyListeners();
    } catch (error) {
      print("Error fetching tasks: $error");
    }
  }

  Future<void> updateProfilePic(XFile file) async {
    try {
      final response = await supabase.storage
          .from("avatars")
          .upload('users/${_user!.id}/image', File(file.path));
      print("response ${response.toString()}");
      // Handle success (e.g., retrieve public URL)
      final String publicUrl = await supabase.storage
          .from("avatars")
          .createSignedUrl(
            "users/${_user!.id}/image",
            10 * 365 * 24 * 60 * 60,
          ); // abdaladarwesh63@gmail.com
      await supabase
          .from("profiles")
          .update({"profile_pic": publicUrl})
          .eq("user_id", _user!.id);
      _user!.profilePic = publicUrl;
      print('Image uploaded successfully: $publicUrl');
      notifyListeners();
    } on StorageException catch (e) {
      print('Error uploading image: ${e.message}');
    } catch (e) {
      print('An unexpected error occurred: $e');
    }
  }

  Future<void> changeName(String name) async {
    try {
      await supabase
          .from('profiles')
          .update({'full_name': name})
          .eq('user_id', _user!.id);
      _user!.name = name;
    } catch (e) {
      print("Error from update name ${e.toString()}");
    }
  }
}

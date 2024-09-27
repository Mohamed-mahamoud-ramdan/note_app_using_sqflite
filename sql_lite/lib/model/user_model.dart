import 'package:sql_lite/helper/constant.dart';

class UserModle {
  int? id; // Nullable id for auto-increment
  String name, email, phone;

  UserModle({
    this.id, // Not required
    required this.name,
    required this.email,
    required this.phone,
  });

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      // Do not include id if it's null, as SQLite will auto-increment it
      if (id != null) uid: id,
      uname: name,
      uemial: email,
      uphone: phone
    };
  }

  // Create UserModle from JSON (e.g., from a database record)
  factory UserModle.fromJson(Map<String, dynamic> json) {
    return UserModle(
      id: json[uid], // id may or may not be null
      name: json[uname],
      email: json[uemial],
      phone: json[uphone],
    );
  }
}

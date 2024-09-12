class Users {
  String? id;
  String? userName;
  String? email;

  Users({this.id, this.userName, this.email});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['username'] = userName;
    data['email'] = email;
    return data;
  }

  // Tạo đối tượng User từ JSON
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'],
      userName: json['username'],
      email: json['email'],
    );
  }

  @override
  String toString() {
    return 'User{id: $id, userName: $userName, email: $email}';
  }
}

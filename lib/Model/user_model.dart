class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatar: json['avatar'],
    );
  }
}

class UserResponse {
  final List<User> users;
  final int page;

  UserResponse({required this.users, required this.page});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    var usersJson = json['data'] as List;
    List<User> usersList = usersJson.map((userJson) => User.fromJson(userJson)).toList();
    return UserResponse(users: usersList, page: json['page']);
  }
}

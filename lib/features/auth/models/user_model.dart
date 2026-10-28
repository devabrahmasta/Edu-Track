class UserModel {
  const UserModel({
    required this.username,
    required this.firstName,
    required this.lastName,
    this.id,
    this.email = '',
    this.image = '',
    this.token,
    this.isOfflineSession = false,
  });

  final int? id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String image;
  final String? token;
  final bool isOfflineSession;

  String get fullName {
    final name = '$firstName $lastName'.trim();
    return name.isEmpty ? username : name;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      username: json['username'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      image: json['image'] as String? ?? '',
      token: json['token'] as String?,
      isOfflineSession: json['isOfflineSession'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'image': image,
    'token': token,
    'isOfflineSession': isOfflineSession,
  };
}

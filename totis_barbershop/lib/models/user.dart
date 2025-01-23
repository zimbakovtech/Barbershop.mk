class User {
  final int id;
  final String firstName;
  final String lastName;
  final String? email;
  String phoneNumber;
  final String? userType;
  final String? profilePicture;
  String? token;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    required this.phoneNumber,
    required this.userType,
    this.profilePicture,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    String first, last;
    if (json['full_name'] != null) {
      final names = json['full_name'].split(' ');
      first = names[0];
      last = names[1];
    } else {
      first = json['first_name'];
      last = json['last_name'];
    }
    return User(
      id: json['id'],
      firstName: first,
      lastName: last,
      email: json['email'],
      phoneNumber: json['phone_number'],
      userType: json['user_type'],
      profilePicture: json['profile_picture'],
      token: null,
    );
  }
}

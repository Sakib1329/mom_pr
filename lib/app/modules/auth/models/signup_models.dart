class SignupModel {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String country;

  SignupModel({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.country,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'first_name': firstName,
    'last_name': lastName,
    'country': country,
  };
}

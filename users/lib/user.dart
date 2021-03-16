
class User {
  final String name;
  final String email;
  final String picture;

  User({this.name, this.email, this.picture});

  factory User.fromJson(Map<String, dynamic> jsonData) {
    var name = '${jsonData['name']['first']} ${jsonData['name']['last']}';
    var email = jsonData['email'];
    var picture = jsonData['picture']['medium'];

    return User(
      name: name, email: email, picture: picture
    );
  }
}

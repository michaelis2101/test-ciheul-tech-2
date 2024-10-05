class UserModel {
  // Define class properties
  int? id;
  String? username; 
  String? password; 


  UserModel(this.username, this.password, {this.id});


  UserModel.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    username = map['username'];
    password = map['password'];
  }

// Method to convert a 'NoteModel' to a map
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

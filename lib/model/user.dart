import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser{
  static String UsersCollection = "users" ;
  String? id;
  String? name;
  String? email;

  MyUser({required this.id , required this.name , required this.email});

  MyUser.fromJson(Map<String,dynamic>user){
    id = user['id'];
    name = user['name'];
    email = user['email'];
  }

  Map<String , dynamic> toJson(){
    return{
      "id":id,
      "name":name,
      "email":email
    };
  }
  static CollectionReference<MyUser> getUsersCollectionReference(){
    return FirebaseFirestore.instance.collection(MyUser.UsersCollection).withConverter<MyUser>(
        fromFirestore: (snapshot , _)=>MyUser.fromJson(snapshot.data()!),
        toFirestore: (user , _)=>user.toJson()
    );
  }
}
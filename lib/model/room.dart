import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Room{
  String? id;
  String? roomName;
  String? description;
  int? memberNumber;
  String? categoryId;
  List<String>? users;
  Room({required this.id , required this.roomName , required this.description , required this.categoryId, required this.memberNumber ,  required this.users});

  Room.fromJson(Map<String,dynamic>room){
    id = room['id'];
    roomName = room['room_name'];
    description = room['description'];
    categoryId = room['category_id'];
    memberNumber = room['member_number'];
    if(room['users']!=null){
      users = [];
      room['users'].forEach((v){
        users?.add(v);
      });
    }
  }

  Map<String , dynamic> toJson(){

    return{
      "id":id,
      "room_name":roomName,
      "description":description,
      "category_id":categoryId,
      "member_number":memberNumber,
      "users":users
    };
  }

  static CollectionReference<Room> getRoomsCollectionReference(){
    return FirebaseFirestore.instance.collection("rooms").withConverter<Room>(
        fromFirestore: (snapshot,_)=>Room.fromJson(snapshot.data()!),
        toFirestore: (room,_)=>room.toJson()
    );
  }
}
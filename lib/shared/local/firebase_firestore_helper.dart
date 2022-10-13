import 'package:chat_app/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/message.dart';
import '../../model/room.dart';

class FirebaseFirestoreHelper{
  static Future<void> register(MyUser user)async{
    return MyUser.getUsersCollectionReference().doc(user.id).set(user);
  }
  static Future<DocumentSnapshot<MyUser>> login(String id)async{
    return MyUser.getUsersCollectionReference().doc(id).get();
  }
  static Future<void> addRoom(Room room)async{
    DocumentReference doc = Room.getRoomsCollectionReference().doc();
    room.id = doc.id;
    return doc.set(room);
  }
  static Stream<QuerySnapshot<Room>> getAllRooms({bool isMyRooms = false , required String userID}){
    return isMyRooms?Room.getRoomsCollectionReference().where('users',arrayContains: userID).snapshots()
        :Room.getRoomsCollectionReference().snapshots();
  }
  static Stream<QuerySnapshot<Message>> getRoomMessages(String roomId){
    return Message.getMessageCollection(roomId).orderBy("date",descending: true).snapshots();
  }
  static Future<void> SendMessage(String roomId , Message message){
    DocumentReference documentReference = Message.getMessageCollection(roomId).doc();
    message.id = documentReference.id;
    return documentReference.set(message);
  }
  static Future<void> leaveOrJoinRoom(String roomId , Room room){
    return Room.getRoomsCollectionReference().doc(roomId).set(room);
  }

}
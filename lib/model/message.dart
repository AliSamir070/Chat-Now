import 'package:chat_app/model/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  String? id;
  String? senderId;
  String? content;
  int? date;
  String? senderName;

  Message({required this.id , required this.senderId , required this.content , required this.date , required this.senderName});

  Message.fromJson(Map<String,dynamic>message){
    id = message['id'];
    senderId = message['sender_id'];
    content = message['content'];
    date = message['date'];
    senderName = message['sender_name'];
  }

  Map<String , dynamic> toJson(){
    return{
      "id":id,
      "sender_id":senderId,
      "content":content,
      "date":date,
      "sender_name":senderName
    };
  }

  static CollectionReference<Message> getMessageCollection(String roomId){
    return Room.getRoomsCollectionReference().doc(roomId).collection("messages").withConverter<Message>(
        fromFirestore: (snapshot,_)=>Message.fromJson(snapshot.data()!),
        toFirestore: (message , _)=>message.toJson());
  }
}
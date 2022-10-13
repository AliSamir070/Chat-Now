import 'package:chat_app/layout/chat/chat_interface.dart';
import 'package:chat_app/model/message.dart';
import 'package:chat_app/shared/local/firebase_firestore_helper.dart';
import 'package:flutter/material.dart';

import '../../model/room.dart';

class ChatViewModel extends ChangeNotifier{
  void sendMessage(TextEditingController messageController , String senderId , String roomId , String senderName){
    if(messageController.text.trim().isEmpty) return;
    Message message = Message(
        id: "",
        senderId: senderId,
        content: messageController.text,
        date: DateTime.now().millisecondsSinceEpoch,
        senderName: senderName
    );
    FirebaseFirestoreHelper.SendMessage(roomId, message).then((value){
      messageController.clear();
    });

  }
  void leaveRoom (Room room , String userId){
    room.users!.remove(userId);
    FirebaseFirestoreHelper.leaveOrJoinRoom(room.id!, room).then((value){
      notifyListeners();
    });
  }
  void joinRoom(Room room , String userId){
    room.users!.add(userId);
    FirebaseFirestoreHelper.leaveOrJoinRoom(room.id!, room).then((value){
      notifyListeners();
    });
  }
}
import 'package:chat_app/shared/local/firebase_firestore_helper.dart';
import 'package:chat_app/shared/local/provider/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../layout/chat/chat_screen.dart';
import '../../model/category.dart';
import '../../model/message.dart';
import '../../model/room.dart';

class RoomsView extends StatelessWidget {
  bool isMyRooms;
  String userID;
  RoomsView({required this.isMyRooms , required this.userID});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Room>>(
        stream: FirebaseFirestoreHelper.getAllRooms(isMyRooms: isMyRooms , userID: userID),
        builder: (context, asyncsnapshot) {
          if (asyncsnapshot.hasData) {
            List<Room> rooms = asyncsnapshot.data!.docs.map((doc) {
              return Room(
                  id: doc
                      .data()
                      .id,
                  roomName: doc
                      .data()
                      .roomName,
                  description: doc
                      .data()
                      .description,
                  categoryId: doc
                      .data()
                      .categoryId,
                  memberNumber: doc.data().memberNumber,
                  users: doc.data().users);
            }).toList();
            print("Data");
            return rooms.isEmpty?Center(
                child: Text(
              "No Rooms",
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyLarge,
            )
            ):GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20
                ),
                itemBuilder: (context , index){
                  return RoomItem(room: rooms[index]);
                },
                itemCount: rooms.length,
            );
          } else if (asyncsnapshot.hasError) {
            return Center(child: Text(
              asyncsnapshot.error.toString(),
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyLarge,
            ),
            );
          } else {
            return Center(child: CircularProgressIndicator(),);
          }
        }
    );
  }
}
class RoomItem extends StatelessWidget {
  Room room;
  late AuthProvider provider;
  RoomItem({required this.room});

  @override
  Widget build(BuildContext context) {
    provider = Provider.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, ChatScreen.route,arguments: room);
      },
      child: Container(
        padding: EdgeInsetsDirectional.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusDirectional.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Image(
                image: AssetImage(Category.getCategorybyId(room.categoryId!)!.imagePath),
                height: height*0.1,
                width: width*0.2,
            ),
            SizedBox(height: height*0.01,),
            Text(
              room.roomName!,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: height*0.01,),
            Text(
              '${room.memberNumber} Members',
              style: Theme.of(context).textTheme.headlineMedium,
            )
          ],
        ),
      ),
    );
  }
}
class MessageItem extends StatelessWidget {
  Message message;
  bool isRight;
  DateFormat format = DateFormat.jm();
  MessageItem({required this.message , required this.isRight});
  @override
  Widget build(BuildContext context) {
    double width  = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: isRight?CrossAxisAlignment.end:CrossAxisAlignment.start,
      children: [
        if(!isRight)
          Text(
            message.senderName!,
            style: Theme.of(context).textTheme.labelLarge,
            textAlign: TextAlign.start,
          ),
        Container(
          width: width*0.7,
          child: Row(
            mainAxisAlignment: isRight?MainAxisAlignment.end:MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Container(
                  padding: EdgeInsetsDirectional.all(10),
                  decoration: BoxDecoration(
                    color: isRight?Theme.of(context).primaryColor:Theme.of(context).secondaryHeaderColor,
                    borderRadius: isRight?BorderRadiusDirectional.only(
                      topEnd: Radius.circular(20),
                      topStart: Radius.circular(20),
                      bottomEnd: Radius.zero,
                      bottomStart: Radius.circular(20)
                    ):BorderRadiusDirectional.only(
                        topEnd: Radius.circular(20),
                        topStart: Radius.circular(20),
                        bottomEnd: Radius.circular(20),
                        bottomStart: Radius.zero
                    ),

                  ),
                  child: Text(
                    message.content!,
                    style: isRight?Theme.of(context).textTheme.bodyMedium:Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ),
              SizedBox(width: 10,),
              Text(
                format.format(DateTime.fromMillisecondsSinceEpoch(message.date!)),
                style: Theme.of(context).textTheme.labelSmall,
              )
            ],
          ),
        )
      ],
    );
  }
}



import 'package:chat_app/layout/chat/chat_interface.dart';
import 'package:chat_app/layout/chat/chat_viewmodel.dart';
import 'package:chat_app/model/message.dart';
import 'package:chat_app/shared/local/cache_helper.dart';
import 'package:chat_app/shared/local/components.dart';
import 'package:chat_app/shared/local/firebase_firestore_helper.dart';
import 'package:chat_app/shared/local/provider/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/room.dart';

class ChatScreen extends StatefulWidget {
  static String route = "ChatScreen";

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatViewModel _chatViewModel;
  late AuthProvider _authProvider;
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width  = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Room room = ModalRoute.of(context)!.settings.arguments as Room;
    return ChangeNotifierProvider(
      create: (context)=>ChatViewModel(),
      builder: (context , _){
        _chatViewModel = Provider.of(context);
        _authProvider = Provider.of(context);
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/back.png'),
                  fit: BoxFit.cover
              ),
              color: Colors.white
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(
                  room.roomName!
              ),
              actions: [
                PopupMenuButton(
                    icon: Icon(
                      Icons.more_vert
                    ),
                    iconSize: 30,
                    padding: EdgeInsetsDirectional.all(0),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(10)
                    ),
                    itemBuilder: (context){
                      return[
                        PopupMenuItem(
                            value: 1,
                            child: TextButton(
                                onPressed: (){
                                  _chatViewModel.leaveRoom(room, _authProvider.user!.id!);
                                },
                                child: Text(
                                  'Leave Room',
                                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                      fontSize: 13
                                  ),

                                )
                            )
                        )
                      ];
                    }
                )
              ],
            ),
            body: Container(
              padding: EdgeInsetsDirectional.all(10),
              margin: EdgeInsetsDirectional.only(
                  start: width*0.05,
                  end: width*0.05,
                  top: height*0.02,
                  bottom: height*0.08
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadiusDirectional.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: room.users!.contains(_authProvider.user!.id)?StreamBuilder<QuerySnapshot<Message>>(
                stream: FirebaseFirestoreHelper.getRoomMessages(room.id!),
                builder: (context , asyncsnapshot){
                  if(asyncsnapshot.hasData){
                    List<Message> messages = asyncsnapshot.data!.docs.map((e){
                      return e.data();
                    }).toList();
                    return Column(
                      children: [
                        Expanded(
                            child: ListView.separated(
                                itemBuilder: (context , index)=>MessageItem(message: messages[index], isRight: messages[index].senderId==CacheHelper.getUserId()),
                                itemCount: messages.length,
                                reverse: true,
                                separatorBuilder: (context , index)=>SizedBox(height: 10,),
                            )
                        ),
                        SizedBox(height: 10,),
                        Container(
                          height: height*0.04,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: messageController,
                                  style: Theme.of(context).textTheme.headlineSmall,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsetsDirectional.only(top: height*0.02 , start: 10),
                                    hintStyle: Theme.of(context).textTheme.headlineSmall,
                                    hintText: "Type a message",
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(25))
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(25))
                                    ),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(25))
                                    ),
                                    border:  OutlineInputBorder(
                                      borderRadius: BorderRadius.only(topRight: Radius.circular(25))
                                    )
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              ElevatedButton(
                                  onPressed: (){
                                    _chatViewModel.sendMessage(messageController, CacheHelper.getUserId()!, room.id! , _authProvider.user!.name!);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                          'Send',
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                      SizedBox(width: 10,),
                                      Image(
                                          image: AssetImage('assets/images/send.png')
                                      )
                                    ],
                                  )
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  }else if(asyncsnapshot.hasError){
                    return Center(child: Text(
                      asyncsnapshot.error.toString(),
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyLarge,
                    ),
                    );
                  }else{
                    return Center(child: CircularProgressIndicator(),);
                  }
                },
              )
              :Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Text(
                      'Hello, Welcome to our chat room',
                      style: Theme.of(context).textTheme.labelMedium,),
                    SizedBox(height: height*0.05,),
                    Text(
                        "Join The ${room.roomName}",
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: height*0.05,),
                    Image(
                        image: AssetImage(
                            'assets/images/${room.categoryId}.png'
                        ),
                        height: 200,
                        width: 200,
                    ),
                    SizedBox(height: height*0.05,),
                    Text(
                      room.description!,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    SizedBox(height: height*0.05,),
                    ElevatedButton(
                        onPressed: (){
                          _chatViewModel.joinRoom(room, _authProvider.user!.id!);
                        },
                        child: Text(
                          'Join',
                          style: Theme.of(context).textTheme.displayLarge,
                        )
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}

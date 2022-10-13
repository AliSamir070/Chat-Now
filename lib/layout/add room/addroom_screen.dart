import 'package:chat_app/layout/add%20room/addroom_viewmodel.dart';
import 'package:chat_app/model/category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/local/cache_helper.dart';
import '../../shared/local/utils.dart';
import '../home/home_screen.dart';
import 'addroom_interface.dart';

class AddRoomScreen extends StatefulWidget {
  static String route = "AddRoomScreen";

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> implements AddRoomInterface {
  TextEditingController roomNameController = TextEditingController();

  TextEditingController roomDescController = TextEditingController();

  late AddRoomViewModel _addRoomViewModel;

  var categories = Category.getCategories();

  @override
  Widget build(BuildContext context) {
    double width  = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider(
        create: (context)=>AddRoomViewModel(),
        builder: (context , _){
          _addRoomViewModel = Provider.of(context);
          _addRoomViewModel.navigator = this;
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
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text(
                    'Chat Now'
                ),
              ),
              body: Center(child: Container(
                padding: EdgeInsetsDirectional.all(20),
                margin: EdgeInsetsDirectional.only(
                    start: width*0.1,
                    end: width*0.1,
                    top: height*0.02,
                    bottom: height*0.15
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
                child: Form(
                  key: _addRoomViewModel.formKey,
                  child: Column(
                    children: [
                      Text(
                        'Create New Room',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: height*0.04,),
                      Image(image: AssetImage("assets/images/addroom.png"),fit: BoxFit.cover,),
                      SizedBox(height: height*0.04,),
                      TextFormField(
                        style: Theme.of(context).textTheme.titleSmall,
                        keyboardType: TextInputType.text,
                        controller: roomNameController,
                        validator: (value){
                          if(value!.trim().isEmpty){
                            return "Room Name shouldn't be empty";
                          }
                          return null;
                        },
                        onFieldSubmitted: (value){
                          _addRoomViewModel.addRoom(roomNameController.text, roomDescController.text,CacheHelper.getUserId()!);
                        },
                        decoration: InputDecoration(
                           contentPadding: EdgeInsetsDirectional.all(10),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 3
                              )
                          ),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).canvasColor
                              )
                          ),
                          labelText: 'Enter Room Name',
                          labelStyle: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      SizedBox(height: height*0.02,),
                      Container(
                        width: double.infinity,
                        child: DropdownButtonFormField<Category>(
                            isExpanded: true,
                            value: _addRoomViewModel.SelectedCategory,
                            validator: (value){
                              if(value == null){
                                return "Select Category";
                              }
                              return null;
                            },
                            items: categories.map((category){
                              return DropdownMenuItem<Category>(
                                  value: category,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        category.title,
                                        style: Theme.of(context).textTheme.bodyLarge,
                                      ),
                                      Image(
                                          image: AssetImage(
                                            category.imagePath,
                                          ),
                                          height: 50,
                                          width: 50,
                                      )
                                    ],
                                  )
                              );
                            }).toList(),
                            onChanged: (value){
                              _addRoomViewModel.setCategory(value);
                            },
                            hint: Text(
                              'Select Room Category',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                        ),
                      ),
                      SizedBox(height: height*0.02,),
                      TextFormField(
                        style: Theme.of(context).textTheme.titleSmall,
                        keyboardType: TextInputType.text,
                        controller: roomDescController,
                        validator: (value){
                          if(value!.trim().isEmpty){
                            return "Room Description shouldn't be empty";
                          }
                          return null;
                        },
                        onFieldSubmitted: (value){
                          _addRoomViewModel.addRoom(roomNameController.text, roomDescController.text,CacheHelper.getUserId()!);
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsetsDirectional.all(10),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 3
                              )
                          ),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).canvasColor
                              )
                          ),
                          labelText: 'Enter Room Description',
                          labelStyle: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: width*0.7,
                        child: ElevatedButton(
                            onPressed: (){
                              _addRoomViewModel.addRoom(roomNameController.text, roomDescController.text,CacheHelper.getUserId()!);
                            },
                            child: Text(
                              'Create',
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsetsDirectional.all(15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusDirectional.circular(30)
                            )
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )),
            ),
          );
        },
    );
  }

  @override
  void NavigateToHome() {
    Navigator.pushReplacementNamed(context, HomeScreen.route);
  }

  @override
  void ShowLoading() {
    showAuthLoading(context);
  }

  @override
  void hideLoading() {
    hideAuthLoading(context);
  }

  @override
  void showToast() {
    showToastMessage(context, "Room added successfully");
  }
}

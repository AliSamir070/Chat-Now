import 'package:chat_app/layout/add%20room/addroom_screen.dart';
import 'package:chat_app/layout/home/home_interface.dart';
import 'package:chat_app/layout/home/home_viewmodel.dart';
import 'package:chat_app/shared/local/components.dart';
import 'package:chat_app/shared/local/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static String route = "HomeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> implements HomeInterface {
  late HomeViewModel _homeViewModel;
  late AuthProvider provider;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider(
      create: (context)=>HomeViewModel(),
      builder: (context , _){
        _homeViewModel = Provider.of(context);
        _homeViewModel.interface = this;
        provider = Provider.of(context);
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/back.png'),
                  fit: BoxFit.cover
              ),
              color: Colors.white
          ),
          child: provider.user==null?Center(child: CircularProgressIndicator(),):Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(
                  'Chat Now'
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _homeViewModel.goToAddRoom();
              },
              child: Icon(
                  Icons.add
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                        indicatorColor: Colors.white,
                        labelStyle: Theme.of(context).textTheme.displayLarge,
                        tabs: [
                          Tab(
                            text: "My Rooms",
                          ),
                          Tab(
                            text: "Browse",
                          ),
                        ]
                    ),
                    SizedBox(height: height*0.05,),
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TabBarView(
                              children: [
                                RoomsView(isMyRooms: true , userID: provider.user!.id!),
                                RoomsView(isMyRooms: false , userID: provider.user!.id!)
                              ]
                          ),
                        )),
                  ],
                ),

              ),
            ),
          ),
        );
      },

    );
  }

  @override
  void NavigateToAddRoom() {
    Navigator.pushNamed(context, AddRoomScreen.route);
  }
}

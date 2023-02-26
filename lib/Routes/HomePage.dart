import 'package:map_test/Constants/Constants.dart';
import 'package:map_test/Routes/AddProperty.dart';
import 'package:map_test/Routes/Profile.dart';
import 'package:map_test/Routes/Messages.dart';
import 'package:map_test/Routes/Properties.dart';
import 'package:map_test/Routes/MapPage.dart';
import 'package:map_test/Routes/homeScreen.dart';
import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//import '../Widgets/TypeProperties.dart';
class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState()  => HomePageState();
}

void main() => runApp(
  MaterialApp(
      debugShowCheckedModeBanner: false,

      home: HomePage(),
      theme: ThemeData(
          primaryColor: Constants.greenAirbnb,
          accentColor: Constants.redAirbnb,
          scaffoldBackgroundColor: Colors.orange[400]
      )
  ),
);


class HomePageState extends State<HomePage> {
  int _currentTab=0;
  List<Widget> _children=[HomeScreen(),MapPage(),Messages(),Profile()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFE7EBEE),
      body: SafeArea(
        child: _children[_currentTab],
      ),
      bottomNavigationBar: BottomNavigationBar(
          elevation: 5,
          selectedItemColor: Constants.greenAirbnb,
          unselectedItemColor: Colors.grey[800],
          type: BottomNavigationBarType.fixed,
          onTap: (int value) {
            setState(() {
              _currentTab=value;
            });
          },
          currentIndex: _currentTab,
          items:[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: 30,
              ),
              label:"LOCALS",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.map,
                //color: Colors.black,
                size: 30,
              ),
              label: "MAP",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.chat_bubble_outline,

                size: 30,
              ),
              label: "MESSAGES",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outline,

                size: 30,
              ),
              label: "PROFILE",
            )
          ],
          selectedLabelStyle: TextStyle(fontSize: 11),
      ),
    );
  }
}

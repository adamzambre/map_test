import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Services/authententication.dart';
import 'package:provider/provider.dart';
import 'package:map_test/Model/user.dart';
import 'package:map_test/wrapper.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
 /* class SplashScreen extends StatefulWidget {
    const SplashScreen({Key? key}) : super(key: key);

    @override
    _SplashScreenState createState() => _SplashScreenState();
  }

  class _SplashScreenState extends State<SplashScreen> {
    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      Future.delayed(Duration(seconds: 5)).then((value) => Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomePage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 200.0,
          width: 200.0,
          child: LottieBuilder.asset('assets/animassets/mapanimation.json')),
        ),
    );
  }
}*/


import 'package:map_test/Constants/Constants.dart';
import 'package:flutter/material.dart';
import 'package:map_test/Map.dart';
import 'package:map_test/Routes/HomePage.dart';
import 'package:map_test/Services/authententication.dart';
import 'package:map_test/Routes/Registration.dart';
//import 'HomePage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _inscription=false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController name = TextEditingController();
  final AuthService _auth = AuthService();

  BoxDecoration customDecoration ()//method returning a boxDecoration
  {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          offset: Offset(0,2),
          color: (Colors.grey[300])!,
          blurRadius: 5,
        )],
    );
  }

  @override
  void initState() {
    super.initState();
    // Initialize the text controller here
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 300,
                  width: 300,
                  child: Image(
                    image: AssetImage("assets/images/logo.png"),
                    fit: BoxFit.scaleDown,
                  ),
                ),
                Text("Welcome",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                SizedBox(height: 25,),
                /*Visibility(
                  visible: _inscription,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: customDecoration(),
                    child: TextField(
                      controller: name,
                      decoration: InputDecoration(
                          hintText: "Your Full Name",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.person_outline,color: Constants.greenAirbnb,)
                      ),
                    ),
                  ),
                ),*/
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  decoration:  customDecoration(),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "Email",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.mail_outline,color: Constants.greenAirbnb,),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: customDecoration(),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: "Password",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.lock_outline,color: Constants.greenAirbnb,)
                    ),
                  ),
                ),
                Visibility(
                  visible: !_inscription,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom:30),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Text("Forgot password ?",style: TextStyle(color: Constants.greenAirbnb,fontSize: 12),)),
                  ),
                ),
                SizedBox(height:_inscription? 30:0 ,),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap:() async{
                    if(!_inscription){//user log in
                      print("User is logging in ");
                      if (emailController.text.isEmpty || !emailController.text.contains('@')) {
                        // Display an error message if the email is invalid
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please enter a valid email')),
                        );
                      }else if(passwordController.text.isEmpty || passwordController.text.length < 6){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please enter a valid password')),
                        );
                      }else{
                        dynamic result = await _auth.logIn(emailController.text, passwordController.text);
                        if(result[0]){
                          Navigator.push(
                              context,MaterialPageRoute(
                              builder: (context) => HomePage()
                          )
                          );
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(result[1])),
                          );
                        }
                      }
                    }else{//user creates an account
                      print("User creates an account");
                      if (emailController.text.isEmpty || !emailController.text.contains('@')) {
                        // Display an error message if the email is invalid
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please enter a valid email')),
                        );
                      }else if(passwordController.text.isEmpty || passwordController.text.length < 6){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please enter a valid password')),
                        );
                      }else{
                        dynamic result = await _auth.signUp(emailController.text, passwordController.text);
                        if(result[0]){
                          Navigator.push(
                              context,MaterialPageRoute(
                              builder: (context) => Registration()
                          )
                          );
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(result[1])),
                          );
                        }
                      }
                    }
                  },
                  splashColor: Colors.white,
                  hoverColor: Constants.greenAirbnb,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Constants.greenAirbnb,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0,2),
                          color: Colors.grey,
                          blurRadius: 5,
                        )],
                    ),
                    child: Center(child: Text(!_inscription?"Continue":"Login",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),)),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _inscription=!_inscription;
                    });
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: InkWell(
                        child: RichText(
                          text: TextSpan(
                              text:  _inscription?"Do you have an account ? ":"New User ?",
                              style: TextStyle(color: Colors.grey[500], fontSize: 14,fontWeight: FontWeight.w500),
                              children: [
                                TextSpan(
                                  text:_inscription?"Sign in":" Create an account",
                                  style: TextStyle(color: Constants.greenAirbnb,fontWeight: FontWeight.w600, fontSize: 14),)
                              ]),
                        ),
                      ),
                    ),
                  ),
                ),
                //SizedBox(height: 20,),
                //Text("Or continue with " ,style: TextStyle(color: Colors.grey[500], fontSize: 14,fontWeight: FontWeight.w500),),
                //SizedBox(height: 15,),
                //Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //children: [
                    //ContinueWith("assets/images/social_media/google.png"),
                    //ContinueWith("assets/images/social_media/phone.png"),
                  //],
               //)
              ],
            ),
          ),
        ),
      ),
    );


  }
  Container ContinueWith(String image) {
    return Container(
      padding: EdgeInsets.all(15),
      height: 50,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                offset: Offset(0,3),
                color: Colors.grey,
                blurRadius: 5
            )
          ]

      ),
      child: Image.asset(image,),
    );
  }
}
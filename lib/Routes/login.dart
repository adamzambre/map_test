import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:map_test/Constants/Constants.dart';
import 'package:flutter/material.dart';
import 'package:map_test/Map.dart';
import 'package:map_test/Routes/HomePage.dart';
import 'package:map_test/Routes/local_tour_guides/HomePageLTG.dart';
import 'package:map_test/Services/authententication.dart';
import 'package:map_test/Routes/Registration.dart';
//import 'HomePage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool newUser=false;//by default user creats an account//
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController name = TextEditingController();
  final AuthService _auth = AuthService();
  bool LocalTourGuide=false;

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
                TouristOrLocalWidget(),
                email(),
                password(),
                //forgetPassword(),
                //SizedBox(height:_inscription? 30:0 ,),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap:() async{
                    if(LocalTourGuide==false){
                      if(!newUser){//user log in
                        print("Tourist is logging in ");
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
                          dynamic result = await _auth.TouristLogIn(emailController.text, passwordController.text);
                          if(result[0]){
                            Navigator.push(
                                context,MaterialPageRoute(
                              builder: (context) =>HomePage(),
                            )
                            );
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(result[1])),
                            );
                          }
                        }
                      }else{//user creates an account
                        print("Tourist creates an account");
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
                          dynamic result = await _auth.TouristSignUp(emailController.text, passwordController.text);
                          dynamic result2 = await _auth.addTouristUid();
                          if(result[0]&&result2[0]){
                            Navigator.push(
                                context,MaterialPageRoute(
                                builder: (context) => HomePage()
                            )
                            );
                          }else{
                            if(!result[0]){
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(result[1])),
                              );
                            }else if(!result2[0]){
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(result2[1])),
                              );
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Database error")),
                              );
                            }
                          }
                        }
                      }
                    }else if(LocalTourGuide==true){
                      ///////////////////////////////start dari sini nak sign in local tour guide secara sendiri
                      if(!newUser){//user log in
                        print("local is logging in ");
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
                          dynamic result = await _auth.LocalTourGuideLogIn(emailController.text, passwordController.text);
                          if(result[0]){
                            Navigator.push(
                                context,MaterialPageRoute(
                              builder: (context) =>HomePageLTG(),
                            )
                            );
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(result[1])),
                            );
                          }
                        }
                      }else{//user creates an account
                        print("local creates an account");
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
                          dynamic result = await _auth.LocalTourGuideSignUp(emailController.text, passwordController.text);
                          dynamic result2 = await _auth.addLocalTourGuideUid();
                          if(result[0]&&result2[0]){
                            Navigator.push(
                                context,MaterialPageRoute(
                                builder: (context) => HomePageLTG()
                            )
                            );
                          }else{
                            if(!result[0]){
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(result[1])),
                              );
                            }else if(!result2[0]){
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(result2[1])),
                              );
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Database error")),
                              );
                            }
                          }
                        }
                      }
                      ///////////////////////////////sampai sini
                      // print("Local Tour Guide is logging in ");//ni just so local tour guide boleh log in je
                      // if (emailController.text.isEmpty || !emailController.text.contains('@')) {
                      //   // Display an error message if the email is invalid
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(content: Text('Please enter a valid email')),
                      //   );
                      // }else if(passwordController.text.isEmpty || passwordController.text.length < 6){
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(content: Text('Please enter a valid password')),
                      //   );
                      // }else{
                      //   dynamic result = await _auth.LocalTourGuideLogIn(emailController.text, passwordController.text);
                      //   dynamic result2 = await _auth.addLocalTourGuideUid();
                      //   if(result[0]&&result2[0]){
                      //     Navigator.push(
                      //         context,MaterialPageRoute(
                      //         builder: (context) => HomePage()
                      //     )
                      //     );
                      //   }if(!result[0]){
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       SnackBar(content: Text(result[1])),
                      //     );
                      //   }else if(!result2[0]){
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       SnackBar(content: Text(result2[1])),
                      //     );
                      //   }else{
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       SnackBar(content: Text("Database error")),
                      //     );
                      //   }
                      // }
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Bruh, select a user type")),
                      );
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
                    child: Center(child: Text(!newUser?"Continue":"Login",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),)),
                    //whole expression true: user creates account
                    //whole expression false: user logs in
                  ),
                ),
                UserSigninOrLogIn(),
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

  Widget email()=>
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
      );

  Widget password()=>
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
      );

  Widget forgetPassword()=>
    Visibility(
      visible: !newUser,
      child: Padding(
        padding: const EdgeInsets.only(bottom:30),
        child: Align(
            alignment: Alignment.centerRight,
            child: Text("Forgot password ?",style: TextStyle(color: Constants.greenAirbnb,fontSize: 12),)),
      ),
    );


  final List<String> UserTypes = [
    'Tourists',
    'Local Tour Guides',
  ];
  String? selectedValue;

  Widget TouristOrLocalWidget()=>
      Container(
        margin: EdgeInsets.only(bottom: 20),
        child: DropdownButtonFormField2(
          decoration: InputDecoration(
            //Add isDense true and zero Padding.
            //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
            isDense: true,
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            //Add more decoration as you want here
            //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
          ),
          isExpanded: true,
          hint: const Text(
            'Please select what will you be using this application as',
            style: TextStyle(fontSize: 14),
          ),
          items: UserTypes
              .map((item) => DropdownMenuItem<String>(
            value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
              .toList(),
          validator: (value) {
            if (value == null) {
              return 'Please select what will you be using this application as';
            }
            return null;
          },
          onChanged: (value) {
            selectedValue = value.toString();
            if(selectedValue=="Local Tour Guides"){
              setState((){
                LocalTourGuide=true;
              });
            }else if(selectedValue=="Tourists"){
              setState((){
                LocalTourGuide=false;
              });
            }
            print("value of local tour guide: "+LocalTourGuide.toString());
          },
          onSaved: (value) {
            // selectedValue = value.toString();
            // if(selectedValue=="Local Tour Guides"){
            //   LocalTourGuide=true;
            // }else if(selectedValue=="Tourists"){
            //   LocalTourGuide=false;
            // }
          },
          buttonStyleData: const ButtonStyleData(
            height: 60,
            padding: EdgeInsets.only(left: 20, right: 10),
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.black45,
            ),
            iconSize: 30,
          ),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      );

  Widget UserSigninOrLogIn()=>
      Visibility(
        visible: true,//!LocalTourGuide,////////////////////////ni set ke true je supaya senang ltg nak sign up sendiri
        child: InkWell(
          onTap: () {
            setState(() {
              newUser=!newUser;
            });
          },
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: InkWell(
                child: RichText(
                  text: TextSpan(
                      text:  newUser?"Do you have an account ? ":"New User ?",
                      style: TextStyle(color: Colors.grey[500], fontSize: 14,fontWeight: FontWeight.w500),
                      children: [
                        TextSpan(
                          text:newUser?"Sign in":" Create an account",
                          style: TextStyle(color: Constants.greenAirbnb,fontWeight: FontWeight.w600, fontSize: 14),)
                      ]),
                ),
              ),
            ),
          ),
        ),
      );
}
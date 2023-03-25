// import 'package:flutter/material.dart';
// import 'package:map_test/Constants/Constants.dart';
// import 'package:im_stepper/stepper.dart';
// //import 'package:flutter_map/flutter_map.dart';
// //import 'package:latlong2/latlong.dart';
// import 'package:csc_picker/csc_picker.dart';
//
// import 'package:map_test/Services/user_info.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
//
// import 'package:map_test/Services/authententication.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import 'package:map_test/Routes/HomePage.dart';
// class Registration extends StatefulWidget {
//   const Registration({Key? key}) : super(key: key);
//
//   @override
//   State<Registration> createState() => _RegistrationState();
// }
//
// class _RegistrationState extends State<Registration> {
//   // THE FOLLOWING TWO VARIABLES ARE REQUIRED TO CONTROL THE STEPPER.
//   int activeStep = 0; // Initial step set to 5.
//   int upperBound = 2; // upperBound MUST BE total number of icons minus 1.
//   //////////////////////////////////////////////////////////////////
//   TextEditingController nameController = TextEditingController();
//   TextEditingController ageController = TextEditingController();
//   TextEditingController biodataController = TextEditingController();
//   /////////////////////////////////////////////////////////////////
//   String? countryValue="";
//   String? stateValue="";
//   String? cityValue="";
//   ////////////////////////////////////////////////////////////////
//   double screenHeight = 0;
//   double screenWidth = 0;
//   Color primary = const Color(0xffeef444c);
//   String profilePicLink = "";
//   int counter=0;
//   ////////////////////////////////////////////////////////////////
//   AuthService customAuth = new AuthService();
//   UserInfos userInfos = new UserInfos();
//   String uid = FirebaseAuth.instance.currentUser!.uid;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             IconStepper(
//               icons: [
//                 Icon(Icons.note_alt_rounded),
//                 Icon(Icons.map_outlined),
//                 Icon(Icons.camera),
//               ],
//
//               // activeStep property set to activeStep variable defined above.
//               activeStep: activeStep,
//
//               // This ensures step-tapping updates the activeStep.
//               onStepReached: (index) {
//                 setState(() {
//                   activeStep = index;
//                 });
//               },
//             ),
//             header(),
//             Expanded(
//                 child: Center(
//                   child: Container(
//                     child: whatWidget(),
//                   ),
//                 ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 previousButton(),
//                 nextButton(),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget nextButton() {
//     return Container(
//         width: 150,
//         height:80,
//         child: ElevatedButton(
//           onPressed: () async{
//             // Increment activeStep, when the next button is tapped. However, check for upper bound.
//             if (activeStep < upperBound) {
//               setState(() {
//                 activeStep++;
//               });
//             }else if(activeStep==2){
//               dynamic result = await userInfos.addNameAndAgeAndBiodataAndSex(nameController.text,ageController.text,biodataController.text,"This shouldnt be here");
//               bool result1 = await userInfos.addCountryStateCity(countryValue,stateValue,cityValue);
//               if(result==true&&result1==true){
//                 Navigator.pushReplacement(
//                   context, MaterialPageRoute(
//                     builder: (context) => HomePage()
//                 ),
//                 );
//               }else{
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text("make sure you fill in the correct details in each section")),
//                 );
//               }
//             }
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Constants.greenAirbnb,
//           ),
//           child: Text(activeStep==2?'Submit Information':'Next',textAlign:TextAlign.center,),
//         )
//     );
//   }
//
//   /// Returns the previous button.
//   Widget previousButton() {
//     return Container(
//         width: 150,
//         height:80,
//         child:ElevatedButton(
//           onPressed: () {
//             // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
//             if (activeStep > 0) {
//               setState(() {
//                 activeStep--;
//               });
//             }
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Constants.greenAirbnb,
//           ),
//           child: Text('Prev'),
//         )
//     );
//   }
//
//   /// Returns the header wrapping the header text.
//   Widget header() {
//     return Container(
//       height: 60,
//       decoration: BoxDecoration(
//         color: Constants.greenAirbnb,
//         borderRadius: BorderRadius.circular(5),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               textAlign:TextAlign.center,
//               headerText(),
//               style: TextStyle(
//                 fontWeight: FontWeight.w900,
//                 color: Colors.white,
//                 fontSize: 25,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Returns the header text based on the activeStep.
//   String headerText() {
//     switch (activeStep) {
//       case 0:
//         return 'Self Introduction';
//
//       case 1:
//         return 'Choose Your Location';
//
//       case 2:
//         return 'Profile Picture';
//
//       default:
//         return 'This should not be here';
//     }
//   }
//
//   BoxDecoration customDecoration ()//method returning a boxDecoration
//   {
//     return BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(8),
//       boxShadow: [
//         BoxShadow(
//           offset: Offset(0,2),
//           color: (Colors.grey[300])!,
//           blurRadius: 5,
//         )],
//     );
//   }
//
//   void pickUploadProfilePic() async {
//     final image = await ImagePicker().pickImage(
//       source: ImageSource.gallery,
//       maxHeight: 512,
//       maxWidth: 512,
//       imageQuality: 90,
//     );
//
//     String userUid = customAuth.getUid().toString();
//
//     Reference ref = FirebaseStorage.instance
//         .ref("local/$uid").child("profilepic.jpg");
//
//     await ref.putFile(File(image!.path));
//
//     ref.getDownloadURL().then((value) async {
//       setState(() {
//         profilePicLink = value;
//       });
//       print(value.toString());
//       DocumentReference documentReference = FirebaseFirestore.instance.collection('Users').doc(uid);
//       FirebaseFirestore.instance.runTransaction((
//           transaction) async { //run trasnactions is when u want to ubah documentSSSSS (banyak document sekali gus) so data will not be ubah by other people while requesting, gitu
//         //we read dulu the documetns from database to make sure we are working with the most uptodate data (beza dengan batched)
//         DocumentSnapshot snapshot = await transaction.get(documentReference);
//         documentReference.update({"PPUrl": value.toString()});
//       });
//     });
//
//
//   }
//
//   Widget whatWidget(){
//     if(activeStep==0){////////////////////////////////////////////////////////////////////////////////////
//       return Container(
//         padding: EdgeInsets.all(13),
//         child: Column(
//           children:[
//             SizedBox(height: 25,),
//             Container(
//               margin: EdgeInsets.only(bottom: 20),
//               decoration: customDecoration(),
//               child: TextField(
//                 controller: nameController,
//                 decoration: InputDecoration(
//                     hintText: "Your Full Name",
//                     border: InputBorder.none,
//                     hintStyle: TextStyle(color: Colors.grey),
//                     prefixIcon: Icon(Icons.person_outline,color: Constants.greenAirbnb,)
//                 ),
//               ),
//             ),
//             Container(
//               margin: EdgeInsets.only(bottom: 20),
//               decoration:  customDecoration(),
//               child: TextField(
//                 controller: ageController,
//                 decoration: InputDecoration(
//                   hintText: "Your age",
//                   border: InputBorder.none,
//                   hintStyle: TextStyle(color: Colors.grey),
//                   prefixIcon: Icon(Icons.date_range_outlined,color: Constants.greenAirbnb,),
//                 ),
//               ),
//             ),
//             Container(
//               height: 80,
//               margin: EdgeInsets.only(bottom: 20),
//               decoration: customDecoration(),
//               child: TextField(
//                 controller: biodataController,
//                 decoration: InputDecoration(
//                   hintText: "Give a good impression about yourself to \n the people who will look at your profile",
//                   border: InputBorder.none,
//                   hintStyle: TextStyle(color: Colors.grey),
//                   prefixIcon: Icon(Icons.sticky_note_2_outlined,color: Constants.greenAirbnb,),
//                 ),
//                 minLines: 1,
//                 maxLines: 100,
//               ),
//             ),
//
//           ]
//         ),
//       );
//     }else if(activeStep==1){///////////////////////////////////////////////////////////////
//       return Container(
//           padding: EdgeInsets.symmetric(horizontal: 20),
//           height: 600,
//           child:
//           Column(
//             children: [
//               Container(
//                 child:CSCPicker(
//                   onCountryChanged: (value) {
//                     setState(() {
//                       countryValue = value;
//                     });
//                   },
//                   onStateChanged:(value) {
//                     setState(() {
//                       stateValue = value;
//                     });
//                   },
//                   onCityChanged:(value) {
//                     setState(() {
//                       cityValue = value;
//                     });
//                   },
//                 ),
//               ),
//               SizedBox(height: 20),
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(15.0),
//                   color: Colors.blue,
//                 ),
//               ),
//               SizedBox(height: 12),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Constants.greenAirbnb,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                       child: Text(
//                         "Country: $countryValue\n\nState: $stateValue\n\nCity: $cityValue",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                         ),
//                       ),
//               )
//               ),
//             ],
//           )
//       );
//       /*return Container(
//         child: FlutterMap(
//           options: MapOptions(
//             center: LatLng(51.509364, -0.128928),
//             zoom: 15.2,
//           ),
//           nonRotatedChildren: [
//             //AttributionWidget.defaultWidget(
//             //source: 'OpenStreetMap contributors',
//             //onSourceTapped: null,
//             //),
//           ],
//           children:[
//             TileLayer(
//               urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//               userAgentPackageName: 'com.example.app',
//             ),
//           ],
//         ),
//       );*/
//     }else{/////////////////////////////////////////////////////////////////
//       return Container(
//         child: InkWell(
//           onTap:() async{
//             pickUploadProfilePic();
//             //UserInfos().createSubCollectionContacts();
//             //UserInfos().createSubCollectionPlaceToGo();
//           },
//           child: Container(
//             margin: const EdgeInsets.only(top: 80, bottom: 24),
//             child: CircleAvatar(
//               radius: 100,
//               backgroundColor: Colors.white,
//               child:Center(
//                 child: profilePicLink == "" ?
//                 Column(
//                   children: <Widget>[
//                     Container(
//                       margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
//                       child: Center(
//                         child: Icon(Icons.add_a_photo, color: Colors.green, size: 80,),
//                       ),
//                     ),
//                     SizedBox(height:2),
//                     Container(
//                       child: Text(
//                         "Upload your main picture here",
//                         style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ],
//                 ) : ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: CircleAvatar(
//                     radius: 100.0,
//                     backgroundImage:
//                     NetworkImage(profilePicLink),
//                     backgroundColor: Colors.transparent,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//   }
// }
//

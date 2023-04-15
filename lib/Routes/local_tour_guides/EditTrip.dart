import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textfield_tags/textfield_tags.dart';

class EditTrip extends StatefulWidget {

  late QueryDocumentSnapshot document;
  EditTrip({Key? key,required this.document}) : super(key: key);

  @override
  State<EditTrip> createState() => _EditTripState();
}

class _EditTripState extends State<EditTrip> {


  File? image;
  final List<File?> _imageList = List<File?>.filled(4, null);
  // StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? stream;
  //
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //
  //   stream = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection("Trips").doc(widget.document.id).snapshots()
  //   .listen((DocumentSnapshot<Map<String, dynamic>> snapshot) {
  //     if (snapshot.exists) {
  //       var name = snapshot.data()!['name'];
  //       String nameFB = snapshot.data()!['name'] ?? '';
  //       String aboutFB = snapshot.data()!['description'] ?? '';
  //       List<dynamic> picUrisFB = snapshot.data()!["picUri"];
  //       List<String> picUrisCastedFB = picUrisFB.cast<String>().toList();//The cast() method converts the List<dynamic> to a List<String> by applying a type cast to each element of the list.
  //       List<dynamic> tagsFB = snapshot.data()!["tags"];
  //       List<String> tagsCastedFB = tagsFB.cast<String>().toList();
  //       String docId = widget.document.id;
  //
  //       File? image;
  //       final List<File?> _imageList = List<File?>.filled(4, null);
  //       TextEditingController _tripName = TextEditingController(text:nameFB);
  //       TextfieldTagsController _tags = TextfieldTagsController();
  //       late List<String?> _createdTags = [];
  //       _createdTags.addAll(tagsCastedFB);
  //       TextEditingController descriptionController = TextEditingController(text:aboutFB);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection("Trips").doc(widget.document.id).snapshots(),
          builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData) {
              return Text('No trips found.');
            }

            if(snapshot.hasData){
              final tripData = snapshot.data!.data();
              String nameFB = tripData!['name'] ?? '';
              String aboutFB = tripData['description'] ?? '';
              List<dynamic> picUrisFB = tripData["picUri"];
              List<String> picUrisCastedFB = picUrisFB.cast<String>().toList();//The cast() method converts the List<dynamic> to a List<String> by applying a type cast to each element of the list.
              List<dynamic> tagsFB = tripData["tags"];
              List<String> tagsCastedFB = tagsFB.cast<String>().toList();
              String docId = widget.document.id;


              TextEditingController _tripName = TextEditingController(text:nameFB);
              TextfieldTagsController _tags = TextfieldTagsController();
              late List<String?> _createdTags = [];
              _createdTags.addAll(tagsCastedFB);
              TextEditingController descriptionController = TextEditingController(text:aboutFB);


              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children:[
                      Row(
                        children: [
                          Container(
                            child: IconButton(
                              icon: Icon(Icons.arrow_back,color: Colors.black87,size: 20,),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child:Text("Edit details of your trip",
                                style:TextStyle(
                                  fontSize:18,
                                  fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                          child:Column(
                              children:[
                                SizedBox(height:25),
                                Container(
                                  margin:EdgeInsets.fromLTRB(5,0,0,0),
                                  padding:EdgeInsets.fromLTRB(10,0,0,0),
                                  alignment: Alignment.centerLeft,
                                  child:Text("Add a name to your trip",
                                    style:TextStyle(
                                      fontSize:15,
                                      fontWeight: FontWeight.w500),)
                                ),
                                Container(
                                    margin:EdgeInsets.all(5),
                                    padding:EdgeInsets.all(10),
                                    child: TextFormField(
                                      controller :_tripName,
                                      decoration: InputDecoration(
                                        hintText: "Give an interesting name to your trip",
                                      ),
                                    )
                                ),
                                SizedBox(height:25),
                                Container(
                                margin:EdgeInsets.fromLTRB(5,0,0,0),
                                padding:EdgeInsets.fromLTRB(10,0,0,0),
                                alignment: Alignment.centerLeft,
                                  child:Text("Add pictures of what your trip will be like",
                                    style:TextStyle(
                                      fontSize:15,
                                      fontWeight: FontWeight.w500),
                                  )
                                ),
                                Container(
                                  height:MediaQuery.of(context).size.height *0.3,
                                  width:MediaQuery.of(context).size.width,
                                  child: PageView.builder(
                                    itemCount:4,
                                    controller: PageController(viewportFraction: 0.8),
                                    itemBuilder: (BuildContext context, int index) {
                                      return _imageList[index]==null && index < picUrisCastedFB.length?
                                      InkWell( //no pic
                                        onTap:()async{
                                          await pickImage2(index);
                                          print("_imageList.toString():"+_imageList.toString());
                                        },
                                        child: Container(
                                            height:MediaQuery.of(context).size.height *0.3,
                                            width:MediaQuery.of(context).size.width,
                                            margin:EdgeInsets.all(5),
                                            padding:EdgeInsets.all(20),
                                            child:  Container(
                                              decoration: BoxDecoration(
                                                image:DecorationImage(
                                                  image: NetworkImage(
                                                    picUrisCastedFB[index],
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                                color: Color(0xFF273754).withOpacity(0.5),
                                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                              ),
                                              child: Center(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white.withOpacity(0.5),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 30,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                        ),
                                      ):
                                      InkWell(
                                        onTap:(){
                                          pickImage2(index);
                                        },
                                        child:  Container(
                                            height:MediaQuery.of(context).size.height *0.3,
                                            width:MediaQuery.of(context).size.width,
                                            margin:EdgeInsets.all(5),
                                            padding:EdgeInsets.all(20),
                                            child:  Container(
                                              decoration: BoxDecoration(
                                                color: Color(0xFF273754).withOpacity(0.5),
                                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                              ),
                                              child: ClipRRect(
                                                //opacity:0.5,
                                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                child: _imageList[index] == null?
                                                Icon(
                                                  Icons.add,
                                                  size: 30,
                                                  color: Colors.white,
                                                ):
                                                Image.file(
                                                  File(
                                                    _imageList[index]!.path,
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height:25),
                                Container(
                                  margin:EdgeInsets.fromLTRB(5,0,0,0),
                                  padding:EdgeInsets.fromLTRB(10,0,0,0),
                                  alignment: Alignment.centerLeft,
                                  child:Text("Add relevant tags to your trips",
                                    style:TextStyle(
                                      fontSize:15,
                                      fontWeight: FontWeight.w500),
                                  )
                                ),
                                TextFieldTags(
                                  textfieldTagsController: _tags,
                                  textSeparators: const [' ', ','],
                                  letterCase: LetterCase.normal,
                                  initialTags: tagsCastedFB,
                                  inputfieldBuilder: (context, tec, fn, error, onChanged, onSubmitted) {
                                    return ((context, sc, tags, onTagDelete) {
                                      _createdTags =tags;
                                      return Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: TextField(
                                          controller: tec,
                                          focusNode: fn,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            border: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromARGB(255, 74, 137, 92),
                                                width: 3.0,
                                              ),
                                            ),
                                            focusedBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromARGB(255, 74, 137, 92),
                                                width: 3.0,
                                              ),
                                            ),
                                            helperText: 'Enter tags...',
                                            helperStyle: const TextStyle(
                                              color: Color.fromARGB(255, 74, 137, 92),
                                            ),
                                            hintText: _tags.hasTags ? '' : "Enter relevant tags...",
                                            errorText: error,
                                            prefixIconConstraints:
                                            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.74),
                                            prefixIcon: tags.isNotEmpty
                                                ? SingleChildScrollView(
                                              controller: sc,
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                  children: tags.map((String tag) {
                                                    return Container(
                                                      decoration: const BoxDecoration(
                                                        borderRadius: BorderRadius.all(
                                                          Radius.circular(20.0),
                                                        ),
                                                        color: Color.fromARGB(255, 74, 137, 92),
                                                      ),
                                                      margin: const EdgeInsets.symmetric(
                                                          horizontal: 5.0),
                                                      padding: const EdgeInsets.symmetric(
                                                          horizontal: 10.0, vertical: 5.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          InkWell(
                                                            child: Text(
                                                              '#$tag',
                                                              style: const TextStyle(
                                                                  color: Colors.white),
                                                            ),
                                                            onTap: () {
                                                              print(" ${_createdTags.toList().toString()}");
                                                            },
                                                          ),
                                                          const SizedBox(width: 4.0),
                                                          InkWell(
                                                            child: const Icon(
                                                              Icons.cancel,
                                                              size: 14.0,
                                                              color: Color.fromARGB(
                                                                  255, 233, 233, 233),
                                                            ),
                                                            onTap: () {
                                                              onTagDelete(tag);
                                                              _createdTags.remove(tag);
                                                            },
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  }).toList()),
                                            )
                                                : null,
                                          ),
                                          onChanged: onChanged,
                                          onSubmitted: onSubmitted,
                                        ),
                                      );
                                    });
                                  },
                                ),//the initirial value to show, the controller, the initial list of tags to submit
                                SizedBox(height:25),
                                Container(
                                  margin:EdgeInsets.fromLTRB(5,0,0,0),
                                  padding:EdgeInsets.fromLTRB(10,0,0,0),
                                  alignment: Alignment.centerLeft,
                                  child:Text("Write a description of your trip",
                                    style:TextStyle(
                                      fontSize:15,
                                      fontWeight: FontWeight.w500),
                                    )
                                  ),
                                Container(
                                  margin:EdgeInsets.all(5),
                                  padding:EdgeInsets.all(10),
                                  child: TextField(
                                    maxLines: null,
                                    controller:descriptionController,
                                    decoration: InputDecoration(
                                      hintText:"Enter a description of your trip",
                                      hintStyle: TextStyle(color:Colors.grey),
                                    ),
                                  ),
                                ),
                                //addPics(),
                                SizedBox(height:25),
                                Container(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF00AA6D), // Use the TripAdvisor green color
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0), // Rounded corners
                                    ),
                                  ),
                                    onPressed: () async{
                                      bool result = await _submitForm(docId,picUrisCastedFB,_tripName,_createdTags,descriptionController);
                                      if(result == false){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Please enter all fields')),
                                        );
                                      }else{
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text(
                                      'Submit my trip!',
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                    ),
                                  )
                                )
                              ]
                      )
                      ),
                    ]
                  )
                )
              );
            }
            return CircularProgressIndicator();
          }
        // child: SafeArea(
        //     child: SingleChildScrollView(
        //       child: Column(
        //         children:[
        //           Row(
        //             children: [
        //               Container(
        //                 child: IconButton(
        //                   icon: Icon(Icons.arrow_back,color: Colors.black87,size: 20,),
        //                   onPressed: (){
        //                     Navigator.pop(context);
        //                   },
        //                 ),
        //               ),
        //               Expanded(
        //                 child: Container(
        //                   alignment: Alignment.center,
        //                   child:Text("Edit details of your trip",
        //                     style:TextStyle(
        //                         fontSize:18,
        //                         fontWeight: FontWeight.w700),
        //                   ),
        //                 ),
        //               ),
        //
        //             ],
        //           ),
        //           StreamBuilder(
        //               stream: FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection("Trips").doc(widget.document.id).snapshots(),
        //               builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot){
        //
        //                 if (snapshot.connectionState == ConnectionState.waiting) {
        //                   return Center(child: CircularProgressIndicator());
        //                 }
        //
        //                 if (!snapshot.hasData) {
        //                   return Text('No trips found.');
        //                 }
        //
        //                 if(snapshot.hasData){
        //                   final tripData = snapshot.data!.data();
        //                   String nameFB = tripData!['name'] ?? '';
        //                   String aboutFB = tripData['description'] ?? '';
        //                   List<dynamic> picUrisFB = tripData["picUri"];
        //                   List<String> picUrisCastedFB = picUrisFB.cast<String>().toList();//The cast() method converts the List<dynamic> to a List<String> by applying a type cast to each element of the list.
        //                   List<dynamic> tagsFB = tripData["tags"];
        //                   List<String> tagsCastedFB = tagsFB.cast<String>().toList();
        //                   String docId = widget.document.id;
        //
        //                   File? image;
        //                   final List<File?> _imageList = List<File?>.filled(4, null);
        //                   TextEditingController _tripName = TextEditingController(text:nameFB);
        //                   TextfieldTagsController _tags = TextfieldTagsController();
        //                   late List<String?> _createdTags = [];
        //                   _createdTags.addAll(tagsCastedFB);
        //                   TextEditingController descriptionController = TextEditingController(text:aboutFB);
        //
        //                   return
        //                 }
        //                 return CircularProgressIndicator();
        //               }
        //           ),
        //         ]
        //       ),
        //     ),
        // ),
      ),
    );
  }

  // Widget TripName(TextEditingController tripName)=>
  //     Container(
  //         margin:EdgeInsets.all(5),
  //         padding:EdgeInsets.all(10),
  //         child: TextFormField(
  //           controller :tripName,
  //           decoration: InputDecoration(
  //             hintText: "Give an interesting name to your trip",
  //           ),
  //         )
  //     );

  // Widget picSubmit(List<String> picUrisCastedFB)=>
  //     Container(
  //       height:MediaQuery.of(context).size.height *0.3,
  //       width:MediaQuery.of(context).size.width,
  //       child: PageView.builder(
  //         itemCount:4,
  //         controller: PageController(viewportFraction: 0.8),
  //         itemBuilder: (BuildContext context, int index) {
  //           return _imageList[index]==null && index < picUrisCastedFB.length?
  //           InkWell( //no pic
  //             onTap:()async{
  //               await pickImage2(index);
  //               print("_imageList.toString():"+_imageList.toString());
  //             },
  //             child: Container(
  //                 height:MediaQuery.of(context).size.height *0.3,
  //                 width:MediaQuery.of(context).size.width,
  //                 margin:EdgeInsets.all(5),
  //                 padding:EdgeInsets.all(20),
  //                 child:  Container(
  //                   decoration: BoxDecoration(
  //                     image:DecorationImage(
  //                       image: NetworkImage(
  //                         picUrisCastedFB[index],
  //                       ),
  //                       fit: BoxFit.cover,
  //                     ),
  //                     color: Color(0xFF273754).withOpacity(0.5),
  //                     borderRadius: const BorderRadius.all(Radius.circular(10)),
  //                   ),
  //                   child: Center(
  //                     child: Container(
  //                       decoration: BoxDecoration(
  //                         color: Colors.white.withOpacity(0.5),
  //                         shape: BoxShape.circle,
  //                       ),
  //                       child: Icon(
  //                         Icons.add,
  //                         size: 30,
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                   ),
  //                 )
  //             ),
  //           ):
  //           InkWell(
  //             onTap:(){
  //               pickImage2(index);
  //             },
  //             child:  Container(
  //                 height:MediaQuery.of(context).size.height *0.3,
  //                 width:MediaQuery.of(context).size.width,
  //                 margin:EdgeInsets.all(5),
  //                 padding:EdgeInsets.all(20),
  //                 child:  Container(
  //                   decoration: BoxDecoration(
  //                     color: Color(0xFF273754).withOpacity(0.5),
  //                     borderRadius: const BorderRadius.all(Radius.circular(10)),
  //                   ),
  //                   child: ClipRRect(
  //                     //opacity:0.5,
  //                     borderRadius: const BorderRadius.all(Radius.circular(10)),
  //                     child: _imageList[index] == null?
  //                     Icon(
  //                       Icons.add,
  //                       size: 30,
  //                       color: Colors.white,
  //                     ):
  //                     Image.file(
  //                       File(
  //                         _imageList[index]!.path,
  //                       ),
  //                       fit: BoxFit.cover,
  //                     ),
  //                   ),
  //                 )
  //             ),
  //           );
  //         },
  //       ),
  //     );

  Future<void> pickImage2(int index) async {
    try{
      final imageFromGallery = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 512,
        maxWidth: 512,
        imageQuality: 90,
      );

      final imageTemporary = File(imageFromGallery!.path);
      setState(() {
        print("Temporary image:"+imageTemporary.toString());
        this.image =imageTemporary;
        print("image File:"+image.toString());
        _imageList[index] = image;
        print("Image at index $index = to ${_imageList[index].toString}");
      });
    }on PlatformException catch (e){
      print(e.toString());
    }
  }

  // Widget Tags(List<String> tagsFB,TextfieldTagsController _tag,List<String?> _createdTags)=>
  //     TextFieldTags(
  //       textfieldTagsController: _tag,
  //       textSeparators: const [' ', ','],
  //       letterCase: LetterCase.normal,
  //       initialTags: tagsFB,
  //       inputfieldBuilder: (context, tec, fn, error, onChanged, onSubmitted) {
  //         return ((context, sc, tags, onTagDelete) {
  //           _createdTags =tags;
  //           return Padding(
  //             padding: const EdgeInsets.all(10.0),
  //             child: TextField(
  //               controller: tec,
  //               focusNode: fn,
  //               decoration: InputDecoration(
  //                 isDense: true,
  //                 border: const OutlineInputBorder(
  //                   borderSide: BorderSide(
  //                     color: Color.fromARGB(255, 74, 137, 92),
  //                     width: 3.0,
  //                   ),
  //                 ),
  //                 focusedBorder: const OutlineInputBorder(
  //                   borderSide: BorderSide(
  //                     color: Color.fromARGB(255, 74, 137, 92),
  //                     width: 3.0,
  //                   ),
  //                 ),
  //                 helperText: 'Enter tags...',
  //                 helperStyle: const TextStyle(
  //                   color: Color.fromARGB(255, 74, 137, 92),
  //                 ),
  //                 hintText: _tag.hasTags ? '' : "Enter relevant tags...",
  //                 errorText: error,
  //                 prefixIconConstraints:
  //                 BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.74),
  //                 prefixIcon: tags.isNotEmpty
  //                     ? SingleChildScrollView(
  //                   controller: sc,
  //                   scrollDirection: Axis.horizontal,
  //                       child: Row(
  //                           children: tags.map((String tag) {
  //                             return Container(
  //                               decoration: const BoxDecoration(
  //                                 borderRadius: BorderRadius.all(
  //                                   Radius.circular(20.0),
  //                                 ),
  //                                 color: Color.fromARGB(255, 74, 137, 92),
  //                               ),
  //                               margin: const EdgeInsets.symmetric(
  //                                   horizontal: 5.0),
  //                               padding: const EdgeInsets.symmetric(
  //                                   horizontal: 10.0, vertical: 5.0),
  //                               child: Row(
  //                                 mainAxisAlignment:
  //                                 MainAxisAlignment.spaceBetween,
  //                                 children: [
  //                                   InkWell(
  //                                     child: Text(
  //                                       '#$tag',
  //                                       style: const TextStyle(
  //                                           color: Colors.white),
  //                                     ),
  //                                     onTap: () {
  //                                       print(" ${_createdTags.toList().toString()}");
  //                                     },
  //                                   ),
  //                                   const SizedBox(width: 4.0),
  //                                   InkWell(
  //                                     child: const Icon(
  //                                       Icons.cancel,
  //                                       size: 14.0,
  //                                       color: Color.fromARGB(
  //                                           255, 233, 233, 233),
  //                                     ),
  //                                     onTap: () {
  //                                       onTagDelete(tag);
  //                                       _createdTags.remove(tag);
  //                                     },
  //                                   )
  //                                 ],
  //                               ),
  //                             );
  //                           }).toList()),
  //                 )
  //                     : null,
  //               ),
  //               onChanged: onChanged,
  //               onSubmitted: onSubmitted,
  //             ),
  //           );
  //         });
  //       },
  //     );

  // Widget description(TextEditingController descriptionController)=>
  //     Container(
  //       margin:EdgeInsets.all(5),
  //       padding:EdgeInsets.all(10),
  //       child: TextField(
  //         maxLines: null,
  //         controller:descriptionController,
  //         decoration: InputDecoration(
  //           hintText:"Enter a description of your trip",
  //           hintStyle: TextStyle(color:Colors.grey),
  //         ),
  //       ),
  //     );

  Future<bool> _submitForm(String docId,List<String> _picUri,TextEditingController _tripName,List<String?> _createdTags,TextEditingController descriptionController) async {
    try{
      final userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference documentReference1 = FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Trips')
          .doc(docId);

        await submitPictures(docId,_picUri);
        FirebaseFirestore.instance.runTransaction((transaction) async { //run trasnactions is when u want to ubah documentSSSSS (banyak document sekali gus) so data will not be ubah by other people while requesting, gitu
          //we read dulu the documetns from database to make sure we are working with the most uptodate data (beza dengan batched)
          DocumentSnapshot snapshot = await transaction.get(documentReference1);
          print("PICURI DURING SUBMISSION TO FIREBASE: "+_picUri.toString());
          documentReference1.update({"uid": userId,"picUri": _picUri ,"name": _tripName.text,"tags":_createdTags, "description": descriptionController.text});
          print("success upload trip");

        });
        return true;
    }catch (e){
      print(e.toString());
      return false;
    }

  }

  Future<void> submitPictures(String id,List<String> _picUri) async{
    try{
      // Replace with code to get current user ID
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final tripFolderRef = FirebaseStorage.instance.ref('/local/$userId/trips/$id');

      for (var i = 0; i < _imageList.length; i++) {
        if(_imageList[i]!=null){
          final file = File(_imageList[i]!.path);
          final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
          final filename = 'image_$timestamp.jpg';
          final uploadTask = tripFolderRef.child(filename).putFile(file);

          final snapshot = await uploadTask.whenComplete(() {});
          if (snapshot.state == TaskState.success) {
            final downloadUrl = await snapshot.ref.getDownloadURL();
            _picUri[i]=downloadUrl;////////////////////////////////////////////////PROBLEM KAT SINI
            print("DOWNLOAD URL OF THE PICTURES: "+ _picUri.toString());
            print('Image $i uploaded successfully. Download URL: $downloadUrl');
          } else {
            print('Image $i upload failed.');
          }
        }

      }
    }catch (e){
      print(e.toString());
    }
  }
}

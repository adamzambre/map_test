import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textfield_tags/textfield_tags.dart';

class TripCreator extends StatefulWidget {
  const TripCreator({Key? key}) : super(key: key);

  @override
  State<TripCreator> createState() => _TripCreatorState();
}

class _TripCreatorState extends State<TripCreator> {

  File? image;
  final List<File?> _imageList = List<File?>.filled(4, null);
  TextEditingController _tripName = TextEditingController();
  TextfieldTagsController _tags = TextfieldTagsController();
  late List<String?> _createdTags = [];
  late List<String?> _PicUri = [];
  TextEditingController descriptionController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child:Column(
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
                        child:Text("Create your own trip with details below",
                          style:TextStyle(
                              fontSize:18,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),

                  ],
                ),
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
                TripName(),
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
                picSubmit(),
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
                Tags(),
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
                description(),
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
                      bool result = await _submitForm();
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
        ),
      )
    );
  }

  Widget TripName()=>
      Container(
          margin:EdgeInsets.all(5),
          padding:EdgeInsets.all(10),
          child: TextFormField(
            controller :_tripName,
            decoration: InputDecoration(
              hintText: "Give an interesting name to your trip",
            ),
          )
      );

  Widget picSubmit()=>
  Container(
      height:MediaQuery.of(context).size.height *0.3,
      width:MediaQuery.of(context).size.width,
      child: PageView.builder(
        itemCount:4,
            controller: PageController(viewportFraction: 0.8),
            itemBuilder: (BuildContext context, int index) {
            return _imageList[index] == null ?
              InkWell( // no pic
                onTap:(){
                  pickImage2(index);
                  print("_imageList.toString():"+_imageList.toString());
                },
                child: Container(
                    height:MediaQuery.of(context).size.height *0.3,
                    width:MediaQuery.of(context).size.width,
                    margin:EdgeInsets.all(5),
                    padding:EdgeInsets.all(20),
                    child:  Container(
                      decoration: BoxDecoration(
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
            InkWell(//editable pic since dah pilih
              onTap:(){
                pickImage2(index);
              },
              child: Container(
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
                      child: Image.file(
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
  );

  void pickImage2(int index) async {
    try{
      final imageFromGallery = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 512,
        maxWidth: 512,
        imageQuality: 90,
      );

      final imageTemporary = File(imageFromGallery!.path);
      setState(() {
        this.image =imageTemporary;
        _imageList[index] = image;
        print("Image at index $index = to ${_imageList[index].toString}");
      });
    }on PlatformException catch (e){
      print(e.toString());
    }
  }

  Widget Tags()=>
      TextFieldTags(
        textfieldTagsController: _tags,
        textSeparators: const [' ', ','],
        letterCase: LetterCase.normal,
        inputfieldBuilder:
            (context, tec, fn, error, onChanged, onSubmitted) {
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
      );

  Widget description()=>
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
      );

  Future<bool> _submitForm() async {
    try{
      String date = DateTime.now().toString();

      final userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference documentReference1 = FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Trips')
          .doc(date);
      if(_tripName.text == null || _createdTags ==null || descriptionController.text ==null){
        return false;
      }else{
        await submitPictures(date);
        FirebaseFirestore.instance.runTransaction((transaction) async { //run trasnactions is when u want to ubah documentSSSSS (banyak document sekali gus) so data will not be ubah by other people while requesting, gitu
          //we read dulu the documetns from database to make sure we are working with the most uptodate data (beza dengan batched)
          DocumentSnapshot snapshot = await transaction.get(documentReference1);
          print("PICURI DURING SUBMISSION TO FIREBASE: "+_PicUri.toString());
          documentReference1.set({"uid": userId,"picUri": _PicUri ,"name": _tripName.text,"tags":_createdTags, "description": descriptionController.text,"timeStamp":date });
          print("success upload trip");

        });
        return true;
      }
    }catch (e){
      print(e.toString());
      return false;
    }

  }

  Future<void> submitPictures(String date) async{
    try{
       // Replace with code to get current user ID
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final tripFolderRef = FirebaseStorage.instance.ref('/local/$userId/trips/$date');

      for (var i = 0; i < _imageList.length; i++) {
        print("_IMAGELIST: "+_imageList.toString());
        final file = File(_imageList[i]!.path);
        final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        final filename = 'image_$timestamp.jpg';
        final uploadTask = tripFolderRef.child(filename).putFile(file);

        final snapshot = await uploadTask.whenComplete(() {});
        if (snapshot.state == TaskState.success) {
          final downloadUrl = await snapshot.ref.getDownloadURL();
          _PicUri.add(downloadUrl);////////////////////////////////////////////////PROBLEM KAT SINI
          print("DOWNLOAD URL OF THE PICTURES: "+ _PicUri.toString());
          print('Image $i uploaded successfully. Download URL: $downloadUrl');
        } else {
          print('Image $i upload failed.');
        }
      }
    }catch (e){
      print(e.toString());
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:map_test/Constants/Constants.dart';
import 'package:map_test/Routes/profileView.dart';
import 'package:map_test/Services/messaging service.dart';
import 'package:map_test/Routes/Messages.dart';

class Chat extends StatefulWidget {

  late QueryDocumentSnapshot document;
  Chat({Key? key, required this.document}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  TextEditingController _messageController = TextEditingController();
  ScrollController _scrollController=ScrollController();

  @override

  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // user has scrolled to the bottom, mark messages as read
      }
    });
    chatCollectionExistOrNot();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void chatCollectionExistOrNot()async{
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference chatDocumentRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('chat')
        .doc(widget.document.id);

    DocumentSnapshot chatSnapshot = await chatDocumentRef.get();
    if (chatSnapshot.exists) {
      // Call the lastMessageSeen function to update the lastMessageSeen field
      seen();
      lastMessageSeen();
    } else {
      print("Chat document does not exist");
    }
  }
  void seen() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference documentReference1 = FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('chat')
          .doc(widget.document.id);

      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference1);
        documentReference1.update({"seen": true});
        print("success");
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void lastMessageSeen() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      CollectionReference messagesCollection = FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('chat')
          .doc(widget.document.id)
          .collection('messages');

      QuerySnapshot querySnapshot = await messagesCollection
          .orderBy('timeStamp', descending: true) // Replace 'timestamp' with the actual field you want to sort by
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If there is at least one document in the collection
        DocumentSnapshot lastDocument = querySnapshot.docs.first;
        // Access the data from lastDocument and update the 'lastMessageSeen' field
        String content = lastDocument['content'];
        DocumentReference chatDocument = FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .collection('chat')
            .doc(widget.document.id);
        await chatDocument.update({'LastMessageSeen': content});
        print("success");
      } else {
        print("No documents found");
      };
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<String> getUserType() async{
    try{
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .get();
      if (docSnapshot.exists) {
        String userType = docSnapshot.get('userType'); // Access the 'userType' field from the document's snapshot
        return userType;
      } else {
        print('Document does not exist');
        return ''; // Return a default value or handle the case when the document does not exist
      }
    }catch(e){
      print(e.toString());
      return '';
    }
  }

  void sendMessage() async{
    try{
      String userType = await getUserType();

      if(userType=='tourist'){

      }
      if(userType=='local tour guide'){

      }if(userType=='admin'){

      }
    }catch(e){
      print(e.toString());
    }
  }

  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex:1,
                child: Container(
                  color: Constants.greenAirbnb,
                  child:Row(
                    children: [
                      Container(
                        child: IconButton(
                          icon: Icon(Icons.arrow_back,color: Colors.black87,size: 20,),
                          onPressed: (){
                              Navigator.pop(context);
                          },
                        ),
                      ),
                      Flexible(
                        child: Container(
                          child: InkWell(
                            onTap: (){
                              Navigator.push(
                                context, MaterialPageRoute(
                                builder: (context) => ProfileView(document: widget.document),
                              ),
                              );
                            },
                            child: Row(
                              children: [
                              Container(
                                padding:EdgeInsets.all(10),
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.white,
                                  backgroundImage: NetworkImage(widget.document.get("picUri")),
                                ),
                              ),
                              Flexible(
                                child:Container(
                                  alignment: Alignment.center,
                                  padding:EdgeInsets.all(10),
                                  child: Text(widget.document.get('name'),
                                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
                                    softWrap: true,
                                  ),
                                ),
                              ),

                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex:9,
                child:StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('chat').doc(widget.document.get('uid'))
                      .collection('messages').snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){

                      //print(snapshot.data!.docs.toString());
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        if (_scrollController.hasClients) {
                          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                        }
                      });
                      return Container(
                        child: ListView(
                          controller: _scrollController,
                          children: snapshot.data!.docs.map((document) {
                            return Container(
                              padding:EdgeInsets.all(10),
                              margin:EdgeInsets.all(10),
                              //alignment: document.get("from")==FirebaseAuth.instance.currentUser!.uid ? Alignment.topRight:Alignment.topLeft,
                              child:Column(
                               //mainAxisAlignment: document.get("from")==FirebaseAuth.instance.currentUser!.uid ? MainAxisAlignment.end : MainAxisAlignment.start,
                                children:[
                                  Align(
                                    alignment: document.get("from")==FirebaseAuth.instance.currentUser!.uid ? Alignment.centerRight:Alignment.centerLeft,
                                    child: Container(
                                      //alignment: document.get("from")==FirebaseAuth.instance.currentUser!.uid ? Alignment.topRight:Alignment.topLeft,
                                      padding:EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                        color: Colors.tealAccent,
                                      ),
                                      child: Text(document.get('content')
                                          ,style:TextStyle(fontSize: 15)),
                                    ),
                                  ),
                                  Align(
                                    alignment: document.get("from")==FirebaseAuth.instance.currentUser!.uid ? Alignment.centerRight:Alignment.centerLeft,
                                    child: Container(
                                      padding:document.get("from")==FirebaseAuth.instance.currentUser!.uid ? EdgeInsets.fromLTRB(0,0,10,0) : EdgeInsets.fromLTRB(10,0,0,0),
                                      child: Text(document.get('timeStamp').substring(0,16)
                                        ,style:TextStyle(fontSize: 10)
                                      )
                                    ),
                                  )

                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }
                ),
              ),
              Expanded(
                  flex:1,
                child: Container(
                    color: Constants.greenAirbnb,
                    child:Row(
                        children:[
                          Expanded(
                            flex:5,
                            child: Container(
                              child:TextFormField(
                                controller: _messageController,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(hintText: " write your messages"),
                                onChanged: (value){
                                  print(value);
                                },
                                minLines: 1,
                                maxLines:100,
                              ),
                            ),
                          ),
                          Expanded(
                            flex:1,
                            child: Container(
                                child:IconButton(
                                    onPressed:(){
                                      String date = DateTime.now().toString();
                                      String message = _messageController.text.replaceAll(RegExp(r'\s+'), ' ').trim(); // Remove leading/trailing whitespace
                                      if (message.isEmpty) {
                                        return; // Do not send empty message
                                      }else{
                                        messagingService().addMessageTourist(widget.document.get('uid'),_messageController.text,date);
                                        messagingService().addMessageLocal(widget.document.get('uid'),_messageController.text,date);
                                        _messageController.clear();
                                        print("message sents");
                                      }
                                    },
                                    icon: Icon(Icons.arrow_forward_outlined))
                            ),
                          )
                        ]
                    )
                )
              )
            ],
          ),
        )
      ),
    );
  }
}

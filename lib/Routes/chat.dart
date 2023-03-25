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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 25,),
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
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => Messages()),
                        // );
                          Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(
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
                        Container(
                          alignment: Alignment.center,
                          padding:EdgeInsets.all(10),
                          child: Text(widget.document.get('name'),
                            style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
                          ),
                        )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex:7,
            child:StreamBuilder(
              stream: FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('chat').doc(widget.document.get('uid'))
                  .collection('messages').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){

                  print(snapshot.data!.docs.toString());
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
                  return Container(
                    child: ListView(
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
                            decoration: InputDecoration(hintText: " write your message"),
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
                                  messagingService().addMessageTourist(widget.document.get('uid'),_messageController.text);
                                  messagingService().addMessageLocal(widget.document.get('uid'),_messageController.text);
                                  _messageController.clear();
                                  print("message sent");
                                },
                                icon: Icon(Icons.arrow_forward_outlined))
                        ),
                      )
                    ]
                )
            )
          )
        ],
      )
    );
  }
}

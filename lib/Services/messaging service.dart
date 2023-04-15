import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

import 'package:map_test/Services/authententication.dart';

class messagingService{

  Future<bool> addMessageTourist(String uidLocal,String content,String date) async{
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference documentReference1 = FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('chat')
          .doc(uidLocal);
      FirebaseFirestore.instance.runTransaction((transaction) async { //run trasnactions is when u want to ubah documentSSSSS (banyak document sekali gus) so data will not be ubah by other people while requesting, gitu
        //we read dulu the documetns from database to make sure we are working with the most uptodate data (beza dengan batched)
        DocumentSnapshot snapshot = await transaction.get(documentReference1);
        documentReference1.set({"LastMessage": "","LastMessageSeen": "","seen": true});
        print("success1");
      });

      DocumentReference documentReference2 = FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('chat')
          .doc(uidLocal)
          .collection('messages')
          .doc(date);
      FirebaseFirestore.instance.runTransaction((transaction) async { //run trasnactions is when u want to ubah documentSSSSS (banyak document sekali gus) so data will not be ubah by other people while requesting, gitu
        //we read dulu the documetns from database to make sure we are working with the most uptodate data (beza dengan batched)
        DocumentSnapshot snapshot = await transaction.get(documentReference2);
        documentReference2.set({"from": uid,"to": uidLocal, "content": content,"timeStamp":date});
        documentReference1.update({"LastMessage": content});
        print("success2");
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> addMessageLocal(String uidLocal,String content,String date) async{
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference documentReference1 = FirebaseFirestore.instance
          .collection('Users')
          .doc(uid-Local)
          .collection('chat')
          .doc(uid);

      FirebaseFirestore.instance.runTransaction((transaction) async { //run trasnactions is when u want to ubah documentSSSSS (banyak document sekali gus) so data will not be ubah by other people while requesting, gitu
        //we read dulu the documetns from database to make sure we are working with the most uptodate data (beza dengan batched)
        DocumentSnapshot snapshot = await transaction.get(documentReference1);
        documentReference1.set({"LastMessage": "","LastMessageSeen": "","seen": true});
        print("success");
      });

      DocumentReference documentReference2 = FirebaseFirestore.instance
          .collection('Users')
          .doc(uidLocal)
          .collection('chat')
          .doc(uid)
          .collection('messages')
          .doc(date);

      FirebaseFirestore.instance.runTransaction((transaction) async { //run trasnactions is when u want to ubah documentSSSSS (banyak document sekali gus) so data will not be ubah by other people while requesting, gitu
        //we read dulu the documetns from database to make sure we are working with the most uptodate data (beza dengan batched)
        DocumentSnapshot snapshot = await transaction.get(documentReference2);
        documentReference2.set({"from": uid,"to": uidLocal, "content": content,"timeStamp":date});
        documentReference1.update({"LastMessage": content});
        print("success");
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
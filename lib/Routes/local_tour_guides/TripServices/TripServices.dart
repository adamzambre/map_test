import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TripService{

  // Future<void> _pickImages() async {
  //   final List<XFile>? images = await ImagePicker().pickMultiImage();
  //   if (images != null) {
  //       _imageList.addAll(images);
  //   }
  // }
  //
  // Future<void> _submitForm() async {
  //   final userId = FirebaseAuth.instance.currentUser!.uid; // Replace with code to get current user ID
  //   final tripFolderRef = FirebaseStorage.instance.ref('/locals/$userId/trips/');
  //
  //   for (var i = 0; i < _imageList.length; i++) {
  //     final file = File(_imageList[i].path);
  //     final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  //     final filename = 'image_$timestamp.jpg';
  //     final uploadTask = tripFolderRef.child(filename).putFile(file);
  //
  //     final snapshot = await uploadTask.whenComplete(() {});
  //     if (snapshot.state == TaskState.success) {
  //       final downloadUrl = await snapshot.ref.getDownloadURL();
  //       print('Image $i uploaded successfully. Download URL: $downloadUrl');
  //     } else {
  //       print('Image $i upload failed.');
  //     }
  //   }
  //
  //   // Add code to save other form data to Firestore
  // }



}
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    return image;
  }

  Future<String?> uploadImageToFirebase(XFile image) async {
    final Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('avt_image')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

    final UploadTask uploadTask = storageRef.putFile(File(image.path));
    final TaskSnapshot snapshot = await uploadTask;
    final String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}

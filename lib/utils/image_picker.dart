import 'package:image_picker/image_picker.dart';

class MsfImagePicker {
  MsfImagePicker._();
  static final MsfImagePicker instance = MsfImagePicker._();


  Future<XFile?> pickImageFromGallery() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      return image;
    }else{
      return null;
    }
  }

  Future<XFile?> captureImage() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      return image;
    }else{
      return null;
    }
  }

}
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data'; // Import this for Uint8List

Future<Uint8List?> pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();

  try {
    XFile? file = await imagePicker.pickImage(source: source);

    if (file != null) {
      return await file.readAsBytes();
    } else {
      // Image picking was canceled
      print('Image picking canceled.');
      return null;
    }
  } catch (e) {
    // Handle any errors that occur during image picking
    print('Error picking image: $e');
    return null;
  }
}
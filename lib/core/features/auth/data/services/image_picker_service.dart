import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImagePickerService {
  ImagePickerService({ImagePicker? imagePicker})
    : _imagePicker = imagePicker ?? ImagePicker();

  final ImagePicker _imagePicker;

  /// Returns a durable local copy so the picker cache can be safely cleared.
  Future<File?> pickAvatar() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (pickedFile == null) return null;

    final directory =
        await getApplicationDocumentsDirectory(); // finding app storage
    final avatarDirectory = Directory(
      path.join(directory.path, 'avatars'),
    ); // creating a subdirectory for avatars  ex: <documents directory>/avatars
    if (!await avatarDirectory.exists()) {
      // checks if the directory exists
      await avatarDirectory.create(
        recursive: true,
      ); // creates the directory if it doesn't exist
    }

    final extension = path.extension(
      pickedFile.path,
    ); //Preserving the file extension
    //Extracts the original extension, such as: .jpg  .png  .jpeg

    final fileName = // CREATING A UNIQUE FILE NAME FOR THE AVATAR IMAGE
        'avatar_${DateTime.now().microsecondsSinceEpoch}$extension';
    // ex -> avatar_1757321450123456.jpg
    return File(pickedFile.path).copy(
      path.join(avatarDirectory.path, fileName),
    ); //<documents directory>/avatars/avatar_1757321450123456.jpg
  }
}

// === === === === === === === === === === === === === === === === === === === ===
///! Why copy the image ?
// === === === === === === === === === === === === === === === === === === === ===

// The image returned by image_picker may be located in a temporary cache controlled
// by the operating system or gallery provider.
// If you only saved that temporary path, //w it could become invalid later.
// Your code instead //w stores a copy in the application documents directory:
        // temporary picker file
        //         ↓ copy
        // application documents/avatars/avatar_xxx.jpg
//w The database stores the path of the durable copy.

// === === === === === === === === === === === === === === === === === === === ===

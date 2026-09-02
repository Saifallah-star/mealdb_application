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

    final directory = await getApplicationDocumentsDirectory();
    final avatarDirectory = Directory(path.join(directory.path, 'avatars'));
    if (!await avatarDirectory.exists()) {
      await avatarDirectory.create(recursive: true);
    }

    final extension = path.extension(pickedFile.path);
    final fileName =
        'avatar_${DateTime.now().microsecondsSinceEpoch}$extension';
    return File(
      pickedFile.path,
    ).copy(path.join(avatarDirectory.path, fileName));
  }
}

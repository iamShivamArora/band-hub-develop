import 'dart:io';

import 'package:band_hub/widgets/helper_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';


class ImagePickerUtility {

  /// Pick image from Gallery and return cropped image
  Future<String?>  pickImageFromGallery({bool isCropping = false, CropAspectRatioPreset? cropAspectRatioPreset}) async {
    if(await isStorageEnabled()){
      XFile? path = await ImagePicker().pickImage(source: ImageSource.gallery);
      // if(path != null && isCropping){
      //   String? croppedPath = await cropSelectedImage(path.path, cropAspectRatioPreset);
      //   return croppedPath;
      // }
      return path?.path;
    } else {
      return null;
    }
  }

  /// Pick image from Camera and return cropped image
  Future<String?>  pickImageFromCamera({bool isCropping = false, CropAspectRatioPreset? cropAspectRatioPreset}) async {
    if(await isCameraEnabled()){
      XFile? path = await ImagePicker().pickImage(source: ImageSource.camera);
      // if(path != null && isCropping){
      //   String? croppedPath = await cropSelectedImage(path.path, cropAspectRatioPreset);
      //   return croppedPath;
      // }
      return path?.path;
    } else {
      return null;
    }
  }

  /// Takes image input
  // Future<String?> cropSelectedImage(String imageFile, CropAspectRatioPreset? cropAspectRatioPreset) async {
    // CroppedFile? croppedFile;
    // croppedFile = await ImageCropper().cropImage(
    //   sourcePath: imageFile,
    //   compressQuality: 60,
    //   aspectRatioPresets: [
    //     cropAspectRatioPreset ?? CropAspectRatioPreset.square,
    //   ],
    //   uiSettings: [
    //     AndroidUiSettings(
    //       toolbarTitle: 'Cropper',
    //       toolbarColor: Colors.black,
    //       toolbarWidgetColor: Colors.white,
    //       initAspectRatio: CropAspectRatioPreset.original,
    //       lockAspectRatio: true,
    //     ),
    //     IOSUiSettings(
    //       minimumAspectRatio: 1.0,
    //     ),
    //   ],
    // );
    // return croppedFile?.path;
  // }

  Future<bool> isCameraEnabled() async {
    // return true;
    var status = await Permission.camera.request();
    debugPrint("status: " + status.toString());
    if (status == PermissionStatus.permanentlyDenied) {
      HelperWidget.showToast(message: "Camera permission permanently denied, we are redirecting to you setting screen to enable permission");
      Future.delayed(const Duration(seconds: 4), () {
        openAppSettings();
      });
      return false;
    } else if (status == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> isStorageEnabled() async {
    // return true;
    var status;
    if (Platform.isAndroid) {
      status = await Permission.storage.request();
    } else {
      status = await Permission.photos.request();
    }
    debugPrint("status: " + status.toString());
    if (Platform.isAndroid) {
      if (status == PermissionStatus.permanentlyDenied) {
        HelperWidget.showToast(message: "Storage permission permanently denied, we are redirecting to you setting screen to enable permission");
        Future.delayed(const Duration(seconds: 4), () {
          openAppSettings();
        });
        return false;
      } else if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    } else {    
      if (status == PermissionStatus.permanentlyDenied) {
        HelperWidget.showToast(message: "Photos permission permanently denied, we are redirecting to you setting screen to enable permission");
        Future.delayed(const Duration(seconds: 4), () {
          openAppSettings();
        });
        return false;
      } else if (status == PermissionStatus.granted || status == PermissionStatus.limited) {
        return true;
      } else {
        return false;
      }
    }
  }
}

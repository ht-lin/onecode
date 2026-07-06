import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gallery_image_picker.g.dart';

/// 系统相册选图抽象；widget 测试用 fake 覆写 provider。
abstract interface class GalleryImagePicker {
  /// 打开系统选图器，返回所选图片的本地路径；用户取消返回 null。
  Future<String?> pickImagePath();
}

/// iOS 走 PHPicker（image_picker 默认），Android 强制 Photo Picker——
/// 均免全相册权限（SPEC §3.1 方式二，M1-04）。
class SystemGalleryImagePicker implements GalleryImagePicker {
  SystemGalleryImagePicker() {
    final platform = ImagePickerPlatform.instance;
    if (platform is ImagePickerAndroid) {
      platform.useAndroidPhotoPicker = true;
    }
  }

  final _picker = ImagePicker();

  @override
  Future<String?> pickImagePath() async {
    // requestFullMetadata: false → iOS 侧不触发相册权限请求。
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      requestFullMetadata: false,
    );
    return file?.path;
  }
}

@Riverpod(keepAlive: true)
GalleryImagePicker galleryImagePicker(Ref ref) => SystemGalleryImagePicker();

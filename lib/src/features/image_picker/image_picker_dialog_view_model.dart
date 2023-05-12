import '../../core/mvvm/base_view_model.dart';
import '../../model/repository/image_picker/image_picker_repository.dart';

enum ImagePickerViewState {
  completed,
  error,
  loading,
}

class ImagePickerDialogViewModel extends BaseViewModel<ImagePickerViewState> {
  ImagePickerDialogViewModel(
      {required ImagePickerRepository imagePickerRepository})
      : _imagePickerRepository = imagePickerRepository;

  final ImagePickerRepository _imagePickerRepository;
  Future<void> uploadImageToFirebaseStorage({
    required String base64Image,
    bool isProfilePicture = true,
  }) async {
    try {
      _imagePickerRepository.uploadImage(
        image: base64Image,
        isProfilePicture: isProfilePicture,
      );
    } catch (e) {}
  }
}

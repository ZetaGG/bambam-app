import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> getProductImageUrl(String productId) async {
    try {
      final ref = _storage.ref().child('products/$productId.jpg');
      return await ref.getDownloadURL();
    } catch (_) {
      return '';
    }
  }
}

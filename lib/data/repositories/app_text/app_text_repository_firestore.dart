import 'package:racecourse_tracks/data/repositories/app_text/app_text_repository.dart';
import 'package:racecourse_tracks/data/services/firestore_service.dart';
import 'package:racecourse_tracks/domain/models/app_text.dart';

class AppTextRepositoryFirestore implements AppTextRepository {
  final FirestoreService _firestoreService;

  AppTextRepositoryFirestore(this._firestoreService);
  List<AppText> _appTexts = [];
  
  @override
  Future<void> fetchAppTexts() async {
    try {
      _appTexts = await _firestoreService.getAllAppTexts();
    } catch (e) {
      // Handle error, e.g., log it or rethrow
      throw Exception('Failed to fetch app texts: $e');
    }
  }
  
  @override
  Map<String, AppText> get appTexts {
    return {
      for (var appText in _appTexts) appText.id: appText,
    };
  }
}

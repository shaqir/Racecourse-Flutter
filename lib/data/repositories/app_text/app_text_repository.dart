import 'package:racecourse_tracks/domain/models/app_text.dart';

abstract class AppTextRepository {
  Map<String, AppText> get appTexts;
  Future<void> fetchAppTexts();
}

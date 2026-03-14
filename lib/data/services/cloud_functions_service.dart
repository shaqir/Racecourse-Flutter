import 'package:cloud_functions/cloud_functions.dart';

class CloudFunctionsService {
  final FirebaseFunctions _functions;

  CloudFunctionsService(this._functions);

  Future<Map<String,dynamic>> refreshRacecourseData(String racecourseId) async {
    try {
      final HttpsCallable callable = _functions.httpsCallable('refreshRacecourse');
      final response = await callable.call(<String, dynamic>{
        'racecourseId': racecourseId,
      });
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }


}
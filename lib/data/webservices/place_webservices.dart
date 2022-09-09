import 'package:dio/dio.dart';

import '../../constants/strings.dart';

class PlacesWebServices {
  late Dio dio;

  PlacesWebServices() {
    BaseOptions options = BaseOptions(
        connectTimeout: 20 * 1000,
        receiveTimeout: 20 * 1000,
        receiveDataWhenStatusError: true);
    dio = Dio(options);
  }

  Future<List<dynamic>> getSuggestionPlacesList(
      String place, String sessionToke) async {
    try {
      Response response =
          await dio.get(placesSuggestionBaseUrl, queryParameters: {
        'input': place,
        'components': 'country:eg',
        'type': '(regions)',
        'key': googleAPIKey,
        'sessiontoken': sessionToke
      });
      return response.data['predictions'];
    } catch (error) {
      print(error.toString());
      return [];
    }
  }
}

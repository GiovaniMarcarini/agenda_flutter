import 'package:dio/dio.dart';

class GeocodingService {
  final Dio _dio;
  final String _apiKey;

  GeocodingService({Dio? dio, String? apiKey})
      : _dio = dio ?? Dio(),
        _apiKey = apiKey ?? 'AIzaSyBo4jxNJrw39BOoRVWDy7l2UIgB_Pn1APs';

  Future<Map<String, double>?> getCoordinatesFromAddress(String address) async {
    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/geocode/json',
        queryParameters: {
          'address': address,
          'key': _apiKey,
        },
      );

      if (response.data['results'].isNotEmpty) {
        final location = response.data['results'][0]['geometry']['location'];
        return {
          'latitude': location['lat'],
          'longitude': location['lng'],
        };
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
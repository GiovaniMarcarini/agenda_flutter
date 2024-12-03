import 'package:dio/dio.dart';

class APIService {
  final Dio _dio;

  APIService({Dio? dio}) : _dio = dio ?? Dio();

  Future<Map<String, String>?> getAddress(String cep) async {
    try {
      final response = await _dio.get('https://viacep.com.br/ws/$cep/json/');
      if (response.statusCode == 200 && response.data['erro'] == null) {
        return {
          'logradouro': response.data['logradouro'] ?? '',
          'cidade': response.data['localidade'] ?? '',
          'estado': response.data['uf'] ?? '',
        };
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

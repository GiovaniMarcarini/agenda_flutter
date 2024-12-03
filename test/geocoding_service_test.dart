import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:agenda_flutter/services/geocoding_service.dart';

import 'geocoding_service_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late GeocodingService geocodingService;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    geocodingService = GeocodingService(dio: mockDio); // Injeta o mock
  });

  group('GeocodingService Tests', () {
    test('Deve retornar coordenadas para um endereço válido', () async {
      final mockResponse = {
        'results': [
          {
            'geometry': {
              'location': {'lat': 40.714224, 'lng': -73.961452}
            }
          }
        ]
      };

      when(mockDio.get(
        'https://maps.googleapis.com/maps/api/geocode/json',
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
        data: mockResponse,
        statusCode: 200,
        requestOptions: RequestOptions(
          path: 'https://maps.googleapis.com/maps/api/geocode/json',
        ),
      ));

      final result =
      await geocodingService.getCoordinatesFromAddress('1600 Amphitheatre Parkway, Mountain View, CA');

      expect(result, isNotNull);
      expect(result!['latitude'], 40.714224);
      expect(result['longitude'], -73.961452);
    });

    test('Deve retornar null para um endereço inválido', () async {
      final mockResponse = {
        'results': []
      };

      when(mockDio.get(
        'https://maps.googleapis.com/maps/api/geocode/json',
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
        data: mockResponse,
        statusCode: 200,
        requestOptions: RequestOptions(
          path: 'https://maps.googleapis.com/maps/api/geocode/json',
        ),
      ));

      final result = await geocodingService.getCoordinatesFromAddress('Endereço inválido');

      expect(result, isNull);
    });

    test('Deve retornar null para um erro na API', () async {
      when(mockDio.get(
        'https://maps.googleapis.com/maps/api/geocode/json',
        queryParameters: anyNamed('queryParameters'),
      )).thenThrow(DioError(
        requestOptions: RequestOptions(
          path: 'https://maps.googleapis.com/maps/api/geocode/json',
        ),
        error: 'Erro na API',
        type: DioErrorType.connectionError,
      ));

      final result = await geocodingService.getCoordinatesFromAddress('1600 Amphitheatre Parkway, Mountain View, CA');

      expect(result, isNull);
    });
  });
}
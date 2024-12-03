
import 'package:agenda_flutter/services/cep_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'cep_service_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late APIService apiService;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    apiService = APIService(dio: mockDio);
  });

  group('APIService Tests', () {
    test('Deve retornar endereço ao consultar um CEP válido', () async {
      const validCep = '01001000';
      when(mockDio.get('https://viacep.com.br/ws/$validCep/json/'))
          .thenAnswer((_) async => Response(
        data: {
          'logradouro': 'Praça da Sé',
          'localidade': 'São Paulo',
          'uf': 'SP',
          'erro': null
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      ));

      final result = await apiService.getAddress(validCep);

      expect(result, isNotNull);
      expect(result, {
        'logradouro': 'Praça da Sé',
        'cidade': 'São Paulo',
        'estado': 'SP',
      });
    });

    test('Deve retornar null ao consultar um CEP inexistente', () async {
      const invalidCep = '00000000';
      when(mockDio.get('https://viacep.com.br/ws/$invalidCep/json/'))
          .thenAnswer((_) async => Response(
        data: {'erro': true},
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      ));

      final result = await apiService.getAddress(invalidCep);

      expect(result, isNull);
    });

    test('Deve retornar null ao ocorrer erro na requisição', () async {
      const errorCep = '12345678';
      when(mockDio.get('https://viacep.com.br/ws/$errorCep/json/'))
          .thenThrow(DioError(
        requestOptions: RequestOptions(path: ''),
        type: DioErrorType.connectionError,
      ));

      final result = await apiService.getAddress(errorCep);

      expect(result, isNull);
    });
  });
}

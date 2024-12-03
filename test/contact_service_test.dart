import 'package:agenda_flutter/services/contact_services.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const MethodChannel channel = MethodChannel('com.example.agenda/contacts');

  TestWidgetsFlutterBinding.ensureInitialized();

  group('ContactService', () {
    const mockContacts = [
      {'name': 'João Silva', 'phone': '123456789'},
      {'name': 'Maria Oliveira', 'phone': '987654321'},
      {'name': null, 'phone': null},
    ];

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'getContacts') {
          return mockContacts;
        }
        return null;
      });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('Retorna a lista de contatos corretamente', () async {
      final contacts = await ContactService.getContacts();
      expect(contacts, isA<List<Map<String, dynamic>>>());
      expect(contacts.length, 3);
      expect(contacts[0]['name'], 'João Silva');
      expect(contacts[0]['phone'], '123456789');
      expect(contacts[2]['name'], 'Sem Nome');
      expect(contacts[2]['phone'], 'Sem Telefone');
    });

    test('Retorna uma lista vazia em caso de erro', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        throw PlatformException(code: 'ERROR');
      });

      final contacts = await ContactService.getContacts();
      expect(contacts, isEmpty);
    });
  });
}

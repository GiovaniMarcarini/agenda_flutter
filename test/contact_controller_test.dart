import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:agenda_flutter/controllers/contact_controller.dart';
import 'package:agenda_flutter/models/contact.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void setupTestDatabase() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}

void main() {
  setupTestDatabase();

  group('ContactController Tests', () {
    late ContactController controller;

    setUp(() {
      Get.reset();
      controller = ContactController();
      Get.put(controller);
    });

    test('Adicionar um novo contato', () async {
      final contact = Contact(
        id: 1,
        name: 'João Silva',
        phone: '123456789',
        cep: '12345678',
        address: 'Rua A',
        number: '10',
        city: 'Cidade X',
        state: 'Estado Y',
      );

      await controller.addContact(contact);

      expect(controller.contacts.length, 1);
      expect(controller.contacts.first.name, 'João Silva');
    });

    test('Excluir um contato', () async {
      final contact = Contact(
        id: 1,
        name: 'João Silva',
        phone: '123456789',
        cep: '12345678',
        address: 'Rua A',
        number: '10',
        city: 'Cidade X',
        state: 'Estado Y',
      );

      await controller.addContact(contact);
      expect(controller.contacts.length, 1);

      await controller.deleteContact(contact.id!);
      expect(controller.contacts.isEmpty, true);
    });
  });
}

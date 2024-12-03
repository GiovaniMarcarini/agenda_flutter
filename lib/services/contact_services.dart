import 'package:flutter/services.dart';

class ContactService {
  static const _channel = MethodChannel('com.example.agenda/contacts');

  static Future<List<Map<String, dynamic>>> getContacts() async {
    try {
      final List<dynamic> result = await _channel.invokeMethod('getContacts');
      return result.map((contact) {
        return {
          'name': contact['name'] ?? 'Sem Nome',
          'phone': contact['phone'] ?? 'Sem Telefone',
        };
      }).toList();
    } catch (e) {
      return [];
    }
  }
}

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:agenda_flutter/utils/formatter.dart';

// Mock da classe Formatter (se necessário simular comportamento)
class MockFormatter extends Mock implements Formatter {}

void main() {
  group('Formatter Tests', () {
    // Testa o formato do telefone
    test('Formatação de telefone', () {
      expect(Formatter.formatPhone('11987654321'), '(11) 98765-4321');
      expect(Formatter.formatPhone('119876543'), '(11) 9876-543');
      expect(Formatter.formatPhone('11876'), '(11) 876');
      expect(Formatter.formatPhone('11'), '11');
      expect(Formatter.formatPhone(''), '');
    });

    // Testa o formato do CEP
    test('Formatação de CEP', () {
      expect(Formatter.formatCep('12345678'), '12345-678');
      expect(Formatter.formatCep('12345'), '12345');
      expect(Formatter.formatCep('1234'), '1234');
      expect(Formatter.formatCep(''), '');
    });

    // Testa o TextInputFormatter para telefone
    test('TextInputFormatter de telefone', () {
      final formatter = Formatter.phoneInputFormatter();

      const oldValue = TextEditingValue(text: '');
      const newValue = TextEditingValue(text: '11987654321');
      final result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, '(11) 98765-4321');
    });

    // Testa o TextInputFormatter para CEP
    test('TextInputFormatter de CEP', () {
      final formatter = Formatter.cepInputFormatter();

      const oldValue = TextEditingValue(text: '');
      const newValue = TextEditingValue(text: '12345678');
      final result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, '12345-678');
    });
  });
}

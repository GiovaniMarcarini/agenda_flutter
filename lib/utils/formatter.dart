import 'package:flutter/services.dart';

class Formatter {
  /// Formata o número de telefone para o padrão (XX) XXXXX-XXXX.
  static String formatPhone(String phone) {
    phone = phone.replaceAll(RegExp(r'\D'), '');
    if (phone.length > 10) {
      return "(${phone.substring(0, 2)}) ${phone.substring(2, 7)}-${phone.substring(7)}";
    } else if (phone.length > 5) {
      return "(${phone.substring(0, 2)}) ${phone.substring(2, 6)}-${phone.substring(6)}";
    } else if (phone.length > 2) {
      return "(${phone.substring(0, 2)}) ${phone.substring(2)}";
    } else {
      return phone;
    }
  }

  /// Formata o CEP para o padrão XXXXX-XXX.
  static String formatCep(String cep) {
    cep = cep.replaceAll(RegExp(r'\D'), '');
    if (cep.length <= 5) {
      return cep;
    } else {
      return "${cep.substring(0, 5)}-${cep.substring(5)}";
    }
  }

  /// Retorna um `TextInputFormatter` para formatar o telefone.
  static TextInputFormatter phoneInputFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      final formatted = formatPhone(newValue.text);
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    });
  }

  /// Retorna um `TextInputFormatter` para formatar o CEP.
  static TextInputFormatter cepInputFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      final formatted = formatCep(newValue.text);
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    });
  }
}

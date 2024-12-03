import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:agenda_flutter/controllers/contact_controller.dart';
import 'package:agenda_flutter/screens/contact_form.dart';

void main() {
  testWidgets('Adicionar contato pelo formulário', (WidgetTester tester) async {

    Get.put(ContactController());

    await tester.pumpWidget(
      GetMaterialApp(
        home: ContactFormScreen(),
      ),
    );

    await tester.enterText(find.byKey(const Key('nameField')), 'João Silva'); // Nome
    await tester.enterText(find.byKey(const Key('phoneField')), '123456789'); // Telefone
    await tester.enterText(find.byKey(const Key('cepField')), '12345678');   // CEP

    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    final controller = Get.find<ContactController>();
    expect(controller.contacts.length, 1);
    expect(controller.contacts.first.name, 'João Silva');
  });
}

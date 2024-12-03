import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/contact_controller.dart';
import '../services/contact_services.dart';
import 'contact_form.dart';
import 'contact_details.dart';

class ContactListScreen extends StatelessWidget {
  final ContactController controller = Get.put(ContactController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda Telefônica'),
        actions: [
          IconButton(
            icon: const Icon(Icons.contacts),
            onPressed: () async {
              final nativeContacts = await ContactService.getContacts();
              if (nativeContacts.isNotEmpty) {
                for (final nativeContact in nativeContacts) {
                  controller.addContactFromNative(nativeContact);
                }
                Get.snackbar(
                  'Contatos Importados',
                  '${nativeContacts.length} contatos foram importados.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              } else {
                Get.snackbar(
                  'Nenhum Contato Encontrado',
                  'Não foi possível importar contatos do sistema.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.contacts.isEmpty) {
          return const Center(child: Text('Nenhum contato encontrado.'));
        }
        return ListView.builder(
          itemCount: controller.contacts.length,
          itemBuilder: (context, index) {
            final contact = controller.contacts[index];
            return ListTile(
              title: Text(contact.name),
              subtitle: Text(contact.phone),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Get.to(() => ContactDetailsScreen(contact: contact));
              },
              leading: CircleAvatar(
                child: Text(contact.name[0].toUpperCase()),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Get.to(() => ContactFormScreen()),
      ),
    );
  }
}
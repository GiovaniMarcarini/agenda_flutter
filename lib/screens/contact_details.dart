import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maps_launcher/maps_launcher.dart';
import '../models/contact.dart';
import '../controllers/contact_controller.dart';
import '../services/geocoding_service.dart';
import 'contact_form.dart';

class ContactDetailsScreen extends StatelessWidget {
  final Contact contact;

  ContactDetailsScreen({required this.contact});

  final ContactController controller = Get.find<ContactController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Contato'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Abre o formulário para editar o contato
              Get.to(() => ContactFormScreen(contact: contact));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              // Mostra o diálogo de confirmação antes de excluir
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Excluir Contato'),
                    content: Text('Tem certeza que deseja excluir "${contact.name}"?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Excluir'),
                      ),
                    ],
                  );
                },
              );

              if (confirm == true) {
                controller.deleteContact(contact.id!);
                Get.back();
                Get.snackbar(
                  'Contato Excluído',
                  '${contact.name} foi removido com sucesso.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildDetailRow('Nome', contact.name),
            buildDetailRow('Telefone', contact.phone),
            buildDetailRow('CEP', contact.cep),
            buildDetailRow('Endereço', contact.address),
            buildDetailRow('Número', contact.number),
            buildDetailRow('Cidade', contact.city),
            buildDetailRow('Estado', contact.state),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final fullAddress =
                      '${contact.address}, ${contact.number}, ${contact.city}, ${contact.state}';
                  final geocodingService = GeocodingService();
                  final coordinates = await geocodingService.getCoordinatesFromAddress(fullAddress);

                  if (coordinates != null) {
                    MapsLauncher.launchCoordinates(
                      coordinates['latitude']!,
                      coordinates['longitude']!,
                      fullAddress,
                    );
                  } else {
                    Get.snackbar(
                      'Erro',
                      'Endereço não encontrado. Verifique se está completo.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                icon: const Icon(Icons.map),
                label: const Text('Ver no Mapa'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Constrói uma linha de detalhes com um título e o valor
  Widget buildDetailRow(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title:',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          value.isNotEmpty ? value : 'Não informado',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

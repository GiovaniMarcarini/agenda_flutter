import 'package:get/get.dart';
import '../models/contact.dart';
import '../provider/db.dart';
import '../utils/formatter.dart';

class ContactController extends GetxController {
  final contacts = <Contact>[].obs;
  final DBHelper _dbHelper = DBHelper();

  @override
  void onInit() {
    loadContacts(); // Carrega os contatos do banco ao inicializar
    super.onInit();
  }

  Future<void> loadContacts() async {
    final contactList = await _dbHelper.getContacts();
    contacts.assignAll(contactList); // Atualiza a lista observável
  }

  Future<void> addContact(Contact contact) async {
    await _dbHelper.insertContact(contact); // Insere no banco
    loadContacts(); // Recarrega a lista de contatos
  }

  Future<void> updateContact(Contact contact) async {
    await _dbHelper.updateContact(contact); // Atualiza no banco
    loadContacts(); // Recarrega a lista de contatos
  }

  Future<void> deleteContact(int id) async {
    await _dbHelper.deleteContact(id); // Remove do banco
    loadContacts(); // Recarrega a lista de contatos
  }

  void addContactFromNative(Map<String, dynamic> nativeContact) {
    final rawPhone = nativeContact['phone'] ?? 'Sem Telefone';
    final formattedPhone = Formatter.formatPhone(rawPhone); // Formata o número

    // Verifica se o contato já existe na lista pelo número de telefone formatado
    final existingContact = contacts.firstWhereOrNull((contact) => contact.phone == formattedPhone);

    if (existingContact != null) {
      // Atualiza os dados do contato existente
      final updatedContact = existingContact.copyWith(
        name: nativeContact['name'] ?? existingContact.name,
      );
      updateContact(updatedContact); // Atualiza no banco e na lista
    } else {
      // Adiciona um novo contato se não existir
      final newContact = Contact(
        name: nativeContact['name'] ?? 'Sem Nome',
        phone: formattedPhone,
        cep: '',
        address: '',
        number: '',
        city: '',
        state: '',
      );
      addContact(newContact);
    }
  }
}

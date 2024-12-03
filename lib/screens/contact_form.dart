import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/contact_controller.dart';
import '../models/contact.dart';
import '../services/cep_service.dart';
import '../utils/formatter.dart';

class ContactFormScreen extends StatefulWidget {
  final Contact? contact;

  ContactFormScreen({this.contact});

  @override
  _ContactFormScreenState createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cepController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _numberController = TextEditingController();

  bool _isLoadingAddress = false;
  bool _isAddressLoaded = false;

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _nameController.text = widget.contact!.name;
      _phoneController.text = widget.contact!.phone;
      _cepController.text = widget.contact!.cep;
      _addressController.text = widget.contact!.address;
      _cityController.text = widget.contact!.city;
      _stateController.text = widget.contact!.state;
      _numberController.text = widget.contact!.number;
      _isAddressLoaded = true;
    }
  }

  Future<void> _fetchAddress() async {
    if (_cepController.text.length == 9) {
      setState(() {
        _isLoadingAddress = true;
        _isAddressLoaded = false;
      });

      final apiService = APIService();
      final addressData = await apiService.getAddress(_cepController.text);

      if (addressData != null) {
        setState(() {
          _addressController.text = addressData['logradouro']!;
          _cityController.text = addressData['cidade']!;
          _stateController.text = addressData['estado']!;
          _isLoadingAddress = false;
          _isAddressLoaded = true;
        });
      } else {
        setState(() {
          _isLoadingAddress = false;
        });
        Get.snackbar(
          'Erro',
          'Endereço não encontrado. Verifique o CEP informado.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ContactController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact == null ? 'Novo Contato' : 'Editar Contato'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo Nome
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) => value!.isEmpty ? 'Insira o nome' : null,
              ),

              // Campo Telefone
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
                keyboardType: TextInputType.phone,
                inputFormatters: [Formatter.phoneInputFormatter()],
                validator: (value) => value!.isEmpty ? 'Insira o telefone' : null,
              ),

              // Campo CEP
              TextFormField(
                controller: _cepController,
                decoration: const InputDecoration(labelText: 'CEP'),
                keyboardType: TextInputType.number,
                inputFormatters: [Formatter.cepInputFormatter()],
                onChanged: (value) {
                  if (value.length == 9) _fetchAddress();
                },
                validator: (value) => value!.isEmpty ? 'Insira o CEP' : null,
              ),

              // Indicador de carregamento (CircularProgressIndicator)
              if (_isLoadingAddress)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(child: CircularProgressIndicator()),
                ),

              // Exibir os campos adicionais somente após o carregamento
              if (_isAddressLoaded) ...[
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Endereço'),
                  readOnly: true,
                ),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(labelText: 'Cidade'),
                  readOnly: true,
                ),
                TextFormField(
                  controller: _stateController,
                  decoration: const InputDecoration(labelText: 'Estado'),
                  readOnly: true,
                ),
                TextFormField(
                  controller: _numberController,
                  decoration: const InputDecoration(labelText: 'Número'),
                  keyboardType: TextInputType.number,
                ),
              ],

              const SizedBox(height: 20),

              ElevatedButton(
                child: const Text('Salvar'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newContact = Contact(
                      id: widget.contact?.id,
                      name: _nameController.text,
                      phone: _phoneController.text,
                      cep: _cepController.text,
                      address: _addressController.text,
                      number: _numberController.text,
                      city: _cityController.text,
                      state: _stateController.text,
                    );
                    if (widget.contact == null) {
                      controller.addContact(newContact);
                    } else {
                      controller.updateContact(newContact);
                    }
                    Get.back();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

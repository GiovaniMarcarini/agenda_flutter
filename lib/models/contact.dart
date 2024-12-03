class Contact {
  int? id;
  String name;
  String phone;
  String cep;
  String address;
  String number;
  String city;
  String state;

  Contact({
    this.id,
    required this.name,
    required this.phone,
    required this.cep,
    required this.address,
    required this.number,
    required this.city,
    required this.state,
  });

  // Método para converter um objeto Contact em um Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'cep': cep,
      'address': address,
      'number': number,
      'city': city,
      'state': state,
    };
  }

  // Método para criar um objeto Contact a partir de um Map<String, dynamic>
  static Contact fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'] as int?,
      name: map['name'] as String,
      phone: map['phone'] as String,
      cep: map['cep'] as String,
      address: map['address'] as String,
      number: map['number'] as String,
      city: map['city'] as String,
      state: map['state'] as String,
    );
  }

  Contact copyWith({
    int? id,
    String? name,
    String? phone,
    String? cep,
    String? address,
    String? number,
    String? city,
    String? state,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      cep: cep ?? this.cep,
      address: address ?? this.address,
      number: number ?? this.number,
      city: city ?? this.city,
      state: state ?? this.state,
    );
  }
}

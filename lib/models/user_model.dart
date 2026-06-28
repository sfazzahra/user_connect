class UserModel {
  final int id;
  final String name;
  final String email;
  final String company;
  final String originalCompany;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.company,
    required this.originalCompany,
  });

  static const List<String> _batamCompanies = [
    'PT McDermott Indonesia',
    'PT Citra Tubindo Tbk',
    'PT Sat Nusapersada Tbk',
    'PT Infineon Technologies Batam',
    'PT Schneider Electric Manufacturing Batam',
    'PT Epson Batam',
    'PT Philips Industries Batam',
    'PT Panasonic Manufacturing Batam Indonesia',
    'PT Unisem Batam',
    'PT Mc Dermott Fabricators Indonesia',
  ];

  static String companyForId(int id) {
    final index = (id - 1) % _batamCompanies.length;
    return _batamCompanies[index];
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    return UserModel(
      id: id,
      name: json['name'] ?? '-',
      email: json['email'] ?? '-',
      originalCompany: (json['company']?['name']) ?? '-',
      company: companyForId(id),
    );
  }
}
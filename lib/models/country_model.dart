
class CountryModel {
  final String name;
  final String capital;
  final String code;
  final String region;
  final String incomeLevel;

  CountryModel({
    required this.name,
    required this.capital,
    required this.code,
    required this.region,
    required this.incomeLevel,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      name: json['name']?.toString() ?? 'Inconnu',
      capital: json['capitalCity']?.toString().isNotEmpty == true
          ? json['capitalCity'].toString()
          : 'Non disponible',
      code: json['id']?.toString() ?? '',
      region: json['region']?['value']?.toString() ?? 'Inconnue',
      incomeLevel:
          json['incomeLevel']?['value']?.toString() ?? 'Inconnu',
    );
  }
}


import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country_model.dart';

class ApiService {
  static const String apiUrl =
      'https://api.worldbank.org/v2/country/TUN?format=json';

  static Future<CountryModel> getTunisia() async {
    final response = await http.get(
      Uri.parse(apiUrl),
    );

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);

      if (data is List &&
          data.length > 1 &&
          data[1] is List &&
          (data[1] as List).isNotEmpty) {
        final countryData = data[1][0];

        return CountryModel.fromJson(
          countryData as Map<String, dynamic>,
        );
      }

      throw Exception('Aucune donnée disponible pour la Tunisie');
    } else {
      throw Exception(
        'Erreur API : ${response.statusCode}',
      );
    }
  }
}

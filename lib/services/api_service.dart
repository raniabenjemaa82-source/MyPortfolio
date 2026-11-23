
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/github_repo_model.dart';

class ApiService {
  static const String apiUrl =
      'https://api.github.com/repos/raniabenjemaa82-source/MyPortfolio';

  static Future<GitHubRepoModel> getRepository() async {
    try {
      final response = await http
          .get(
            Uri.parse(apiUrl),
            headers: {
              'Accept': 'application/vnd.github+json',
              'X-GitHub-Api-Version': '2022-11-28',
            },
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);

        if (data is Map<String, dynamic>) {
          return GitHubRepoModel.fromJson(data);
        }

        throw Exception('Format des données invalide');
      }

      if (response.statusCode == 404) {
        throw Exception('Repository introuvable');
      }

      throw Exception(
        'Erreur API GitHub : ${response.statusCode}',
      );
    } catch (e) {
      throw Exception('Impossible de charger GitHub : $e');
    }
  }
}


import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/portfolio_model.dart';

class StorageService {
  static String _portfolioKey(String name) {
    return 'portfolio_$name';
  }

  // Sauvegarder un portfolio.
  static Future<void> savePortfolio(
    PortfolioModel portfolio,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final data = jsonEncode(portfolio.toJson());

    await prefs.setString(
      _portfolioKey(portfolio.name),
      data,
    );
  }

  // Récupérer un portfolio.
  static Future<PortfolioModel?> loadPortfolio(
    String name,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(_portfolioKey(name));

    if (data == null) {
      return null;
    }

    try {
      final Map<String, dynamic> json =
          jsonDecode(data) as Map<String, dynamic>;

      return PortfolioModel.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  // Récupérer les deux portfolios.
  static Future<List<PortfolioModel>> loadAllPortfolios(
    List<String> names,
  ) async {
    final portfolios = <PortfolioModel>[];

    for (final name in names) {
      final portfolio = await loadPortfolio(name);

      if (portfolio != null) {
        portfolios.add(portfolio);
      }
    }

    return portfolios;
  }

  // Supprimer un portfolio.
  static Future<void> deletePortfolio(String name) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_portfolioKey(name));
  }
}

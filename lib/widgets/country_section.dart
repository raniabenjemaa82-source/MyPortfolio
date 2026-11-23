
import 'package:flutter/material.dart';
import '../models/country_model.dart';
import '../services/api_service.dart';

class CountrySection extends StatefulWidget {
  const CountrySection({super.key});

  @override
  State<CountrySection> createState() => _CountrySectionState();
}

class _CountrySectionState extends State<CountrySection> {
  static const Color primaryColor = Color(0xFF315C81);

  late Future<CountryModel> countryFuture;

  @override
  void initState() {
    super.initState();
    countryFuture = ApiService.getTunisia();
  }

  void retryLoading() {
    setState(() {
      countryFuture = ApiService.getTunisia();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.public, color: primaryColor),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Informations du pays',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 22),
            FutureBuilder<CountryModel>(
              future: countryFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Column(
                    children: [
                      const Text(
                        'Impossible de charger les données.',
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: retryLoading,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Réessayer'),
                      ),
                    ],
                  );
                }

                final country = snapshot.data!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        '🇹🇳',
                        style: TextStyle(fontSize: 55),
                      ),
                    ),
                    const SizedBox(height: 15),
                    _infoRow('Pays', country.name),
                    _infoRow('Capitale', country.capital),
                    _infoRow('Code ISO', country.code),
                    _infoRow('Région', country.region),
                    _infoRow(
                      'Niveau de revenu',
                      country.incomeLevel,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 125,
            child: Text(
              '$title :',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

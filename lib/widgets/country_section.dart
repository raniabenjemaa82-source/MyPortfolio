
import 'package:flutter/material.dart';

import '../models/github_repo_model.dart';
import '../services/api_service.dart';

class CountrySection extends StatefulWidget {
  const CountrySection({super.key});

  @override
  State<CountrySection> createState() => _CountrySectionState();
}

class _CountrySectionState extends State<CountrySection> {
  static const Color primaryColor = Color(0xFF315C81);

  late Future<GitHubRepoModel> repositoryFuture;

  @override
  void initState() {
    super.initState();
    repositoryFuture = ApiService.getRepository();
  }

  void retryLoading() {
    setState(() {
      repositoryFuture = ApiService.getRepository();
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
                Icon(Icons.code, color: primaryColor),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Informations du projet GitHub',
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
            FutureBuilder<GitHubRepoModel>(
              future: repositoryFuture,
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
                        'Impossible de charger les données GitHub.',
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

                final repository = snapshot.data!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Icon(
                        Icons.code,
                        size: 55,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 15),
                    _infoRow('Projet', repository.name),
                    _infoRow('Repository', repository.fullName),
                    _infoRow(
                      'Description',
                      repository.description,
                    ),
                    _infoRow(
                      'Langage',
                      repository.language,
                    ),
                    _infoRow(
                      'Stars',
                      repository.stars.toString(),
                    ),
                    _infoRow(
                      'Forks',
                      repository.forks.toString(),
                    ),
                    _infoRow(
                      'Lien GitHub',
                      repository.url,
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
            child: SelectableText(value),
          ),
        ],
      ),
    );
  }
}

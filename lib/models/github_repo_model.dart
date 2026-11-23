
class GitHubRepoModel {
  final String name;
  final String fullName;
  final String description;
  final String language;
  final int stars;
  final int forks;
  final String url;

  GitHubRepoModel({
    required this.name,
    required this.fullName,
    required this.description,
    required this.language,
    required this.stars,
    required this.forks,
    required this.url,
  });

  factory GitHubRepoModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return GitHubRepoModel(
      name: json['name']?.toString() ?? 'Inconnu',
      fullName: json['full_name']?.toString() ?? '',
      description:
          json['description']?.toString() ??
          'Aucune description disponible',
      language: json['language']?.toString() ??
          'Non disponible',
      stars: json['stargazers_count'] as int? ?? 0,
      forks: json['forks_count'] as int? ?? 0,
      url: json['html_url']?.toString() ?? '',
    );
  }
}

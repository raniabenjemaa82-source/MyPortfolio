
class PortfolioModel {
  final String name;
  String profile;
  String formation;
  String experience;
  List<String> projects;
  List<String> skills;
  List<String> languages;

  // Ancienne certification : conservée pour compatibilité.
  String certification;

  // Nouvelle liste de certifications.
  List<String> certifications;

  PortfolioModel({
    required this.name,
    required this.profile,
    required this.formation,
    required this.experience,
    required this.projects,
    required this.skills,
    required this.languages,
    required this.certification,
    List<String>? certifications,
  }) : certifications = certifications ??
            (certification.trim().isEmpty ? [] : [certification]);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'profile': profile,
      'formation': formation,
      'experience': experience,
      'projects': projects,
      'skills': skills,
      'languages': languages,
      'certification': certifications.isNotEmpty
          ? certifications.first
          : certification,
      'certifications': certifications,
    };
  }

  factory PortfolioModel.fromJson(Map<String, dynamic> json) {
    final oldCertification =
        (json['certification'] ?? '').toString();

    final savedCertifications = json['certifications'];

    List<String> certificationList;

    if (savedCertifications is List) {
      certificationList = savedCertifications
          .map((item) => item.toString())
          .toList();
    } else {
      certificationList = oldCertification.trim().isEmpty
          ? []
          : [oldCertification];
    }

    return PortfolioModel(
      name: json['name'] ?? '',
      profile: json['profile'] ?? '',
      formation: json['formation'] ?? '',
      experience: json['experience'] ?? '',
      projects: List<String>.from(json['projects'] ?? []),
      skills: List<String>.from(json['skills'] ?? []),
      languages: List<String>.from(json['languages'] ?? []),
      certification: oldCertification,
      certifications: certificationList,
    );
  }
}

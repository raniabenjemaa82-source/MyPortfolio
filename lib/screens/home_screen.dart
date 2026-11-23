
import 'package:flutter/material.dart';

import '../models/portfolio_model.dart';
import '../services/storage_service.dart';
import 'portfolio_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeChanged;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color primaryColor = Color(0xFF315C81);

  late PortfolioModel raniaPortfolio;
  late PortfolioModel chaymaPortfolio;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Afficher les données initiales immédiatement.
    raniaPortfolio = _defaultRania();
    chaymaPortfolio = _defaultChayma();

    _loadDashboard();
  }

  PortfolioModel _defaultRania() {
    return PortfolioModel(
      name: 'Rania BEN JEMAA',
      profile:
          'Étudiante en troisième année de Licence en Informatique à l’Institut International de Technologie (IIT). Motivée par le développement et la conception d’applications.',
      formation:
          'Licence en Informatique – IIT, Sfax (2024 – Présent). Baccalauréat en Mathématiques (2024).',
      experience:
          'Stagiaire en Développement Web chez Hypermedia. Développement d’une plateforme e-commerce dédiée à une animalerie avec Laravel, PHP et CSS.',
      projects: [
        'PARADISE – Site web d’agence de voyage (HTML5, CSS3).',
        'EFastOrder – Application de commande de repas (ASP.NET Core MVC, SQL Server).',
        'Bird.Unity – Jeu vidéo 2D (Unity, C#).',
        'Mood Tracker – Journal d’humeur interactif (JavaScript, LocalStorage, HTML/CSS).',
        'Gestionnaire de clubs universitaires (PHP, MySQL, PDO).',
        'Gestion des étudiants et des enseignants (Java, JavaFX).',
      ],
      skills: [
        'Java, PHP, JavaScript, C, C++, Python',
        'MySQL, SQL Server',
        'Laravel, ASP.NET Core, React, Bootstrap, JavaFX, Unity',
        'Visual Studio, VS Code, Eclipse, XAMPP',
      ],
      languages: [
        'Arabe : langue maternelle',
        'Français : intermédiaire',
        'Anglais : intermédiaire',
      ],
      certification:
          'Scrum Fundamentals Certified (SFC™) – SCRUMstudy, juillet 2026.',
    );
  }

  PortfolioModel _defaultChayma() {
    return PortfolioModel(
      name: 'Chayma BEN ROMDHANE',
      profile:
          'Étudiante en 3ème année GLSI à l’Institut International de Technologie (IIT), intéressée par le développement web, logiciel et mobile.',
      formation:
          'Licence en Génie Logiciel et Systèmes d’Information – IIT, Sfax (2024–2027, en cours). Baccalauréat en sciences techniques (2024).',
      experience:
          'Stage en développement web chez Hyper Media du 20 juillet au 31 août 2026. Participation au développement d’un site e-commerce pour une pâtisserie avec Laravel.',
      projects: [
        'Les Jasmins – Boutique en ligne de mode féminine (HTML, CSS).',
        'Gestion École – Application de gestion scolaire (Java, JavaFX, MySQL).',
        'Gestion des clubs universitaires (PHP, MySQL).',
        'eFastOrder – Application de gestion de restaurant (C#, .NET, SQL Server).',
        'Jeu de course automobile (C#, Unity).',
      ],
      skills: [
        'C, C#, Java, PHP',
        'HTML5, CSS3, JavaScript, Bootstrap',
        'Laravel, .NET, Flutter',
        'MySQL, SQL Server',
        'XML, JSON',
        'Eclipse, Visual Studio, VS Code, XAMPP, Unity',
        'Réseaux informatiques',
      ],
      languages: [
        'Arabe : langue maternelle',
        'Français : intermédiaire',
        'Anglais',
      ],
      certification:
          'Scrum Fundamentals Certified (SFC™) – SCRUMstudy, 1 juillet 2026.',
    );
  }

  Future<void> _loadDashboard() async {
    final savedRania =
        await StorageService.loadPortfolio('Rania BEN JEMAA');

    final savedChayma =
        await StorageService.loadPortfolio('Chayma BEN ROMDHANE');

    if (!mounted) return;

    setState(() {
      raniaPortfolio = savedRania ?? _defaultRania();
      chaymaPortfolio = savedChayma ?? _defaultChayma();
      isLoading = false;
    });
  }

  Future<void> _openPortfolio(PortfolioModel portfolio) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PortfolioScreen(
          name: portfolio.name,
          profile: portfolio.profile,
          formation: portfolio.formation,
          experience: portfolio.experience,
          projects: List<String>.from(portfolio.projects),
          skills: List<String>.from(portfolio.skills),
          languages: List<String>.from(portfolio.languages),
          certification: portfolio.certification,
        ),
      ),
    );

    // Recharger les données après le retour à l'accueil.
    await _loadDashboard();
  }

  int get totalProjects =>
      raniaPortfolio.projects.length + chaymaPortfolio.projects.length;

  int get totalSkillGroups =>
      raniaPortfolio.skills.length + chaymaPortfolio.skills.length;

  int get totalCertifications =>
      raniaPortfolio.certifications.length +
      chaymaPortfolio.certifications.length;

  Widget _statCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      color: colors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colors.onSurfaceVariant,
                fontSize: 13,
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'MyPortfolio',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: widget.isDarkMode
                ? 'Activer le mode clair'
                : 'Activer le mode sombre',
            onPressed: widget.onThemeChanged,
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bienvenue !',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Découvrez les portfolios des deux étudiantes.',
                    style: TextStyle(
                      fontSize: 15,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 28),

                  _sectionTitle(context, 'Vue d’ensemble'),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.90,
                    children: [
                      _statCard(
                        context,
                        'Étudiantes',
                        '2',
                        Icons.people_alt_outlined,
                        Colors.blue,
                      ),
                      _statCard(
                        context,
                        'Projets',
                        '$totalProjects',
                        Icons.folder_special_outlined,
                        Colors.orange,
                      ),
                      _statCard(
                        context,
                        'Groupes de compétences',
                        '$totalSkillGroups',
                        Icons.code,
                        Colors.green,
                      ),
                      _statCard(
                        context,
                        'Certifications',
                        '$totalCertifications',
                        Icons.workspace_premium_outlined,
                        Colors.purple,
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  _sectionTitle(context, 'Nos portfolios'),

                  StudentCard(
                    name: raniaPortfolio.name,
                    description: 'Consulter le portfolio de Rania',
                    projectCount: raniaPortfolio.projects.length,
                    skillCount: raniaPortfolio.skills.length,
                    onTap: () => _openPortfolio(raniaPortfolio),
                  ),

                  const SizedBox(height: 16),

                  StudentCard(
                    name: chaymaPortfolio.name,
                    description: 'Consulter le portfolio de Chayma',
                    projectCount: chaymaPortfolio.projects.length,
                    skillCount: chaymaPortfolio.skills.length,
                    onTap: () => _openPortfolio(chaymaPortfolio),
                  ),

                  const SizedBox(height: 28),

                  Center(
                    child: Text(
                      'MyPortfolio © 2026',
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class StudentCard extends StatelessWidget {
  final String name;
  final String description;
  final int projectCount;
  final int skillCount;
  final VoidCallback onTap;

  const StudentCard({
    super.key,
    required this.name,
    required this.description,
    required this.projectCount,
    required this.skillCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      color: colors.surface,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 27,
                    backgroundColor: colors.secondaryContainer,
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: colors.onSecondaryContainer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: colors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: colors.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 17,
                    color: colors.onSurfaceVariant,
                  ),
                ],
              ),
              const Divider(height: 25),
              Row(
                children: [
                  Expanded(
                    child: _miniStat(
                      context,
                      Icons.folder_outlined,
                      '$projectCount',
                      'Projets',
                    ),
                  ),
                  Expanded(
                    child: _miniStat(
                      context,
                      Icons.code,
                      '$skillCount',
                      'Groupes',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _miniStat(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: colors.primary),
        const SizedBox(width: 7),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: colors.onSurface,
                ),
              ),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

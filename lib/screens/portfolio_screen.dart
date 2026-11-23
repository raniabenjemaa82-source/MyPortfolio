
import 'package:flutter/material.dart';

import '../models/portfolio_model.dart';
import '../services/storage_service.dart';
import '../widgets/country_section.dart';

class PortfolioScreen extends StatefulWidget {
  final String name;
  final String profile;
  final String formation;
  final String experience;
  final List<String> projects;
  final List<String> skills;
  final List<String> languages;
  final String certification;

  const PortfolioScreen({
    super.key,
    required this.name,
    required this.profile,
    required this.formation,
    required this.experience,
    required this.projects,
    required this.skills,
    required this.languages,
    required this.certification,
  });

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  late PortfolioModel portfolio;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    portfolio = PortfolioModel(
      name: widget.name,
      profile: widget.profile,
      formation: widget.formation,
      experience: widget.experience,
      projects: List<String>.from(widget.projects),
      skills: List<String>.from(widget.skills),
      languages: List<String>.from(widget.languages),
      certification: widget.certification,
    );

    _loadPortfolio();
  }

  Future<void> _loadPortfolio() async {
    final savedPortfolio =
        await StorageService.loadPortfolio(widget.name);

    if (!mounted) return;

    setState(() {
      if (savedPortfolio != null) {
        portfolio = savedPortfolio;
      }
      isLoading = false;
    });
  }

  Future<void> _savePortfolio() async {
    // Garder l'ancien champ compatible avec les anciennes données.
    portfolio.certification = portfolio.certifications.isNotEmpty
        ? portfolio.certifications.first
        : '';

    await StorageService.savePortfolio(portfolio);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Modifications enregistrées avec succès !'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  String? _validateInput(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ce champ est obligatoire.';
    }
    return null;
  }

  Future<void> _editText(
    String title,
    String currentValue,
    Function(String) onSave,
  ) async {
    final controller = TextEditingController(text: currentValue);
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Modifier $title'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nouvelle valeur',
              ),
              validator: _validateInput,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(dialogContext, true);
                }
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );

    if (result == true && mounted) {
      setState(() {
        onSave(controller.text.trim());
      });
      await _savePortfolio();
    }
  }

  Future<void> _addItem(
    String title,
    List<String> list,
  ) async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Ajouter $title'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Saisir une valeur',
              ),
              validator: _validateInput,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(dialogContext, true);
                }
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );

    if (result == true && mounted) {
      setState(() {
        list.add(controller.text.trim());
      });
      await _savePortfolio();
    }
  }

  Future<void> _editItem(
    String title,
    List<String> list,
    int index,
  ) async {
    final controller = TextEditingController(text: list[index]);
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Modifier $title'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Modifier la valeur',
              ),
              validator: _validateInput,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(dialogContext, true);
                }
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );

    if (result == true && mounted) {
      setState(() {
        list[index] = controller.text.trim();
      });
      await _savePortfolio();
    }
  }

  Future<void> _deleteItem(
    String title,
    List<String> list,
    int index,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: Text('Voulez-vous supprimer $title ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );

    if (confirm == true && mounted) {
      setState(() {
        list.removeAt(index);
      });
      await _savePortfolio();
    }
  }

  Widget _textSection(
    String title,
    String value,
    IconData icon,
    VoidCallback onEdit,
  ) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      color: colors.surface,
      elevation: 2,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: colors.primary, size: 25),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: colors.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onEdit,
                  icon: Icon(Icons.edit, color: colors.primary),
                  tooltip: 'Modifier',
                ),
              ],
            ),
            const Divider(height: 20),
            Text(
              value.isEmpty ? 'Aucune information' : value,
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _projectsSection() {
    final colors = Theme.of(context).colorScheme;

    return Card(
      color: colors.surface,
      elevation: 2,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.folder_special_outlined,
                  color: colors.primary,
                  size: 25,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Projets académiques',
                    style: TextStyle(
                      color: colors.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _addItem('un projet', portfolio.projects);
                  },
                  icon: Icon(
                    Icons.add_circle,
                    color: colors.primary,
                    size: 28,
                  ),
                  tooltip: 'Ajouter un projet',
                ),
              ],
            ),
            const Divider(height: 20),
            if (portfolio.projects.isEmpty)
              Text(
                'Aucun projet ajouté.',
                style: TextStyle(color: colors.onSurface),
              ),
            ...List.generate(portfolio.projects.length, (index) {
              return Card(
                color: colors.surfaceContainerHighest,
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colors.secondaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.code,
                          color: colors.onSecondaryContainer,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          portfolio.projects[index],
                          style: TextStyle(
                            color: colors.onSurface,
                            fontSize: 15,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _editItem(
                            'le projet',
                            portfolio.projects,
                            index,
                          );
                        },
                        icon: Icon(
                          Icons.edit,
                          color: colors.primary,
                          size: 21,
                        ),
                        tooltip: 'Modifier',
                      ),
                      IconButton(
                        onPressed: () {
                          _deleteItem(
                            'ce projet',
                            portfolio.projects,
                            index,
                          );
                        },
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 23,
                        ),
                        tooltip: 'Supprimer',
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _listSection(
    String title,
    List<String> items,
    IconData icon,
  ) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      color: colors.surface,
      elevation: 2,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: colors.primary, size: 25),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: colors.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _addItem(title, items);
                  },
                  icon: Icon(
                    Icons.add_circle,
                    color: colors.primary,
                    size: 28,
                  ),
                  tooltip: 'Ajouter',
                ),
              ],
            ),
            const Divider(height: 20),
            if (items.isEmpty)
              Text(
                'Aucune information ajoutée.',
                style: TextStyle(color: colors.onSurface),
              ),
            ...List.generate(items.length, (index) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.check_circle_outline,
                  color: colors.primary,
                ),
                title: Text(
                  items[index],
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 15,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        _editItem(title, items, index);
                      },
                      icon: Icon(
                        Icons.edit,
                        color: colors.primary,
                      ),
                      tooltip: 'Modifier',
                    ),
                    IconButton(
                      onPressed: () {
                        _deleteItem(title, items, index);
                      },
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                      tooltip: 'Supprimer',
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.name)),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 25),
        children: [
          const SizedBox(height: 20),
          Center(
            child: CircleAvatar(
              radius: 48,
              backgroundColor: colors.secondaryContainer,
              child: Icon(
                Icons.person,
                size: 55,
                color: colors.onSecondaryContainer,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              portfolio.name,
              style: TextStyle(
                color: colors.primary,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 15),

          _textSection(
            'Profil',
            portfolio.profile,
            Icons.person_outline,
            () {
              _editText(
                'le profil',
                portfolio.profile,
                (value) => portfolio.profile = value,
              );
            },
          ),

          _textSection(
            'Formation',
            portfolio.formation,
            Icons.school_outlined,
            () {
              _editText(
                'la formation',
                portfolio.formation,
                (value) => portfolio.formation = value,
              );
            },
          ),

          _textSection(
            'Expérience professionnelle',
            portfolio.experience,
            Icons.work_outline,
            () {
              _editText(
                'l’expérience professionnelle',
                portfolio.experience,
                (value) => portfolio.experience = value,
              );
            },
          ),

          _projectsSection(),

          _listSection(
            'Compétences techniques',
            portfolio.skills,
            Icons.computer,
          ),

          _listSection(
            'Certifications',
            portfolio.certifications,
            Icons.workspace_premium_outlined,
          ),

          _listSection(
            'Langues',
            portfolio.languages,
            Icons.language,
          ),

          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Text(
              'Informations sur la Tunisie (API REST)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const CountrySection(),
        ],
      ),
    );
  }
}

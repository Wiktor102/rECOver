import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:recover/models/user_data_model.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: pageController,
          children: [
            buildIntroSlide(
              "Witaj w aplikacji rECOver!",
              "Cieszymy się, że troszczysz się o naszą planetę!",
            ),
            UserTagsFormPage(pageController: pageController),
            buildFinalSlide(),
          ],
        ),
      ),
    );
  }

  Widget buildIntroSlide(String title, String description) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: const Text("Dalej"),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFinalSlide() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Wszystko gotowe",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
              child: const Text(
                "Mamy nadzieję że z naszą aplikacją uda ci się zmienić swoje nawyki na bardziej ekologiczne",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                context.go("/app");
              },
              child: const Text("Przejdź do aplikacji"),
            ),
          ],
        ),
      ),
    );
  }
}

class UserTagsFormPage extends StatefulWidget {
  final PageController pageController;

  const UserTagsFormPage({required this.pageController, super.key});

  @override
  State<UserTagsFormPage> createState() => _UserTagsFormPageState();
}

class _UserTagsFormPageState extends State<UserTagsFormPage> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _selectedTags = [];

  void toggleTag(String tag) {
    setState(() {
      _selectedTags.contains(tag) ? _selectedTags.remove(tag) : _selectedTags.add(tag);
    });
  }

  void next(context) {
    Provider.of<UserDataModel>(context, listen: false).updateTags(_selectedTags);
    widget.pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Opowiedz nam o sobie",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              "Zaznacz kafelki, które opisują ciebie i twoje nawyki",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Form(
              key: _formKey,
              child: UserTagsForm(toggleTag: toggleTag, selectedTags: _selectedTags),
            ),
            const SizedBox(height: 32),
            ElevatedButton(onPressed: () => next(context), child: const Text("Dalej")),
          ],
        ),
      ),
    );
  }
}

class UserTagsForm extends StatelessWidget {
  final List<String> selectedTags;
  final Function toggleTag;

  const UserTagsForm({required this.selectedTags, required this.toggleTag, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          UserTagsFormTile(
            icon: Symbols.potted_plant,
            label: "Ogród",
            id: "garden",
            selected: selectedTags.contains("garden"),
            onToggled: toggleTag,
          ),
          UserTagsFormTile(
            icon: Icons.directions_car,
            label: "Samochód",
            id: "car",
            selected: selectedTags.contains("car"),
            onToggled: toggleTag,
          ),
          UserTagsFormTile(
            icon: Symbols.psychiatry,
            label: "Vege",
            id: "vege",
            selected: selectedTags.contains("vege"),
            onToggled: toggleTag,
          ),
          UserTagsFormTile(
            icon: Symbols.hot_tub,
            label: "Wanna",
            id: "buthtub",
            selected: selectedTags.contains("buthtub"),
            onToggled: toggleTag,
          ),
          UserTagsFormTile(
            icon: Icons.ac_unit,
            label: "Klimatyzacja",
            id: "ac",
            selected: selectedTags.contains("ac"),
            onToggled: toggleTag,
          ),
        ],
      ),
    );
  }
}

class UserTagsFormTile extends StatelessWidget {
  final String id;
  final String label;
  final IconData icon;

  final bool selected;
  final Function onToggled;

  const UserTagsFormTile({
    required this.id,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onToggled,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return InkWell(
      customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onTap: () {
        onToggled(id);
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? theme.colorScheme.inversePrimary : null,
          border: Border.all(
            color: selected ? theme.colorScheme.primary : theme.colorScheme.outline,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64),
            const SizedBox(height: 16),
            Text(label, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

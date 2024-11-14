import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class TransportSurvey extends StatefulWidget {
  const TransportSurvey({super.key});

  @override
  State<TransportSurvey> createState() => _TransportSurveyState();
}

class _TransportSurveyState extends State<TransportSurvey> {
  List<String> _selected = [];

  void _toggleCheckbox(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else {
        _selected.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Jakich środków transportu dzisiaj używałeś?", style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            Row(
              children: [
                _TransportSurveyItem(
                  id: "walk",
                  selected: _selected.contains("walk"),
                  onTap: _toggleCheckbox,
                  icon: Symbols.directions_walk,
                ),
                const SizedBox(width: 16),
                _TransportSurveyItem(
                  id: "cycle",
                  selected: _selected.contains("cycle"),
                  onTap: _toggleCheckbox,
                  icon: Symbols.directions_bike,
                ),
                const SizedBox(width: 16),
                _TransportSurveyItem(
                  id: "train",
                  selected: _selected.contains("train"),
                  onTap: _toggleCheckbox,
                  icon: Symbols.tram,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _TransportSurveyItem(
                  id: "bus",
                  selected: _selected.contains("bus"),
                  onTap: _toggleCheckbox,
                  icon: Symbols.airport_shuttle,
                ),
                const SizedBox(width: 16),
                _TransportSurveyItem(
                  id: "car",
                  selected: _selected.contains("car"),
                  onTap: _toggleCheckbox,
                  icon: Symbols.directions_car,
                ),
                const SizedBox(width: 16),
                _TransportSurveyItem(
                  id: "airplane",
                  selected: _selected.contains("airplane"),
                  onTap: _toggleCheckbox,
                  icon: Symbols.flight,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TransportSurveyItem extends StatelessWidget {
  final String id;
  final bool selected;
  final ValueChanged<String> onTap;

  final IconData icon;

  const _TransportSurveyItem({
    required this.id,
    required this.selected,
    required this.onTap,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(id),
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: selected
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1,
                )
              : null,
          color: selected ? Theme.of(context).colorScheme.primaryContainer : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            icon,
            size: 36,
            fill: 1,
            color: selected ? Theme.of(context).colorScheme.onPrimaryContainer : null,
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recover/common/screen_heading.dart';
import 'package:recover/data/challanges.dart';
import 'package:recover/models/user_data_model.dart';
import 'package:recover/pages/app/records/transport_survey.dart';

class RecordsPage extends StatefulWidget {
  const RecordsPage({super.key});

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  List<Challenge> applicableChallenges = [];
  List<int> _selected = [];
  Timer? _debounce;

  @override
  void initState() {
    setState(() {
      var userData = Provider.of<UserDataModel>(context, listen: false);

      applicableChallenges = challenges.where((element) {
        if (element.tags.isEmpty) return true;
        bool hasRequiredTags = element.tags.every((tag) {
          if (userData.tags == null) {
            return false;
          }

          if (tag.startsWith('not-')) {
            return !userData.tags!.contains(tag.substring(4));
          } else {
            return userData.tags!.contains(tag);
          }
        });

        return hasRequiredTags;
      }).toList();

      _selected = userData.todayRecords?.achievements ?? [];
    });

    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _toggleCheckbox(bool selected, int id) {
    setState(() {
      if (selected) {
        _selected.add(id);
      } else {
        _selected.remove(id);
      }

      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 1500), () {
        Provider.of<UserDataModel>(context, listen: false).saveRecords(null, _selected);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataModel>(builder: (context, userDataModel, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ScreenHeading(
            title: "rECOrdy",
            subtitle: "Wypełniaj codziennie poniższą ankietę i zdobywaj punkty!",
          ),
          const TransportSurvey(),
          const SizedBox(height: 32),
          Text(
            "Pozostałe rECOrdy",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: applicableChallenges.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(applicableChallenges[index].title),
              leading: Tooltip(
                message: applicableChallenges[index].description,
                child: const Icon(Icons.help, fill: 1),
              ),
              trailing: Checkbox(
                value: _selected.contains(challenges[index].id),
                onChanged: (bool? value) => _toggleCheckbox(value ?? false, challenges[index].id),
              ),
            ),
          ),
        ],
      );
    });
  }
}

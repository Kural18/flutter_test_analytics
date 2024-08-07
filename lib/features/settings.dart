import 'package:flutter/material.dart';

class SettingsData extends ChangeNotifier {
  int selectedAge = 1;
  String selectedGender = 'Male';
  String name = '';

  // Update methods for your variables (optional)

  void updateAge(int newAge) {
    selectedAge = newAge;
    notifyListeners(); // Notify listeners of changes
  }

  void updateGender(String newGender) {
    selectedGender = newGender;
    notifyListeners(); // Notify listeners of changes
  }
  void updateName(String newName) {
    name = newName;
    notifyListeners(); // Notify listeners of changes
  }
}


class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>{
  // Existing member variables:
  //int selectedAge = 1;
  //String selectedGender = 'Male';
  //String name = '';
  final settingsData = SettingsData();

  final List<String> genders = ['Male', 'Female', 'Others'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Text('Enter Kid\'s Age:'), // Replace 'Kid' with appropriate term
                Spacer(),
                SizedBox(
                  width: 100.0, // Adjust width as needed
                  child: DropdownButton<int>(
                    value: settingsData.selectedAge,
                    onChanged: (int? newValue) {
                      settingsData.updateAge(newValue!);
                    },
                    items: List.generate(12, (index) => DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text('${index + 1}'),
                    )),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text('Enter Kid\'s Gender:'), // Replace 'Kid' with appropriate term
                Spacer(),
                SizedBox(
                  width: 100.0, // Adjust width as needed
                  child: DropdownButton<String>(
                    value: settingsData.selectedGender,
                    onChanged: (String? newValue) {
                      settingsData.updateGender(newValue!);
                    },
                    items: genders.map((gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            TextField(
              onChanged: (value) {
                settingsData.updateName(value);
              },
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            // Add a save button or other actions here
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose(); // Call super.dispose() first
  }

}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SafetyTipsScreen extends StatefulWidget {
  @override
  _SafetyTipsScreenState createState() => _SafetyTipsScreenState();
}

class _SafetyTipsScreenState extends State<SafetyTipsScreen> {
  String _selectedCategory = 'All';
  Map<String, List<String>> _safetyTips = {
    'All': [],
    'Earthquake Emergency': [],
    'Lab Usage': [],
    'Common Spaces Usage': [],
    'Fire Emergency': [],
  };

  @override
  void initState() {
    super.initState();
    _loadSafetyTips();
  }

  Future<void> _loadSafetyTips() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedTips = prefs.getString('safety_tips');
    if (cachedTips != null) {
      setState(() {
        _safetyTips = Map<String, List<String>>.from(
            json.decode(cachedTips).map((k, v) => MapEntry(k, List<String>.from(v))));
      });
    } else {
      _fetchSafetyTipsFromServer();
    }
  }

  Future<void> _fetchSafetyTipsFromServer() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _safetyTips = {
        'All': [],
        'Earthquake Emergency': [
          'Drop, cover, and hold on during an earthquake.',
          'Move away from windows and heavy objects.',
          'Follow evacuation routes after the shaking stops.',
        ],
        'Lab Usage': [
          'Wear appropriate personal protective equipment (PPE).',
          'Know the location of safety equipment like eyewash stations.',
          'Label all chemical containers correctly.',
        ],
        'Common Spaces Usage': [
          'Keep common areas clean and free of obstructions.',
          'Report any suspicious activity to campus security.',
          'Follow posted occupancy limits.',
        ],
        'Fire Emergency': [
          'Know the location of fire extinguishers.',
          'Evacuate immediately when a fire alarm sounds.',
          'Never use elevators during a fire evacuation.',
        ],
      };
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('safety_tips', json.encode(_safetyTips));
  }

  List<String> get _filteredTips {
    if (_selectedCategory == 'All') {
      return _safetyTips.values.expand((tips) => tips).toList();
    } else {
      return _safetyTips[_selectedCategory] ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Safety Tips on Campus',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Color.fromRGBO(80, 225, 130, 1),
          onPressed: () {
            Navigator.pop(context);
          },
          padding: EdgeInsets.zero,
          splashRadius: 24,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(80, 225, 130, 1),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue!;
                      });
                    },
                    dropdownColor: Colors.white,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                    items: _safetyTips.keys.map<DropdownMenuItem<String>>((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category, style: TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Stack(
                children: [
                  if (_selectedCategory == 'All')
                    Positioned.fill(
                      child: Container(
                        color: Colors.grey.withOpacity(0.1),
                        child: Image.asset(
                          'assets/tips.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  if (_selectedCategory != 'All')
                    ListView.builder(
                      itemCount: _safetyTips[_selectedCategory]!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              _safetyTips[_selectedCategory]![index],
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

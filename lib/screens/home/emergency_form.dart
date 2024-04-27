import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

class EmergencyForm extends StatefulWidget {
  const EmergencyForm({super.key});

  @override
  State<EmergencyForm> createState() => _EmergencyFormState();
}

class _EmergencyFormState extends State<EmergencyForm> {
  String _type = "";
  String _scope = "";
  String _description = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('What is the emergency?'),
      content: Column(
        mainAxisSize: MainAxisSize.min, // Avoid exceeding screen size
        children: [
          Column(
            children: [
              const ListTile(
                title: Text("Type of emergency"),
              ),
              RadioListTile<String>(
                title: const Text("Personal"),
                value: "personal",
                groupValue: _type,
                onChanged: (value) => setState(() => _type = value!),
              ),
              RadioListTile<String>(
                title: const Text("Earthquake"),
                value: "earthquake",
                groupValue: _type,
                onChanged: (value) => setState(() => _type = value!),
              ),
            ],
          ),
          Column(
            children: [
              const ListTile(
                title: Text("Scope of the emergency"),
              ),
              RadioListTile<String>(
                title: const Text("individual"),
                value: "individual",
                groupValue: _scope,
                onChanged: (value) => setState(() => _scope = value!),
              ),
              RadioListTile<String>(
                title: const Text("Community"),
                value: "community",
                groupValue: _scope,
                onChanged: (value) => setState(() => _scope = value!),
              ),
            ],
          ),
          TextField(
            decoration: const InputDecoration(
              hintText: "Description",
            ),
            onChanged: (value) => setState(() => _description = value),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            FirebaseUserRepo().uploadReport(_type, _scope, _description);
            Navigator.pop(context);
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class ResultInfoTile extends StatelessWidget {
  final String label;
  final String? value;
  final IconData icon;

  const ResultInfoTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 20, color: Colors.grey.shade600),
      title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      subtitle: Text(
        value ?? '---',
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      dense: true,
    );
  }
}

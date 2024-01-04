import 'package:flutter/material.dart';

class AdditionalInfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String data;
  const AdditionalInfoItem(
      {super.key, required this.icon, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Icon(
        icon,
        size: 48,
      ),
      const SizedBox(
        height: 10,
      ),
      Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      const SizedBox(
        height: 10,
      ),
      Text(
        data,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      )
    ]);
  }
}

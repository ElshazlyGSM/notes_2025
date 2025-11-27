import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({
    super.key,
    required this.text,
    required this.icon,
    this.onPressed,
  });
  final String text;
  final IconData icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(text, style: const TextStyle(fontSize: 28)),
        const Spacer(),
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color.fromRGBO(255, 255, 255, 0.15),
          ),
          child: IconButton(onPressed: onPressed, icon: Icon(icon, size: 28)),
        ),
      ],
    );
  }
}

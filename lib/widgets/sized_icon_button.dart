import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

///Custom IconButton
///with a [VoidCallback]
///
///
class SizedIconButton extends StatelessWidget {
  ///[width] sets the size of the icon
  ///[icon] sets the icon
  /// [onPressed] is the callback
  const SizedIconButton(
      {Key? key,
      required this.width,
      required this.icon,
      required this.onPressed})
      : super(key: key);

  ///[width] sets the size of the icon
  final double width;

  ///[icon] sets the icon
  final FaIcon icon;
  // final IconData icon;

  /// [onPressed] is the callback
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextButton(
        onPressed: onPressed,
        child: icon,
        // Icon(icon)
      ),
    );
  }
}
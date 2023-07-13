import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

///Custom IconButton
///with a [VoidCallback]
///
///
class PlayPauseButton extends StatelessWidget {
  ///[icon] sets the icon
  /// [onPressed] is the callback
  const PlayPauseButton(
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
    return Container(
      height: width,
      width: width,
      decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(50)),
      child: Center(
        child: IconButton(
          onPressed: onPressed,
          icon: icon,
          // Icon(icon)
        ),
      ),
    );
  }
}

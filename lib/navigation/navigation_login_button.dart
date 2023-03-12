import 'package:flutter/material.dart';
import '../theme/ltrb_navigation_style.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onTap;
  const LoginButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navigationStyle = theme.extension<LtrbNavigationStyle>();

    return Material(
      type: MaterialType.circle,
      clipBehavior: Clip.antiAlias,
      elevation: 0.0,
      color: navigationStyle?.headerColorPrimair,
      child: InkWell(
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.person_outline,
            size: 36.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

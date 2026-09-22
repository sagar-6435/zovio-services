import 'package:flutter/material.dart';

class ZovioAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final bool showBackButton;
  final PreferredSizeWidget? bottom;
  final double elevation;

  const ZovioAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.onBackPressed,
    this.showBackButton = true,
    this.bottom,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: titleWidget ??
          (title != null ? Text(title!) : null),
      centerTitle: false,
      elevation: elevation,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : null,
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}

import 'package:flutter/material.dart';
import 'package:spotify/common/helpers/is_dark_mode.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';

class BasicAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Color? backgroundColor;
  final bool hideBackButton;
  final IconData? leadingIcon;
  final Widget? actions;
  const BasicAppbar(
      {this.title,
      this.hideBackButton = false,
      this.leadingIcon,
      super.key,
      this.actions,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: 0,
      title: title ?? const Text(''),
      centerTitle: true,
      leading: hideBackButton
          ? null
          : IconButton(
              icon: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: context.isDarkMode
                        ? Colors.white.withOpacity(0.03)
                        : Colors.black.withOpacity(0.04),
                    shape: BoxShape.circle),
                child: Icon(
                  leadingIcon ?? Icons.arrow_back_ios_new,
                  color: context.isDarkMode
                      ? AppColors.white
                      : AppColors.darkGrey,
                  size: 25,
                ),
              ),
              onPressed: () {
                Navigator.pop(context,true);
              },
            ),
      actions: [actions ?? Container()],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

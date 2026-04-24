import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({
    super.key,
    required this.onTap,
    this.tooltip = 'Geri',
    this.size = 44,
  });

  static const String iconPath = 'asset/icons/geri.svg';

  final VoidCallback onTap;
  final String tooltip;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(7),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(7),
          child: SizedBox(
            width: size,
            height: size,
            child: Center(
              child: SvgPicture.asset(iconPath, width: size, height: size),
            ),
          ),
        ),
      ),
    );
  }
}

class AppBackButtonAppBarLeading extends StatelessWidget {
  const AppBackButtonAppBarLeading({
    super.key,
    required this.onTap,
    this.leftPadding = 12,
  });

  static const double leadingWidth = 60;

  final VoidCallback onTap;
  final double leftPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding),
      child: Align(
        alignment: Alignment.centerLeft,
        child: AppBackButton(onTap: onTap),
      ),
    );
  }
}

class AppHeaderBar extends StatelessWidget {
  const AppHeaderBar({
    super.key,
    required this.onBack,
    this.title,
    this.titleStyle,
    this.trailing,
    this.horizontalPadding = 24,
  });

  final VoidCallback onBack;
  final String? title;
  final TextStyle? titleStyle;
  final Widget? trailing;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final hasTitle = title != null && title!.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: SizedBox(
        height: 44,
        child: Row(
          children: [
            AppBackButton(onTap: onBack),
            if (hasTitle)
              Expanded(
                child: Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: titleStyle,
                ),
              )
            else
              const Spacer(),
            SizedBox(
              width: 44,
              height: 44,
              child: trailing ?? const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

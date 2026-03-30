import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Ishari brand icon — open book with 5 stars.
///
/// [variant] controls which asset is loaded:
/// - [BookLogoVariant.dark] — dark (#111) background with lime book (default).
/// - [BookLogoVariant.white] — white background with dark stars & lime book.
enum BookLogoVariant { dark, white }

class BookLogoWidget extends StatelessWidget {
  const BookLogoWidget({
    super.key,
    this.size = 120,
    this.variant = BookLogoVariant.dark,
  });

  final double size;
  final BookLogoVariant variant;

  String get _asset => switch (variant) {
        BookLogoVariant.dark => 'assets/icons/ishari_icon_dark.svg',
        BookLogoVariant.white => 'assets/icons/ishari_icon_white.svg',
      };

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _asset,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}

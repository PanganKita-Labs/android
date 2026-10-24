import 'package:flutter/material.dart';

const _defaultIconSize = 22.0;

/// Rasterized SVG symbol from the supplied HTML, kept sharp at four times size.
class ReferenceIcon extends StatelessWidget {
  /// Creates one of the reference's named symbols.
  const new(this.name, {this.size = _defaultIconSize, this.color, super.key});

  /// Symbol identifier in the HTML sprite.
  final String name;

  /// Logical icon size.
  final double size;

  /// Optional monochrome tint; otherwise uses the surrounding icon theme.
  final Color? color;

  @override
  Widget build(BuildContext context) => Center(
    widthFactor: 1,
    heightFactor: 1,
    child: SizedBox.square(
      dimension: size,
      child: Image.asset(
        'assets/prototype/icon-$name.png',
        color: color ?? IconTheme.of(context).color,
        excludeFromSemantics: true,
      ),
    ),
  );
}

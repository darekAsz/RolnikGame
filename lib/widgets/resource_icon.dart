import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Renderuje ikonę spod ścieżki assets/icons/... - większość to płaskie
/// ikony SVG, ale niektóre surowce (patrz ResourceType.assetPath) mają już
/// gotowe obrazki PNG w stylu "szklanej kulki" (docs/midjourney_prompts.md
/// sekcja A8). Dobiera właściwy widget na podstawie rozszerzenia pliku, żeby
/// wywołujący kod nie musiał się tym przejmować.
Widget resourceIconAsset(String assetPath, {double? size}) {
  if (assetPath.endsWith('.png')) {
    return Image.asset(assetPath, width: size, height: size, fit: BoxFit.contain);
  }
  return SvgPicture.asset(assetPath, width: size, height: size);
}

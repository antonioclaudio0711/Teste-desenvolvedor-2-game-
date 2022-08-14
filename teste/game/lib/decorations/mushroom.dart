import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:game/decorations/decoration_sprite_sheet.dart';
import 'package:game/hero/hero.dart';
import 'package:game/main.dart';

class Mushroom extends GameDecoration with Lighting, Sensor {
  Mushroom(Vector2 position)
      : super.withSprite(
          sprite: DecorationSpriteSheet.mushroom,
          position: position,
          size: Vector2(16, 16),
        ) {
    setupLighting(
      LightingConfig(
        radius: tilesize,
        color: Colors.green,
        withPulse: true,
        pulseVariation: 0.3,
      ),
    );
  }

  @override
  void onContact(GameComponent component) {
    if (component is GameHero) {
      (component).addLife(20);
      removeFromParent();
    }
  }
}

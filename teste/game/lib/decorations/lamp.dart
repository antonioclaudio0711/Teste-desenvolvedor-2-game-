import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:game/main.dart';

class Lamp extends GameDecoration with Lighting {
  Lamp(Vector2 position)
      : super(
          position: position,
          size: Vector2(tilesize, tilesize),
        ) {
    setupLighting(
      LightingConfig(
        radius: tilesize * 2,
        color: Colors.orange.withOpacity(0.2),
        withPulse: true,
        pulseVariation: 0.3,
      ),
    );
  }
}

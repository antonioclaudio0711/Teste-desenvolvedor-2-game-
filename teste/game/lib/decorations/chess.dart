import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:game/decorations/decoration_sprite_sheet.dart';
import 'package:game/hero/hero.dart';
import 'package:game/main.dart';

class Chess extends GameDecoration with ObjectCollision {
  bool _playerIsClose = false;

  Sprite? chess, chessOpen;

  Chess(Vector2 position)
      : super.withSprite(
          sprite: DecorationSpriteSheet.chess,
          position: position,
          size: Vector2(16, 32),
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(16, 15),
            align: Vector2(0, 14),
          )
        ],
      ),
    );
  }

  @override
  void update(double dt) {
    seeComponentType<GameHero>(
      observed: (player) {
        if (!_playerIsClose) {
          _playerIsClose = true;
        }
      },
      notObserved: () {
        _playerIsClose = false;
      },
      radiusVision: tilesize,
    );
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    if (_playerIsClose) {
      sprite = chessOpen;
    } else {
      sprite = chess;
    }
    super.render(canvas);
  }

  @override
  Future<void> onLoad() async {
    chess = await DecorationSpriteSheet.chess;
    chessOpen = await DecorationSpriteSheet.chessOpen;
    return super.onLoad();
  }
}

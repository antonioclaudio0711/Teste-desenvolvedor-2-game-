import 'package:bonfire/bonfire.dart';
import 'package:game/game_sprite_sheet.dart';

class GameHero extends SimplePlayer with ObjectCollision {
  GameHero(Vector2 position)
      : super(
          position: position,
          animation: SimpleDirectionAnimation(
            idleRight: GameSpriteSheet.heroIdleRight,
            idleLeft: GameSpriteSheet.heroIdleLeft,
            runRight: GameSpriteSheet.heroRunRight,
            runLeft: GameSpriteSheet.heroRunLeft,
          ),
          size: Vector2(55, 55),
          speed: 80,
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(35, 35),
            align: Vector2(12, 18),
          )
        ],
      ),
    );
  }
}

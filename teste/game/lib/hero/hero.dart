import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/main.dart';
import 'package:game/hero/player_sprite_sheet.dart';

class GameHero extends SimplePlayer with ObjectCollision, Lighting {
  bool canMove = true;

  GameHero(Vector2 position)
      : super(
          position: position,
          animation: SimpleDirectionAnimation(
            idleRight: PlayerSpriteSheet.heroIdleRight,
            idleLeft: PlayerSpriteSheet.heroIdleLeft,
            runRight: PlayerSpriteSheet.heroRunRight,
            runLeft: PlayerSpriteSheet.heroRunLeft,
          ),
          size: Vector2(25, 25),
          speed: 50,
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(15, 14),
            align: Vector2(5, 9),
          )
        ],
      ),
    );

    setupLighting(
      LightingConfig(
        radius: tilesize * 2,
        color: Colors.transparent,
      ),
    );
  }

  @override
  void joystickAction(JoystickActionEvent event) {
    if (event.event == ActionEvent.DOWN &&
        (event.id == 1 || event.id == LogicalKeyboardKey.space.keyId)) {
      _executeAttack();
    }
    super.joystickAction(event);
  }

  @override
  void joystickChangeDirectional(JoystickDirectionalEvent event) {
    if (canMove) {
      super.joystickChangeDirectional(event);
    }
  }

  void _executeAttack() {
    simpleAttackMelee(
      damage: 20,
      size: Vector2(tilesize * 0.8, tilesize * 0.8),
      sizePush: tilesize / 2,
      animationLeft: PlayerSpriteSheet.atackLeft,
      animationRight: PlayerSpriteSheet.atackRight,
      animationDown: PlayerSpriteSheet.atackBottom,
      animationUp: PlayerSpriteSheet.atackTop,
    );
  }

  @override
  void receiveDamage(AttackFromEnum attacker, double damage, identify) {
    canMove = false;
    if (lastDirectionHorizontal == Direction.left) {
      animation?.playOnce(
        PlayerSpriteSheet.heroReceiveDamageLeft,
        runToTheEnd: true,
        onFinish: () {
          canMove = true;
        },
      );
    } else {
      animation?.playOnce(
        PlayerSpriteSheet.heroReceiveDamageRight,
        runToTheEnd: true,
        onFinish: () {
          canMove = true;
        },
      );
    }
    super.receiveDamage(attacker, damage, identify);
  }

  @override
  void die() {
    if (lastDirectionHorizontal == Direction.left) {
      animation?.playOnce(
        PlayerSpriteSheet.heroDieLeft,
        runToTheEnd: true,
        onFinish: () {
          removeFromParent();
        },
      );
    } else {
      animation?.playOnce(
        PlayerSpriteSheet.heroDieRight,
        runToTheEnd: true,
        onFinish: () {
          removeFromParent();
        },
      );
    }
    super.die();
  }
}

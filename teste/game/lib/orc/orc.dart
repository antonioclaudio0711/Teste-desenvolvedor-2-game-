import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:game/main.dart';
import 'package:game/orc/orc_sprite_sheet.dart';

class Orc extends SimpleEnemy with ObjectCollision, AutomaticRandomMovement {
  bool canMove = true;

  Orc(Vector2 position)
      : super(
          position: position,
          animation: SimpleDirectionAnimation(
            idleRight: OrcSpriteSheet.orcIdleRight,
            idleLeft: OrcSpriteSheet.orcIdleLeft,
            runRight: OrcSpriteSheet.orcRunRight,
            runLeft: OrcSpriteSheet.orcRunLeft,
          ),
          size: Vector2(25, 25),
          speed: 30,
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
  }

  @override
  void update(double dt) {
    if (canMove) {
      seePlayer(
        observed: (player) {
          seeAndMoveToPlayer(
            closePlayer: (player) {
              _executeAttack();
            },
            radiusVision: tilesize * 3,
            margin: 4,
          );
        },
        notObserved: () {
          runRandomMovement(
            dt,
            timeKeepStopped: 1000,
          );
        },
        radiusVision: tilesize * 2,
      );
    }

    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    drawDefaultLifeBar(
      canvas,
      borderRadius: const BorderRadius.all(
        Radius.circular(5),
      ),
      borderWidth: 2,
      height: 2,
      align: const Offset(0, -5),
    );
    super.render(canvas);
  }

  @override
  void die() {
    if (lastDirectionHorizontal == Direction.left) {
      animation?.playOnce(
        OrcSpriteSheet.orcDieLeft,
        runToTheEnd: true,
        onFinish: () {
          removeFromParent();
        },
      );
    } else {
      animation?.playOnce(
        OrcSpriteSheet.orcDieRight,
        runToTheEnd: true,
        onFinish: () {
          removeFromParent();
        },
      );
    }
    super.die();
  }

  @override
  void receiveDamage(AttackFromEnum attacker, double damage, identify) {
    canMove = false;
    if (lastDirectionHorizontal == Direction.left) {
      animation?.playOnce(
        OrcSpriteSheet.orcReceiveDamageLeft,
        runToTheEnd: true,
        onFinish: () {
          canMove = true;
        },
      );
    } else {
      animation?.playOnce(
        OrcSpriteSheet.orcReceiveDamageRight,
        runToTheEnd: true,
        onFinish: () {
          canMove = true;
        },
      );
    }
    super.receiveDamage(attacker, damage, identify);
  }

  void _executeAttack() {
    simpleAttackMelee(
      damage: 20,
      size: Vector2(tilesize * 0.8, tilesize * 0.8),
      sizePush: tilesize / 2,
      animationLeft: OrcSpriteSheet.atackBottom,
      animationRight: OrcSpriteSheet.atackRight,
      animationDown: OrcSpriteSheet.atackBottom,
      animationUp: OrcSpriteSheet.atackTop,
    );
  }
}

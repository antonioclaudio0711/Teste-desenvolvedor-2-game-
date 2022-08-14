import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/main.dart';
import 'package:game/hero/player_sprite_sheet.dart';

class GameHero extends SimplePlayer with ObjectCollision, Lighting, TapGesture {
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
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          content: Text(
              'Infelizmente perdemos para os nossos adversários. Tente novamente!'),
        );
      },
    );
    super.die();
  }

  @override
  void onTap() {
    TalkDialog.show(
      context,
      [
        Say(
          text: [
            const TextSpan(
                text:
                    'Seja bem-vindo(a) ao teste técnico 02 do candidato Antônio Claudio! Ajude o nosso herói a derrotar os 11 inimigos presentes no cenário. Uma dica: os cogumelos são uma boa forma de conseguir alcançar o nosso objetivo! Espero que além de atingir os requisitos propostos pelo teste, eu consiga te divertir um pouco!'),
          ],
          person: SizedBox(
            height: 100,
            width: 100,
            child: PlayerSpriteSheet.heroIdleRight.asWidget(),
          ),
          speed: 1,
        ),
      ],
    );
  }
}

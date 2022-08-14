import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:game/decorations/chess.dart';
import 'package:game/decorations/lamp.dart';
import 'package:game/decorations/mushroom.dart';
import 'package:game/hero/hero.dart';
import 'package:game/interface/player_interface.dart';
import 'package:game/orc/orc.dart';

final double tilesize = 16;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teste técnico 02',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> implements GameListener {
  late GameController controller;
  @override
  void initState() {
    controller = GameController()..addListener(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BonfireTiledWidget(
      gameController: controller,
      joystick: Joystick(
          keyboardConfig: KeyboardConfig(
            keyboardDirectionalType: KeyboardDirectionalType.wasdAndArrows,
          ),
          directional: JoystickDirectional(
            color: const Color.fromARGB(255, 145, 227, 238),
          ),
          actions: [
            JoystickAction(
              actionId: 1,
              color: const Color.fromARGB(255, 145, 227, 238),
              margin: const EdgeInsets.only(
                right: 100,
                bottom: 70,
              ),
            )
          ]),
      map: TiledWorldMap('map/island.tmj', objectsBuilder: {
        'orc': (properties) => Orc(properties.position),
        'lamp': (properties) => Lamp(properties.position),
        'chess': (properties) => Chess(properties.position),
        'mushroom': (properties) => Mushroom(properties.position),
      }),
      player: GameHero(
        Vector2(4 * tilesize, 3 * tilesize),
      ),
      overlayBuilderMap: {
        'playerInterface': (context, game) => PlayerInterface(
              game: game,
            )
      },
      initialActiveOverlays: const [
        PlayerInterface.overlayKey,
      ],
      cameraConfig: CameraConfig(
        moveOnlyMapArea: true,
        zoom: 2.7,
      ),
      lightingColorGame: Colors.black.withOpacity(0.3),
    );
  }

  @override
  void changeCountLiveEnemies(int count) {
    if (count == 0) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text(
                'Parabéns, você conseguiu derrotar todos os seus inimigos!'),
          );
        },
      );
    }
  }

  @override
  void updateGame() {}
}

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:game/hero.dart';

final double tilesize = 32;

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

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BonfireTiledWidget(
      joystick: Joystick(
        directional: JoystickDirectional(
          color: const Color.fromARGB(255, 236, 106, 82),
        ),
      ),
      map: TiledWorldMap(
        'map/island.tmj',
        forceTileSize: Size(tilesize, tilesize),
      ),
      player: GameHero(
        Vector2(11 * tilesize, 9 * tilesize),
      ),
    );
  }
}

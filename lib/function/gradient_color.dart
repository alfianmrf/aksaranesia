import 'dart:math';
import 'package:flutter/material.dart';

List gradientColor = [
	[
		Color(0xFF3494E6),
		Color(0xFFEC6EAD),
	],
	[
		Color(0xFF67B26F),
		Color(0xFF4ca2cd),
	],
	[
		Color(0xFFF3904F),
		Color(0xFF3B4371),
	],
  [
    Color(0xFFee0979),
    Color(0xFFff6a00),
  ],
  [
    Color(0xFF41295a),
    Color(0xFF2F0743),
  ],
  [
    Color(0xFF3a6186),
    Color(0xFF89253e),
  ]
];

List<Color> getGradient() {
  var random = new Random();
  return gradientColor[random.nextInt(5)];
}
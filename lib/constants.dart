// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Base URL of the API, read from assets/.env.
var host = dotenv.env['HOST'];

// The avatar the API serves for any username.
String avatarUrl(String username) => '$host/icon/$username/128';

// 🐾 Pawbook - Pet Social Media Color Palette
const Color FB_PRIMARY = Color(0xFFFF8C42); // Warm playful orange
const Color FB_SECONARY = Color(0xFFFFB347); // Golden retriever amber
const Color FB_DARK_PRIMARY = Color(0xFF6B4226); // Chocolate fur brown
const Color FB_LIGHT_PRIMARY = Color(0xFFFFF4E6); // Cream/vanilla coat
const Color FB_TEXT_COLOR_WHITE = Color(0xFFFFFBF5); // Soft white fur
const Color FB_TEXT_COLOR_GREY = Color(0xFFAD8B73); // Warm taupe grey
const Color FB_TEXT_COLOR_DARKGREY = Color(0xFF5C4033); // Dark brown text
const Color FB_ACCENT = Color(0xFFE85D04); // Energetic orange accent
const Color FB_SUCCESS = Color(0xFF4CAF50); // Happy green (treats!)
const Color FB_ERROR = Color(0xFFE57373); // Soft coral red

// Brand text colour that stays readable on both themes.
Color brandColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
    ? FB_SECONARY
    : FB_DARK_PRIMARY;

// App name
const String APP_NAME = 'Pawbook';

import 'package:favorite_places/routes/pages.dart';
import 'package:favorite_places/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 102, 6, 247),
  background: const Color.fromARGB(255, 56, 49, 66),
);

final theme = ThemeData().copyWith(
  scaffoldBackgroundColor: colorScheme.background,
  colorScheme: colorScheme,
  textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
    titleSmall: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    titleMedium: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    titleLarge: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
);

void main() async {
  await GetStorage.init();
  runApp(
    GetMaterialApp(
      title: 'Great Places',
      debugShowCheckedModeBanner: false,
      theme: theme,
      initialRoute: Pages.home,
      getPages: Routes.pages,
    ),
  );
}

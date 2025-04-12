import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:mypost/common/hive_constants.dart';
import 'package:mypost/data/entity/quote_entity/quote_entity.dart';
import 'package:mypost/data/entity/user_entity/user_entity.dart';
import 'package:mypost/globals.dart';
import 'package:mypost/logic/create_post_cubit/create_post_cubit.dart';
import 'package:mypost/logic/image_cubit/image_cubit.dart';
import 'package:mypost/logic/profile_cubit/profile_cubit.dart';
import 'package:mypost/logic/quote_cubit/fetch_quotes_cubit.dart';
import 'package:mypost/logic/toggle_cubit/toggle_cubit.dart';
import 'package:mypost/presentation/screens/home_screen.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initThings();
  runApp(MyApp());
}

Future<void> initThings() async {
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive
    ..init(appDocumentDirectory.path)
    ..registerAdapter(QuoteEntityAdapter())
    ..registerAdapter(UserEntityAdapter());
  await Hive.openBox(HiveConstants.QUOTES_DATA);
  quotesBox = Hive.box(HiveConstants.QUOTES_DATA);

  quotesDataList = List<QuoteEntity>.from(
    await quotesBox.get(HiveConstants.QUOTES_DATA) ?? [],
  );
  await Hive.openBox(HiveConstants.USER_DATA);
  userBox = Hive.box(HiveConstants.USER_DATA);
  userProfileData = userBox.get(HiveConstants.USER_DATA);
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FetchQuotesCubit()),
        BlocProvider(create: (_) => ImageCubit()),
        BlocProvider(create: (_) => ProfileCubit()),
        BlocProvider(create: (_) => CreatePostCubit()),
        BlocProvider(create: (_) => ToggleCubit()),
      ],
      child: MaterialApp(
        theme: lightTheme,
        // darkTheme: darkTheme,
        themeMode: ThemeMode.system, // or .dark / .light
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }

  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF8E24AA), // Deep purple
    scaffoldBackgroundColor: Color(0xFF121212), // Dark background
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF4A148C), // Dark purple
      foregroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    cardColor: Color(0xFF1E1E1E), // Dark gray for cards
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFFFC107), // Still poppy!
      foregroundColor: Colors.black,
    ),
    iconTheme: IconThemeData(color: Color(0xFF81C784)), // Soft green
    textTheme: TextTheme(
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(0xFFBA68C8),
      brightness: Brightness.dark,
    ),
  );

  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFFBA68C8), // Lavender
    scaffoldBackgroundColor: Color(0xFFF3E5F5), // Soft lilac
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFFBA68C8),
      foregroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    listTileTheme: ListTileThemeData(
      textColor: Colors.black,
      selectedColor: Colors.blueAccent,
      selectedTileColor: Colors.red,
    ),
    cardColor: Color(0xFFB3E5FC),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFFFC107), // Amber
      foregroundColor: Colors.black,
    ),
    iconTheme: IconThemeData(color: Color(0xFF4CAF50)), // Fresh green
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: Color(0xFF4A148C),
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFBA68C8)),
  );
}

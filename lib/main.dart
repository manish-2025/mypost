import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:mypost/common/hive_constants.dart';
import 'package:mypost/data/entity/quote_entity.dart';
import 'package:mypost/globals.dart';
import 'package:mypost/logic/cubit/fetch_quotes_cubit.dart';
import 'package:mypost/presentation/screens/home_screen.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initThings();
  runApp(const MyApp());
}

Future<void> initThings() async {
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive
    ..init(appDocumentDirectory.path)
    ..registerAdapter(QuoteEntityAdapter());
  await Hive.openBox(HiveConstants.QUOTES_DATA);
  quotesBox = Hive.box(HiveConstants.QUOTES_DATA);
  quotesDataList = List<QuoteEntity>.from(
    await quotesBox.get(HiveConstants.QUOTES_DATA) ?? [],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => FetchQuotesCubit(),
        child: HomeScreen(),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'home_page.dart';

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Expenses',
      theme: ThemeData(
        fontFamily: 'Quicksand',
        // primarySwatch: Colors.blueGrey,
        // colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.green),
				colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: const TextTheme(
          bodySmall: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 14,
          ),
					bodyMedium: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 18,
          ),
					bodyLarge: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 22,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

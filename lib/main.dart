import 'package:cashbook/core/providers/theme_provider.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/features/main_app/presentation/page/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ModelTheme(),
      child: Consumer<ModelTheme>(
          builder: (context, ModelTheme themeNotifier, child) {
            return MaterialApp(
      home: const Home(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeNotifier.isDark ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
    );}))
  );
}

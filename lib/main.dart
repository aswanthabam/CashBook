import 'package:cashbook/core/datasource/local/database.dart';
import 'package:cashbook/core/providers/theme_provider.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/features/main_app/data/datasource/expense_local_datasource.dart';
import 'package:cashbook/features/main_app/data/repository/expense_repository_implementation.dart';
import 'package:cashbook/features/main_app/domain/uscases/expense_add_usecase.dart';
import 'package:cashbook/features/main_app/domain/uscases/expense_history_usecase.dart';
import 'package:cashbook/features/main_app/presentation/bloc/expense_bloc.dart';
import 'package:cashbook/features/main_app/presentation/page/history.dart';
import 'package:cashbook/features/main_app/presentation/page/home.dart';
import 'package:cashbook/features/settings/presentation/page/settings.dart';
import 'package:cashbook/features/splash_screen/presentation/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppDatabase database = await AppDatabase.create();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ExpenseBloc>(
          create: (context) => ExpenseBloc(
                expenseHistoryUseCase: ExpenseDataUseCase(
                  ExpenseRepositoryImplementation(
                    datasource: ExpenseLocalDatasourceImplementation(database),
                  ),
                ),
                expenseAddUseCase: ExpenseAddUseCase(
                  ExpenseRepositoryImplementation(
                    datasource: ExpenseLocalDatasourceImplementation(database),
                  ),
                ),
              )),
    ],
    child: ChangeNotifierProvider(
        create: (_) => ModelTheme(),
        child: Consumer<ModelTheme>(
            builder: (context, ModelTheme themeNotifier, child) {
          return MaterialApp(
            // home: const Home(),
            routes: {
              'home': (context) => const Home(),
              'splash_screen': (context) => const SplashScreen(),
              'settings': (context) => const Settings(),
              'history': (context) => const History()
            },
            initialRoute: "splash_screen",
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeNotifier.isDark ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
          );
        })),
  ));
}

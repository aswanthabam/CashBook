import 'package:cashbook/core/bloc/theme/theme_bloc.dart';
import 'package:cashbook/core/datasource/local/database.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/features/main_app/data/datasource/expense_local_datasource.dart';
import 'package:cashbook/features/main_app/data/datasource/tag_local_database.dart';
import 'package:cashbook/features/main_app/data/repository/expense_repository_implementation.dart';
import 'package:cashbook/features/main_app/data/repository/tag_repository_implementation.dart';
import 'package:cashbook/features/main_app/domain/uscases/expense_add_usecase.dart';
import 'package:cashbook/features/main_app/domain/uscases/expense_edit_usecase.dart';
import 'package:cashbook/features/main_app/domain/uscases/expense_history_usecase.dart';
import 'package:cashbook/features/main_app/domain/uscases/tag_create_usecase.dart';
import 'package:cashbook/features/main_app/domain/uscases/tag_list_usecase.dart';
import 'package:cashbook/features/main_app/presentation/bloc/expense/expense_bloc.dart';
import 'package:cashbook/features/main_app/presentation/bloc/tag/tag_bloc.dart';
import 'package:cashbook/features/main_app/presentation/page/history.dart';
import 'package:cashbook/features/main_app/presentation/page/home.dart';
import 'package:cashbook/features/settings/presentation/page/settings.dart';
import 'package:cashbook/features/splash_screen/presentation/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppDatabase database = await AppDatabase.create();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ThemeBloc>(
        create: (context) => ThemeBloc(),
      ),
      BlocProvider<TagBloc>(
        create: (context) => TagBloc(
          tagCreateUseCase: TagCreateUseCase(
            TagRepositoryImplementation(
              TagLocalDatabaseImplementation(database),
            ),
          ),
          tagListUseCase: TagListUseCase(
            TagRepositoryImplementation(
              TagLocalDatabaseImplementation(database),
            ),
          ),
        ),
      ),
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
                expenseEditUseCase: ExpenseEditUseCase(
                  ExpenseRepositoryImplementation(
                    datasource: ExpenseLocalDatasourceImplementation(database),
                  ),
                ),
              )),
    ],
    child: BlocConsumer<ThemeBloc, ThemeState>(
      listener: (context, state) {},
      builder: (context, state) {
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
          themeMode: state.isDark ? ThemeMode.dark : ThemeMode.light,
          debugShowCheckedModeBanner: false,
        );
      },
    ),
  ));
}

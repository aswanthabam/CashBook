import 'package:cashbook/core/bloc/theme/theme_bloc.dart';
import 'package:cashbook/core/datasource/local/database.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/data/datasource/expense_local_datasource.dart';
import 'package:cashbook/data/datasource/tag_local_database.dart';
import 'package:cashbook/data/repository/expense_history_implementation.dart';
import 'package:cashbook/data/repository/expense_repository_implementation.dart';
import 'package:cashbook/data/repository/tag_repository_implementation.dart';
import 'package:cashbook/features/history/data/repository/search_repository_implementation.dart';
import 'package:cashbook/features/history/domain/usecase/SearchUsecase.dart';
import 'package:cashbook/features/history/presentation/page/history.dart';
import 'package:cashbook/features/history/presentation/page/history/history_bloc.dart';
import 'package:cashbook/features/home/domain/uscases/expense_add_usecase.dart';
import 'package:cashbook/features/home/domain/uscases/expense_edit_usecase.dart';
import 'package:cashbook/features/home/domain/uscases/expense_history_usecase.dart';
import 'package:cashbook/features/home/domain/uscases/expense_total_data_usecase.dart';
import 'package:cashbook/features/home/domain/uscases/tag_create_usecase.dart';
import 'package:cashbook/features/home/domain/uscases/tag_list_usecase.dart';
import 'package:cashbook/features/home/presentation/bloc/expense/expense_bloc.dart';
import 'package:cashbook/features/home/presentation/bloc/expense_history/expense_history_bloc.dart';
import 'package:cashbook/features/home/presentation/bloc/tag/tag_bloc.dart';
import 'package:cashbook/features/home/presentation/page/home.dart';
import 'package:cashbook/features/settings/presentation/page/settings.dart';
import 'package:cashbook/features/splash_screen/presentation/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppDatabase database = await AppDatabase.create();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<HistoryBloc>(
        create: (context) => HistoryBloc(
          expenseHistoryUseCase: ExpenseHistoryUseCase(
            repository: ExpenseHistoryRepositoryImplementation(
              ExpenseLocalDatasourceImplementation(database),
            ),
          ),
          searchUseCase: SearchUseCase(
            repository: SearchRepositoryImplementation(
              datasource: ExpenseLocalDatasourceImplementation(database),
            ),
          ),
        ),
      ),
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
      BlocProvider<ExpenseHistoryBloc>(
          create: (context) => ExpenseHistoryBloc(
                  expenseHistoryUseCase: ExpenseHistoryUseCase(
                repository: ExpenseHistoryRepositoryImplementation(
                  ExpenseLocalDatasourceImplementation(database),
                ),
              ))),
      BlocProvider<ExpenseBloc>(
          create: (context) => ExpenseBloc(
                expenseTotalDataUseCase: ExpenseTotalDataUseCase(
                  repository: ExpenseRepositoryImplementation(
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

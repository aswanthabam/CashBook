import 'package:cashbook/bloc/expense/expense_bloc.dart';
import 'package:cashbook/bloc/tag/tag_bloc.dart';
import 'package:cashbook/core/bloc/theme/theme_bloc.dart';
import 'package:cashbook/core/datasource/local/database.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/data/datasource/asset_local_datasource.dart';
import 'package:cashbook/data/datasource/expense_local_datasource.dart';
import 'package:cashbook/data/datasource/liability_local_datasource.dart';
import 'package:cashbook/data/datasource/tag_local_database.dart';
import 'package:cashbook/data/repository/assets_repository_implementation.dart';
import 'package:cashbook/data/repository/expense_history_implementation.dart';
import 'package:cashbook/data/repository/expense_repository_implementation.dart';
import 'package:cashbook/data/repository/liability_repository_implementation.dart';
import 'package:cashbook/data/repository/tag_repository_implementation.dart';
import 'package:cashbook/features/assets_liability/domain/usecases/assets_list_usecase.dart';
import 'package:cashbook/features/assets_liability/domain/usecases/liability_list_usecase.dart';
import 'package:cashbook/features/assets_liability/domain/usecases/liability_payouts_usecase.dart';
import 'package:cashbook/features/assets_liability/presentation/bloc/assets/assets_list_bloc.dart';
import 'package:cashbook/features/assets_liability/presentation/bloc/liability/liability_list_bloc.dart';
import 'package:cashbook/features/assets_liability/presentation/pages/assets_liability.dart';
import 'package:cashbook/features/create/domain/usecases/create_asset_usecase.dart';
import 'package:cashbook/features/create/domain/usecases/create_liability_usecase.dart';
import 'package:cashbook/features/create/domain/usecases/edit_liability_payment.dart';
import 'package:cashbook/features/create/domain/usecases/edit_liability_usecase.dart';
import 'package:cashbook/features/create/domain/usecases/expense_add_usecase.dart';
import 'package:cashbook/features/create/domain/usecases/expense_edit_usecase.dart';
import 'package:cashbook/features/create/domain/usecases/get_liability_usecase.dart';
import 'package:cashbook/features/create/domain/usecases/pay_liablity_usecase.dart';
import 'package:cashbook/features/create/domain/usecases/tag_create_usecase.dart';
import 'package:cashbook/features/create/presentation/bloc/assets/assets_bloc.dart';
import 'package:cashbook/features/create/presentation/bloc/liability/liability_bloc.dart';
import 'package:cashbook/features/history/data/repository/search_repository_implementation.dart';
import 'package:cashbook/features/history/domain/usecase/SearchUsecase.dart';
import 'package:cashbook/features/history/presentation/page/history.dart';
import 'package:cashbook/features/history/presentation/page/history/history_bloc.dart';
import 'package:cashbook/features/home/domain/uscases/expense_history_usecase.dart';
import 'package:cashbook/features/home/domain/uscases/expense_total_data_usecase.dart';
import 'package:cashbook/features/home/domain/uscases/tag_list_usecase.dart';
import 'package:cashbook/features/home/presentation/bloc/expense_history/expense_history_bloc.dart';
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
      BlocProvider<LiabilityListBloc>(
        create: (context) => LiabilityListBloc(
            liabilityListUseCase: LiabilityListUseCase(
              repository: LiabilityRepositoryImplementation(
                datasource:
                    LiabilityLocalDataSourceImplementation(database: database),
              ),
            ),
            liabilityPayoutsUseCase: LiabilityPayoutsUseCase(
              repository: LiabilityRepositoryImplementation(
                datasource:
                    LiabilityLocalDataSourceImplementation(database: database),
              ),
            )),
      ),
      BlocProvider<LiabilityBloc>(
        create: (context) => LiabilityBloc(
            editLiabilityUseCase: EditLiabilityUseCase(
                repository: LiabilityRepositoryImplementation(
                    datasource: LiabilityLocalDataSourceImplementation(
                        database: database))),
            createLiabilityUseCase: CreateLiabilityUseCase(
              repository: LiabilityRepositoryImplementation(
                datasource:
                    LiabilityLocalDataSourceImplementation(database: database),
              ),
            ),
            payLiabilityUseCase: PayLiabilityUseCase(
              repository: LiabilityRepositoryImplementation(
                datasource:
                    LiabilityLocalDataSourceImplementation(database: database),
              ),
            ),
            editLiabilityPaymentUseCase: EditLiabilityPaymentUseCase(
              repository: LiabilityRepositoryImplementation(
                datasource:
                    LiabilityLocalDataSourceImplementation(database: database),
              ),
            ),
            getLiabilityUseCase: GetLiabilityUseCase(
              repository: LiabilityRepositoryImplementation(
                datasource:
                    LiabilityLocalDataSourceImplementation(database: database),
              ),
            )),
      ),
      BlocProvider<AssetsListBloc>(
        create: (context) => AssetsListBloc(
            assetsListUseCase: AssetsListUseCase(
          repository: AssetsRepositoryImplementation(
            assetsDataSource:
                AssetLocalDataSourceImplementation(database: database),
          ),
        )),
      ),
      BlocProvider<AssetsBloc>(
          create: (context) => AssetsBloc(
                assetCreateUseCase: CreateAssetUseCase(
                  repository: AssetsRepositoryImplementation(
                    assetsDataSource:
                        AssetLocalDataSourceImplementation(database: database),
                  ),
                ),
              )),
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
            'history': (context) => const History(),
            'assets_liability': (context) => const AssetsLiabilityPage(),
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

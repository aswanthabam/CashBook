import 'dart:io';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/core/datasource/local/database.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/core/utils/permissions.dart';
import 'package:cashbook/core/widgets/appbar/bottom_bar.dart';
import 'package:cashbook/core/widgets/appbar/main_appbar.dart';
import 'package:cashbook/core/widgets/buttons/full_size_button.dart';
import 'package:cashbook/data/datasource/asset_local_datasource.dart';
import 'package:cashbook/data/datasource/expense_local_datasource.dart';
import 'package:cashbook/data/datasource/liability_local_datasource.dart';
import 'package:cashbook/data/models/asset.dart';
import 'package:cashbook/data/models/expense.dart';
import 'package:cashbook/data/models/liability.dart';
import 'package:cashbook/data/repository/assets_repository_implementation.dart';
import 'package:cashbook/data/repository/expense_repository_implementation.dart';
import 'package:cashbook/data/repository/liability_repository_implementation.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:share_extend/share_extend.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late ExpenseRepositoryImplementation _expenseRepositoryImplementation;
  late LiabilityRepositoryImplementation _liabilityRepositoryImplementation;
  late AssetsRepositoryImplementation _assetsRepositoryImplementation;

  Future<File?> savedFile(String name, List<int> bytes) async {
    String directory;
    if (Platform.isIOS) {
      var dir = (await getDownloadsDirectory());
      if (dir == null) {
        Fluttertoast.showToast(msg: 'Failed to get downloads directory');
        return null;
      }
      directory = dir.path;
    } else {
      directory = "/storage/emulated/0/Download/";

      var dirDownloadExists = Directory(directory).existsSync();
      if (dirDownloadExists) {
        directory = "/storage/emulated/0/Download/";
      } else {
        directory = "/storage/emulated/0/Downloads/";
      }
    }
    var path = '$directory/$name';
    File file = File(path);
    file.writeAsBytesSync(bytes);
    if (!file.existsSync()) {
      Fluttertoast.showToast(msg: 'Failed to save file');
      return null;
    }
    Fluttertoast.showToast(msg: 'File saved to: $path');
    return file;
  }

  Future<File?> _generatePDF() async {
    if (!await requestPermission(Permission.manageExternalStorage) &&
        !await requestPermission(Permission.storage)) {
      Fluttertoast.showToast(msg: "Permission denied");
      return null;
    }
    List<Expense> expenses = await _expenseRepositoryImplementation
        .getExpensesFilter(count: -1, descending: true);
    List<Asset> assets = _assetsRepositoryImplementation.getAssets();
    List<Liability> liabilities =
        _liabilityRepositoryImplementation.getLiabilities();

    pw.Document pdf = pw.Document();
    pdf.addPage(pw.MultiPage(
        build: (pw.Context context) => [
              pw.Header(
                  level: 0,
                  child: pw.Text("Expenses",
                      style: pw.TextStyle(
                          fontSize: 20, fontWeight: pw.FontWeight.bold))),
              pw.TableHelper.fromTextArray(
                  context: context,
                  data: <List<String>>[
                    <String>[
                      'Sl.No',
                      'Name',
                      'Amount',
                      'Date',
                      'Tag',
                      'Description'
                    ],
                    ...expenses.map((e) => [
                          (expenses.indexOf(e) + 1).toString(),
                          e.title,
                          e.amount.toString(),
                          DateFormat('dd-MMM h:m a').format(e.date),
                          e.liability.target == null
                              ? e.tag.target?.title ?? "No Tag"
                              : "Liability",
                          e.liability.target == null
                              ? e.description ?? "No Description"
                              : "Paid for Liability (${e.liability.target?.title})"
                        ])
                  ])
            ]));

    pdf.addPage(pw.MultiPage(
        build: (pw.Context context) => [
              pw.Header(
                  level: 0,
                  child: pw.Text("Assets",
                      style: pw.TextStyle(
                          fontSize: 20, fontWeight: pw.FontWeight.bold))),
              pw.TableHelper.fromTextArray(
                  context: context,
                  data: <List<String>>[
                    <String>['Sl.No', 'Name', 'Amount', 'Description'],
                    ...assets.map((e) => [
                          (assets.indexOf(e) + 1).toString(),
                          e.title,
                          e.worth.toString(),
                          e.description ?? "No Description"
                        ])
                  ])
            ]));

    pdf.addPage(pw.MultiPage(
        build: (pw.Context context) => [
              pw.Header(
                  level: 0,
                  child: pw.Text("Liabilities",
                      style: pw.TextStyle(
                          fontSize: 20, fontWeight: pw.FontWeight.bold))),
              pw.TableHelper.fromTextArray(
                  context: context,
                  data: <List<String>>[
                    <String>[
                      'Sl.No',
                      'Name',
                      'Amount',
                      'Interest Rate',
                      'Start Date',
                      'End Date',
                      'Description'
                    ],
                    ...liabilities.map((e) => [
                          (liabilities.indexOf(e) + 1).toString(),
                          e.title,
                          e.amount.toString(),
                          e.interest.toString(),
                          DateFormat('dd-MMM h:m a').format(e.date),
                          e.endDate == null
                              ? ""
                              : DateFormat('dd-MMM h:m a').format(e.endDate!),
                          e.description ?? "No Description"
                        ])
                  ])
            ]));

    var date = DateTime.now();
    String name =
        'CashBook-Exported-${date.year}${date.month}${date.day}${date.hour}${date.minute}${date.second}.pdf';
    var file = await savedFile(name, await pdf.save());
    return file;
  }

  /*
      * This method is used to generate an excel file with the expenses, assets and liabilities data
  */
  Future<File?> _generateExcel() async {
    if (!await requestPermission(Permission.manageExternalStorage) &&
        !await requestPermission(Permission.storage)) {
      Fluttertoast.showToast(msg: "Permission denied");
      return null;
    }
    List<Expense> expenses = await _expenseRepositoryImplementation
        .getExpensesFilter(count: -1, descending: true);
    List<Asset> assets = _assetsRepositoryImplementation.getAssets();
    List<Liability> liabilities =
        _liabilityRepositoryImplementation.getLiabilities();

    var excel = Excel.createExcel();
    var expenseSheet = excel['Expenses'];
    var assetSheet = excel['Assets'];
    var liabilitySheet = excel['Liabilities'];
    excel['Sheet1'];

    excel.setDefaultSheet('Expenses');
    excel.delete('Sheet1');
    List<TextCellValue> headers = [
      const TextCellValue('Sl.No'),
      const TextCellValue('Name'),
      const TextCellValue('Amount'),
      const TextCellValue('Date'),
      const TextCellValue('Tag'),
      const TextCellValue('Description')
    ];
    expenseSheet.appendRow(headers);
    expenseSheet.row(0).every((element) {
      element?.cellStyle = CellStyle(
          bold: true,
          horizontalAlign: HorizontalAlign.Center,
          verticalAlign: VerticalAlign.Center,
          backgroundColorHex: ExcelColor.fromHexString('#dddddd'));
      return true;
    });

    for (var expense in expenses) {
      List<CellValue> row = [
        IntCellValue((expenses.indexOf(expense) + 1)),
        TextCellValue(expense.title),
        DoubleCellValue(expense.amount),
        DateTimeCellValue(
          day: expense.date.day,
          month: expense.date.month,
          year: expense.date.year,
          hour: expense.date.hour,
          minute: expense.date.minute,
          second: expense.date.second,
        ),
        TextCellValue(expense.liability.target == null
            ? expense.tag.target?.title ?? "No Tag"
            : "Liability"),
        TextCellValue(expense.liability.target == null
            ? expense.description ?? "No Description"
            : "Paid for Liability (${expense.liability.target?.title})")
      ];
      expenseSheet.appendRow(row);
    }

    List<TextCellValue> assetHeaders = [
      const TextCellValue('Sl.No'),
      const TextCellValue('Name'),
      const TextCellValue('Amount'),
      const TextCellValue('Description')
    ];
    assetSheet.appendRow(assetHeaders);
    assetSheet.row(0).every((element) {
      element?.cellStyle = CellStyle(
          bold: true,
          horizontalAlign: HorizontalAlign.Center,
          verticalAlign: VerticalAlign.Center,
          backgroundColorHex: ExcelColor.fromHexString('#dddddd'));
      return true;
    });

    for (var asset in assets) {
      List<CellValue> row = [
        IntCellValue((assets.indexOf(asset) + 1)),
        TextCellValue(asset.title),
        DoubleCellValue(asset.worth),
        TextCellValue(asset.description ?? "No Description")
      ];
      assetSheet.appendRow(row);
    }

    List<TextCellValue> liabilityHeaders = [
      const TextCellValue('Sl.No'),
      const TextCellValue('Name'),
      const TextCellValue('Amount'),
      const TextCellValue('Interest Rate'),
      const TextCellValue("Start Date"),
      const TextCellValue("End Date"),
      const TextCellValue('Description'),
    ];
    liabilitySheet.appendRow(liabilityHeaders);
    liabilitySheet.row(0).every((element) {
      element?.cellStyle = CellStyle(
          bold: true,
          horizontalAlign: HorizontalAlign.Center,
          verticalAlign: VerticalAlign.Center,
          backgroundColorHex: ExcelColor.fromHexString('#dddddd'));
      return true;
    });

    for (var liability in liabilities) {
      List<CellValue> row = [
        IntCellValue((liabilities.indexOf(liability) + 1)),
        TextCellValue(liability.title),
        DoubleCellValue(liability.amount),
        DoubleCellValue(liability.interest),
        DateTimeCellValue(
          day: liability.date.day,
          month: liability.date.month,
          year: liability.date.year,
          hour: liability.date.hour,
          minute: liability.date.minute,
          second: liability.date.second,
        ),
        liability.endDate == null
            ? const TextCellValue('')
            : DateTimeCellValue(
                day: liability.endDate!.day,
                month: liability.endDate!.month,
                year: liability.endDate!.year,
                hour: liability.endDate!.hour,
                minute: liability.endDate!.minute,
                second: liability.endDate!.second,
              ),
        TextCellValue(liability.description ?? "No Description")
      ];
      liabilitySheet.appendRow(row);
    }

    var date = DateTime.now();
    String name =
        'CashBook-Exported-${date.year}${date.month}${date.day}${date.hour}${date.minute}${date.second}.xlsx';
    var bytes = excel.save();
    if (bytes == null) {
      Fluttertoast.showToast(msg: 'Failed to save file');
      return null;
    }
    var file = await savedFile(name, bytes);
    return file;
  }

  @override
  void initState() {
    super.initState();
    _expenseRepositoryImplementation = ExpenseRepositoryImplementation(
        datasource: ExpenseLocalDatasourceImplementation(
      AppDatabase(),
    ));
    _liabilityRepositoryImplementation = LiabilityRepositoryImplementation(
        datasource: LiabilityLocalDataSourceImplementation(
      database: AppDatabase(),
    ));
    _assetsRepositoryImplementation = AssetsRepositoryImplementation(
        assetsDataSource:
            AssetLocalDataSourceImplementation(database: AppDatabase()));
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
        bottomNavigationBar: const BottomBar(),
        body: SingleChildScrollView(
            child: Column(
          children: [
            const MainAppBar(
              title: "Profile",
            ),
            Padding(
              padding: EdgeInsets.all(width * 0.05),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: width * 0.05),
                      child: FullSizeButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.05, vertical: 0),
                          height: height * 0.075,
                          onPressed: () {
                            Navigator.of(context).pushNamed('history');
                          },
                          text: 'Your transactions',
                          leftIcon: BootstrapIcons.clock_history,
                          rightIcon: Icons.chevron_right),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: width * 0.05),
                      child: FullSizeButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.05, vertical: 0),
                          height: height * 0.075,
                          onPressed: () async {
                            var pdf = await _generatePDF();
                            if (pdf != null) {
                              ShareExtend.share(pdf.path, "file");
                            }
                          },
                          text: 'Export to PDF',
                          leftIcon: BootstrapIcons.file_earmark_pdf_fill,
                          rightIcon: Icons.download),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: width * 0.05),
                      child: FullSizeButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.05, vertical: 0),
                          height: height * 0.075,
                          onPressed: () {
                            _generateExcel().then((value) {
                              if (value != null) {
                                ShareExtend.share(value.path, "file");
                              }
                            });
                          },
                          text: 'Export to Excel',
                          leftIcon: BootstrapIcons.table,
                          rightIcon: Icons.download),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: width * 0.05),
                      child: FullSizeButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.05, vertical: 0),
                          height: height * 0.075,
                          textColor: Theme.of(context)
                              .extension<AppColorsExtension>()!
                              .red,
                          iconColor: Theme.of(context)
                              .extension<AppColorsExtension>()!
                              .red,
                          borderColor: Theme.of(context)
                              .extension<AppColorsExtension>()!
                              .red,
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                      child: Padding(
                                        padding: EdgeInsets.all(width * 0.05),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                                "Are you sure you want to erase all data?"),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                TextButton(
                                                    onPressed: () async {
                                                      if (await AppDatabase
                                                          .dropDatabase()) {
                                                        AppDatabase.create();
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Successfully erased all data");
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Failed to erase all data");
                                                      }
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text("Yes, Erase",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .extension<
                                                                    AppColorsExtension>()!
                                                                .red,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700))),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text(
                                                        "No, Cancel")),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ));
                          },
                          text: "Erase all data",
                          leftIcon: BootstrapIcons.eraser,
                          rightIcon: Icons.chevron_right),
                    ),
                  ]),
            ),
          ],
        )));
  }
}

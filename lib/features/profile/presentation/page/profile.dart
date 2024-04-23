import 'dart:io';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/core/datasource/local/database.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/core/widgets/appbar/bottom_bar.dart';
import 'package:cashbook/core/widgets/appbar/main_appbar.dart';
import 'package:cashbook/core/widgets/buttons/full_size_button.dart';
import 'package:cashbook/data/datasource/expense_local_datasource.dart';
import 'package:cashbook/data/models/expense.dart';
import 'package:cashbook/data/repository/expense_repository_implementation.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_extend/share_extend.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late ExpenseRepositoryImplementation _expenseRepositoryImplementation;

  Future<File?> _generatePDF() async {
    List<Expense> expenses = await _expenseRepositoryImplementation
        .getExpensesFilter(count: -1, descending: true);
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
    String path = '$directory/Exported.pdf';
    File file = File(path);
    file.writeAsBytesSync(await pdf.save());
    if (!file.existsSync()) {
      Fluttertoast.showToast(msg: 'Failed to save PDF file');
      return null;
    }
    Fluttertoast.showToast(msg: 'PDF file saved to: $path');
    return file;
  }

  Future<File?> _generateExcel() async {
    List<Expense> expenses = await _expenseRepositoryImplementation
        .getExpensesFilter(count: -1, descending: true);

    var excel = Excel.createExcel();
    var expenseSheet = excel['Expenses'];
    excel.setDefaultSheet('Expenses');
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
    String path = '$directory/Exported.xlsx';
    var bytes = excel.save();
    File file = File(path);
    file.writeAsBytesSync(bytes!);
    if (!file.existsSync()) {
      Fluttertoast.showToast(msg: 'Failed to save Excel file');
      return null;
    }
    Fluttertoast.showToast(msg: 'Excel file saved to: $path');
    return file;
  }

  @override
  void initState() {
    super.initState();
    _expenseRepositoryImplementation = ExpenseRepositoryImplementation(
        datasource: ExpenseLocalDatasourceImplementation(
      AppDatabase(),
    ));
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
            const MainAppBar(),
            Padding(
              padding: EdgeInsets.all(width * 0.05),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: width * 0.05),
                      child: const Column(
                        children: [
                          Text(
                            "Profile",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
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

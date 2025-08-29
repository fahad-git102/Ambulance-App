import 'dart:convert';
import 'dart:io';

import 'package:ambulance_app/components/text_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/app_colors.dart';
import '../core/app_contants.dart';

class ReportsListScreen extends StatefulWidget {
  const ReportsListScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ReportsListState();
}

class _ReportsListState extends State<ReportsListScreen> {
  List<Map<String, dynamic>> reports = [];

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    final loadedReports = await loadReports();
    setState(() {
      reports = loadedReports;
    });
  }

  Future<List<Map<String, dynamic>>> loadReports() async {
    final prefs = await SharedPreferences.getInstance();
    final reportsJson = prefs.getStringList("reports") ?? [];
    return reportsJson
        .map((r) => jsonDecode(r) as Map<String, dynamic>)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomBoldText(title: 'Past Reports'),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 10),
          itemCount: reports.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index){
            return SizedBox(height: 10,);
          },
          itemBuilder: (context, index) {
            final report = reports[index];
            return Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: appBoxShadow,
              ),
              child: ListTile(
                title: Text(report["name"] ?? "Unknown"),
                subtitle: Text(report["incidentDate"] ?? ""),
                trailing: Icon(Icons.picture_as_pdf_outlined),
                onTap: () async {
                  final file = File(report["filePath"]);
                  if (await file.exists()) {
                    await OpenFile.open(file.path);
                  } else {
                    Get.snackbar('Error', "File not found");
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

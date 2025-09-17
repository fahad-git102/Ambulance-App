import 'dart:convert';
import 'dart:io';
import 'package:ambulance_app/components/text_widgets/custom_text.dart';
import 'package:ambulance_app/components/text_widgets/small_light_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
  List<Map<String, dynamic>> filteredReports = [];

  String searchQuery = "";
  DateTimeRange? selectedDateRange;

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    final loadedReports = await loadReports();
    setState(() {
      reports = loadedReports;
      filteredReports = loadedReports;
    });
  }

  Future<List<Map<String, dynamic>>> loadReports() async {
    final prefs = await SharedPreferences.getInstance();
    final reportsJson = prefs.getStringList("reports") ?? [];
    return reportsJson
        .map((r) => jsonDecode(r) as Map<String, dynamic>)
        .toList();
  }

  void _applyFilters() {
    setState(() {
      filteredReports = reports.where((report) {
        final query = searchQuery.toLowerCase();

        final name = (report["name"] ?? "").toString().toLowerCase();
        final severity = (report['mapData']["severity"] ?? "").toString().toLowerCase();
        final location = (report['mapData']["location"] ?? "").toString().toLowerCase();
        final disposition =
        (report['mapData']["disposition"] ?? "").toString().toLowerCase();
        final matchesText = query.isEmpty ||
            name.contains(query) ||
            severity.contains(query) ||
            location.contains(query) ||
            disposition.contains(query);

        // Match against date range if selected
        bool matchesDate = true;
        if (selectedDateRange != null &&
            report["incidentDate"] != null &&
            report["incidentDate"].toString().isNotEmpty) {
          try {
            final reportDate = DateFormat("MMM dd, yyyy - hh:mm a").parse(report["incidentDate"]);
            matchesDate = reportDate.isAfter(
              selectedDateRange!.start.subtract(const Duration(days: 1)),
            ) &&
                reportDate.isBefore(
                  selectedDateRange!.end.add(const Duration(days: 1)),
                );
          } catch (e) {
            print('error iss : $e');
          }
        }

        return matchesText && matchesDate;
      }).toList();
    });
  }

  Future<void> _pickDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: selectedDateRange,
    );

    if (picked != null) {
      setState(() {
        selectedDateRange = picked;
      });
      _applyFilters();
    }
  }

  Future<void> _deleteReport(int index) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Report'),
        content: const Text(
            'Are you sure you want to delete this report? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final report = filteredReports[index];
      try {
        final file = File(report["filePath"]);
        if (await file.exists()) {
          await file.delete();
        }

        final prefs = await SharedPreferences.getInstance();
        final reportsJson = prefs.getStringList("reports") ?? [];
        reportsJson.removeWhere(
                (r) => jsonDecode(r)["filePath"] == report["filePath"]);
        await prefs.setStringList("reports", reportsJson);

        setState(() {
          reports.removeWhere((r) => r["filePath"] == report["filePath"]);
          filteredReports.removeAt(index);
        });

        Get.snackbar('Success', 'Report deleted successfully');
      } catch (e) {
        Get.snackbar('Error', 'Failed to delete report: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomBoldText(title: 'Past Reports'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: _pickDateRange,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 🔍 Search Field
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search by name, severity, location, disposition',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (val) {
                  searchQuery = val;
                  _applyFilters();
                },
              ),
            ),

            Expanded(
              child: filteredReports.isEmpty
                  ? const Center(
                child: SmallLightText(title: 'No reports found'),
              )
                  : ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: filteredReports.length,
                separatorBuilder: (context, index) =>
                const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final report = filteredReports[index];
                  return Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: appBoxShadow,
                    ),
                    child: ListTile(
                      title: Text(report["name"] ?? "Unknown"),
                      subtitle: Text(report["incidentDate"] ?? ""),
                      trailing: IconButton(
                        onPressed: () => _deleteReport(index),
                        icon: const Icon(Icons.delete_outline),
                      ),
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
          ],
        ),
      ),
    );
  }
}

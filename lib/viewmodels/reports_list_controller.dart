import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/edit_past_report_screen.dart';

class ReportsListController extends GetxController {
  final reports = <Map<String, dynamic>>[].obs;
  final filteredReports = <Map<String, dynamic>>[].obs;
  final searchQuery = ''.obs;
  final selectedDateRange = Rxn<DateTimeRange>();
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReports();
  }

  Future<void> fetchReports() async {
    isLoading.value = true;
    final loadedReports = await loadReports();
    reports.value = loadedReports;
    filteredReports.value = loadedReports;
    isLoading.value = false;
  }

  Future<List<Map<String, dynamic>>> loadReports() async {
    final prefs = await SharedPreferences.getInstance();
    final reportsJson = prefs.getStringList("reports") ?? [];
    return reportsJson
        .map((r) => jsonDecode(r) as Map<String, dynamic>)
        .toList();
  }

  void applyFilters() {
    filteredReports.value = reports.where((report) {
      final query = searchQuery.value.toLowerCase();

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
      if (selectedDateRange.value != null &&
          report["incidentDate"] != null &&
          report["incidentDate"].toString().isNotEmpty) {
        try {
          final reportDate = DateFormat("MMM dd, yyyy - hh:mm a").parse(report["incidentDate"]);
          matchesDate = reportDate.isAfter(
            selectedDateRange.value!.start.subtract(const Duration(days: 1)),
          ) &&
              reportDate.isBefore(
                selectedDateRange.value!.end.add(const Duration(days: 1)),
              );
        } catch (e) {
          print('error is : $e');
        }
      }

      return matchesText && matchesDate;
    }).toList();
  }

  Future<void> pickDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: selectedDateRange.value,
    );

    if (picked != null) {
      selectedDateRange.value = picked;
      applyFilters();
    }
  }

  Future<void> deleteReport(int index) async {
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

        reports.removeWhere((r) => r["filePath"] == report["filePath"]);
        filteredReports.removeAt(index);

        Get.snackbar('Success', 'Report deleted successfully');
      } catch (e) {
        Get.snackbar('Error', 'Failed to delete report: $e');
      }
    }
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    applyFilters();
  }

  Future<void> navigateToEditReport(BuildContext context, Map<String, dynamic> report, int index) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => EditPastReportScreen(
          reportData: report,
          reportIndex: index,
        ),
      ),
    );
    // Refresh the list when returning from edit screen
    await fetchReports();
  }
}

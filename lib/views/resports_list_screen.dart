
import 'package:ambulance_app/components/text_widgets/custom_text.dart';
import 'package:ambulance_app/components/text_widgets/small_light_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/app_colors.dart';
import '../core/app_contants.dart';
import '../viewmodels/reports_list_controller.dart';

class ReportsListScreen extends StatelessWidget {
  const ReportsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReportsListController());

    return Scaffold(
      appBar: AppBar(
        title: const CustomBoldText(title: 'Past Reports'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () => controller.pickDateRange(context),
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
                onChanged: controller.onSearchChanged,
              ),
            ),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (controller.filteredReports.isEmpty) {
                  return const Center(
                    child: SmallLightText(title: 'No reports found'),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: controller.filteredReports.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final report = controller.filteredReports[index];
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
                        onTap: () => controller.navigateToEditReport(
                          context,
                          report,
                          index,
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class ProjectPage extends StatelessWidget {
  final String projectName;
  final String date;
  final int completedTasks;
  final int totalTasks;

  const ProjectPage({
    super.key,
    required this.projectName,
    required this.date,
    required this.completedTasks,
    required this.totalTasks,
    required taskTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(projectName),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "24h",
                    style: TextStyle(
                      color: Colors.red[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Progress section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Progress",
                    style: TextStyle(
                      color: Colors.red[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: completedTasks / totalTasks,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red[800]!),
                    minHeight: 8,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$completedTasks of $totalTasks tasks completed",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

          
            // Task list
            Column(
              children: [
                _buildTaskItem(
                  title: "User app design",
                  description:
                      "This long established fact that a reader will be dismissed by the readable...",
                  startDate: "15 Feb 2023",
                  endDate: "20 Feb 2023",
                ),
                const SizedBox(height: 16),
                _buildTaskItem(
                  title: "Vendor app design",
                  description:
                      "This long established fact that a reader will be dismissed by the readable...",
                  startDate: "21 Feb 2023",
                  endDate: "27 Feb 2023",
                ),
                const SizedBox(height: 16),
                _buildTaskItem(
                  title: "User authentication Devs...",
                  description:
                      "It is a long established fact that a reader will be dismissed by the readable...",
                  startDate: "21 Feb 2023",
                  endDate: "26 Feb 2023",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem({
    required String title,
    required String description,
    required String startDate,
    required String endDate,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.red[800],
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                startDate,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                endDate,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TabConfig {
  const TabConfig({required this.id, required this.label, required this.icon});
  final String id;
  final String label;
  final IconData icon;
}

List<TabConfig> startupTabsFor({required bool hasBusinessPlan}) => hasBusinessPlan
    ? const [
        TabConfig(id: 'overview', label: 'Girişimim', icon: Icons.rocket_launch_outlined),
        TabConfig(id: 'plan', label: 'İş Planım', icon: Icons.description_outlined),
        TabConfig(id: 'investor_ready', label: 'Yatırımcıya Hazırlık', icon: Icons.trending_up),
      ]
    : const [
        TabConfig(id: 'overview', label: 'Girişimim', icon: Icons.rocket_launch_outlined),
        TabConfig(id: 'plan_guide', label: 'İş Planı Hazırla', icon: Icons.edit_note),
      ];

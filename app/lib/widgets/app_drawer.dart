import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;

  const AppDrawer({Key? key, required this.currentRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'IVF Companion',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.local_hospital, color: Color(0xFF8BA888)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  settings.userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  settings.userRole,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.dashboard_outlined,
            title: 'Dashboard',
            route: '/dashboard',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.people_outline,
            title: 'Patients',
            route: '/patients',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.calendar_today_outlined,
            title: 'Appointments',
            route: '/appointments',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.medical_services_outlined,
            title: 'Treatments',
            route: '/treatments',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.medication_outlined,
            title: 'Treatment Protocols',
            route: '/protocols',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.science_outlined,
            title: 'Lab Results',
            route: '/lab_results',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.message_outlined,
            title: 'Messages',
            route: '/messenger',
          ),
          const Divider(),
          _buildDrawerItem(
            context,
            icon: Icons.group_outlined,
            title: 'Staff',
            route: '/staff',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.settings_outlined,
            title: 'Settings',
            route: '/settings',
          ),
          ListTile(
            leading: Icon(Icons.help_outline, color: Colors.grey[600]),
            title: Text(
              'Help & Support',
              style: TextStyle(color: Colors.grey[600]),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    final bool isSelected = currentRoute == route;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).primaryColor : Colors.grey[600],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[600],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        Navigator.pop(context); // Close drawer
        if (!isSelected) {
          // If navigating to dashboard, use pushReplacementNamed to avoid stacking dashboards
          if (route == '/dashboard') {
             // For simplicity, let's stick to pushNamed for now to match existing behavior,
             // or we can implement a better navigation strategy later.
             // But to prevent infinite stack, maybe check if we can pop to it?
             // For now, let's just push.
             Navigator.pushNamed(context, route);
          } else {
             Navigator.pushNamed(context, route);
          }
        }
      },
      selected: isSelected,
      selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
    );
  }
}

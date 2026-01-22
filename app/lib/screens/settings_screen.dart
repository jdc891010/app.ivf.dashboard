import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/app_drawer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final List<String> _languageOptions = [
    'English',
    'Spanish',
    'French',
    'Chinese',
    'Arabic',
  ];

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            tooltip: 'Dashboard',
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: '/settings'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            
            Expanded(
              child: ListView(
                children: [
                  _buildSettingsSection(
                    title: 'Account',
                    icon: Icons.person_outline,
                    children: [
                      _buildSettingsCard(
                        title: 'Profile Information',
                        description: 'Update your personal information',
                        icon: Icons.edit_outlined,
                        onTap: () => _showProfileDialog(context, settings),
                      ),
                      _buildSettingsCard(
                        title: 'Change Password',
                        description: 'Update your password',
                        icon: Icons.lock_outline,
                        onTap: () => _showPasswordDialog(context),
                      ),
                    ],
                  ),
                  
                  _buildSettingsSection(
                    title: 'Notifications',
                    icon: Icons.notifications_outlined,
                    children: [
                      SwitchListTile(
                        title: const Text('Enable Notifications'),
                        subtitle: const Text('Receive in-app notifications'),
                        value: settings.enableNotifications,
                        onChanged: (value) => settings.setNotifications(value),
                        secondary: const Icon(Icons.notifications_active_outlined),
                      ),
                      SwitchListTile(
                        title: const Text('Email Alerts'),
                        subtitle: const Text('Receive important updates via email'),
                        value: settings.enableEmailAlerts,
                        onChanged: (value) => settings.setEmailAlerts(value),
                        secondary: const Icon(Icons.email_outlined),
                      ),
                    ],
                  ),
                  
                  _buildSettingsSection(
                    title: 'Appearance',
                    icon: Icons.palette_outlined,
                    children: [
                      SwitchListTile(
                        title: const Text('Dark Mode'),
                        subtitle: const Text('Use dark theme'),
                        value: settings.isDarkMode,
                        onChanged: (value) => settings.setDarkMode(value),
                        secondary: const Icon(Icons.dark_mode_outlined),
                      ),
                      ListTile(
                        title: const Text('Language'),
                        subtitle: Text('Selected: ${settings.selectedLanguage}'),
                        leading: const Icon(Icons.language_outlined),
                        trailing: DropdownButton<String>(
                          value: settings.selectedLanguage,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              settings.setLanguage(newValue);
                            }
                          },
                          items: _languageOptions.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          underline: Container(),
                        ),
                      ),
                    ],
                  ),
                  
                  _buildSettingsSection(
                    title: 'System',
                    icon: Icons.settings_outlined,
                    children: [
                      _buildSettingsCard(
                        title: 'Backup & Restore',
                        description: 'Backup or restore your data',
                        icon: Icons.backup_outlined,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Backup service is currently offline')),
                          );
                        },
                      ),
                    ],
                  ),
                  
                  _buildSettingsSection(
                    title: 'Help & Support',
                    icon: Icons.help_outline,
                    children: [
                      _buildSettingsCard(
                        title: 'About',
                        description: 'View app information and version',
                        icon: Icons.info_outline,
                        onTap: () {
                          showAboutDialog(
                            context: context,
                            applicationName: 'IVF Clinic Dashboard',
                            applicationVersion: '1.0.0',
                            applicationIcon: const Icon(Icons.local_hospital, size: 32, color: Color(0xFF8BA888)),
                            applicationLegalese: ' 2026 IVF Personal Analytics. All rights reserved.',
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileDialog(BuildContext context, SettingsProvider settings) {
    final nameController = TextEditingController(text: settings.userName);
    final emailController = TextEditingController(text: settings.userEmail);
    final phoneController = TextEditingController(text: settings.userPhone);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              settings.updateProfile(
                name: nameController.text,
                email: emailController.text,
                phone: phoneController.text,
                role: settings.userRole,
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated successfully')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: InputDecoration(labelText: 'Current Password'), obscureText: true),
            SizedBox(height: 16),
            TextField(decoration: InputDecoration(labelText: 'New Password'), obscureText: true),
            SizedBox(height: 16),
            TextField(decoration: InputDecoration(labelText: 'Confirm New Password'), obscureText: true),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Change Password'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            children: [
              Icon(icon, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Card(
          child: Column(
            children: children,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(description),
      leading: Icon(icon),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

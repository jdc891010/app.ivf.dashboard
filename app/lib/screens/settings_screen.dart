import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Sample settings
  bool _enableNotifications = true;
  bool _enableEmailAlerts = true;
  bool _enableDarkMode = false;
  String _selectedLanguage = 'English';
  final List<String> _languageOptions = [
    'English',
    'Spanish',
    'French',
    'Chinese',
    'Arabic',
  ];

  @override
  Widget build(BuildContext context) {
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
            onPressed: () {
              // Show notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Show confirmation dialog
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
      drawer: _buildNavigationDrawer(),
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
                        onTap: () {
                          // Navigate to profile edit screen
                        },
                      ),
                      _buildSettingsCard(
                        title: 'Change Password',
                        description: 'Update your password',
                        icon: Icons.lock_outline,
                        onTap: () {
                          // Navigate to change password screen
                        },
                      ),
                      _buildSettingsCard(
                        title: 'Two-Factor Authentication',
                        description: 'Enable additional security',
                        icon: Icons.security_outlined,
                        onTap: () {
                          // Navigate to 2FA settings
                        },
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
                        value: _enableNotifications,
                        onChanged: (value) {
                          setState(() {
                            _enableNotifications = value;
                          });
                        },
                        secondary: const Icon(Icons.notifications_active_outlined),
                      ),
                      SwitchListTile(
                        title: const Text('Email Alerts'),
                        subtitle: const Text('Receive important updates via email'),
                        value: _enableEmailAlerts,
                        onChanged: (value) {
                          setState(() {
                            _enableEmailAlerts = value;
                          });
                        },
                        secondary: const Icon(Icons.email_outlined),
                      ),
                      _buildSettingsCard(
                        title: 'Notification Preferences',
                        description: 'Customize which notifications you receive',
                        icon: Icons.tune_outlined,
                        onTap: () {
                          // Navigate to notification preferences
                        },
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
                        value: _enableDarkMode,
                        onChanged: (value) {
                          setState(() {
                            _enableDarkMode = value;
                          });
                        },
                        secondary: const Icon(Icons.dark_mode_outlined),
                      ),
                      ListTile(
                        title: const Text('Language'),
                        subtitle: Text('Selected: $_selectedLanguage'),
                        leading: const Icon(Icons.language_outlined),
                        trailing: DropdownButton<String>(
                          value: _selectedLanguage,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedLanguage = newValue;
                              });
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
                        title: 'Data Management',
                        description: 'Manage your data and exports',
                        icon: Icons.storage_outlined,
                        onTap: () {
                          // Navigate to data management
                        },
                      ),
                      _buildSettingsCard(
                        title: 'Backup & Restore',
                        description: 'Backup or restore your data',
                        icon: Icons.backup_outlined,
                        onTap: () {
                          // Navigate to backup settings
                        },
                      ),
                      _buildSettingsCard(
                        title: 'System Logs',
                        description: 'View system logs and activity',
                        icon: Icons.history_outlined,
                        onTap: () {
                          // Navigate to system logs
                        },
                      ),
                    ],
                  ),
                  
                  _buildSettingsSection(
                    title: 'Help & Support',
                    icon: Icons.help_outline,
                    children: [
                      _buildSettingsCard(
                        title: 'User Guide',
                        description: 'View the user guide and documentation',
                        icon: Icons.menu_book_outlined,
                        onTap: () {
                          // Open user guide
                        },
                      ),
                      _buildSettingsCard(
                        title: 'Contact Support',
                        description: 'Get help from our support team',
                        icon: Icons.support_agent_outlined,
                        onTap: () {
                          // Contact support
                        },
                      ),
                      _buildSettingsCard(
                        title: 'About',
                        description: 'View app information and version',
                        icon: Icons.info_outline,
                        onTap: () {
                          // Show about dialog
                          showAboutDialog(
                            context: context,
                            applicationName: 'IVF Clinic Dashboard',
                            applicationVersion: '1.0.0',
                            applicationIcon: const Icon(
                              Icons.medical_services_outlined,
                              color: Color(0xFF8BA888),
                              size: 32,
                            ),
                            applicationLegalese: ' 2025 IVF Australia. All rights reserved.',
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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

  Widget _buildNavigationDrawer() {
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
                const CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Color(0xFF8BA888),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Dr. Emily Thompson',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Fertility Specialist',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            icon: Icons.dashboard_outlined,
            title: 'Dashboard',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
          ),
          _buildDrawerItem(
            icon: Icons.people_outline,
            title: 'Patients',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/patients');
            },
          ),
          _buildDrawerItem(
            icon: Icons.calendar_today_outlined,
            title: 'Appointments',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/appointments');
            },
          ),
          _buildDrawerItem(
            icon: Icons.medical_services_outlined,
            title: 'Treatments',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/treatments');
            },
          ),
          _buildDrawerItem(
            icon: Icons.science_outlined,
            title: 'Lab Results',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/lab_results');
            },
          ),
          _buildDrawerItem(
            icon: Icons.message_outlined,
            title: 'Messages',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/messenger');
            },
          ),
          const Divider(),
          _buildDrawerItem(
            icon: Icons.group_outlined,
            title: 'Staff',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/staff');
            },
          ),
          _buildDrawerItem(
            icon: Icons.settings_outlined,
            title: 'Settings',
            isSelected: true,
            onTap: () => Navigator.pop(context),
          ),
          _buildDrawerItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).primaryColor : Colors.grey[700],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: onTap,
      selected: isSelected,
      selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
    );
  }
}

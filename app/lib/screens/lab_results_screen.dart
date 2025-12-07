import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LabResultsScreen extends StatefulWidget {
  const LabResultsScreen({Key? key}) : super(key: key);

  @override
  State<LabResultsScreen> createState() => _LabResultsScreenState();
}

class _LabResultsScreenState extends State<LabResultsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All Results';
  final List<String> _filterOptions = [
    'All Results',
    'Hormone Tests',
    'Genetic Tests',
    'Semen Analysis',
    'Blood Tests',
    'Ultrasound Reports',
  ];

  // Sample lab results data
  final List<Map<String, dynamic>> _labResults = [
    {
      'id': 'LR001',
      'patientId': 'P001',
      'patientName': 'Sarah Johnson',
      'testType': 'Hormone Test',
      'testName': 'AMH Level',
      'date': DateTime(2025, 3, 10),
      'result': '2.5 ng/mL',
      'normalRange': '1.0 - 3.5 ng/mL',
      'status': 'Normal',
      'doctor': 'Dr. Emily Thompson',
      'notes': 'AMH levels indicate good ovarian reserve',
    },
    {
      'id': 'LR002',
      'patientId': 'P002',
      'patientName': 'Michael Roberts',
      'testType': 'Semen Analysis',
      'testName': 'Sperm Count',
      'date': DateTime(2025, 3, 8),
      'result': '15 million/mL',
      'normalRange': '≥ 15 million/mL',
      'status': 'Normal',
      'doctor': 'Dr. Robert Chen',
      'notes': 'Sperm count at lower end of normal range',
    },
    {
      'id': 'LR003',
      'patientId': 'P003',
      'patientName': 'Jennifer Davis',
      'testType': 'Hormone Test',
      'testName': 'Estradiol',
      'date': DateTime(2025, 3, 15),
      'result': '225 pg/mL',
      'normalRange': '30 - 400 pg/mL',
      'status': 'Normal',
      'doctor': 'Dr. Emily Thompson',
      'notes': 'Estradiol levels within expected range for stimulation phase',
    },
    {
      'id': 'LR004',
      'patientId': 'P001',
      'patientName': 'Sarah Johnson',
      'testType': 'Hormone Test',
      'testName': 'FSH Level',
      'date': DateTime(2025, 3, 10),
      'result': '8.5 mIU/mL',
      'normalRange': '3.5 - 12.5 mIU/mL',
      'status': 'Normal',
      'doctor': 'Dr. Emily Thompson',
      'notes': 'FSH levels indicate normal ovarian function',
    },
    {
      'id': 'LR005',
      'patientId': 'P004',
      'patientName': 'David Wilson',
      'testType': 'Blood Test',
      'testName': 'Complete Blood Count',
      'date': DateTime(2025, 3, 5),
      'result': 'See detailed report',
      'normalRange': 'Various',
      'status': 'Normal',
      'doctor': 'Dr. Robert Chen',
      'notes': 'All blood parameters within normal range',
    },
    {
      'id': 'LR006',
      'patientId': 'P002',
      'patientName': 'Michael Roberts',
      'testType': 'Semen Analysis',
      'testName': 'Motility',
      'date': DateTime(2025, 3, 8),
      'result': '40%',
      'normalRange': '≥ 40%',
      'status': 'Normal',
      'doctor': 'Dr. Robert Chen',
      'notes': 'Sperm motility at threshold of normal range',
    },
    {
      'id': 'LR007',
      'patientId': 'P006',
      'patientName': 'James Anderson',
      'testType': 'Genetic Test',
      'testName': 'Karyotype',
      'date': DateTime(2025, 2, 20),
      'result': '46,XY',
      'normalRange': '46,XY (male)',
      'status': 'Normal',
      'doctor': 'Dr. Emily Thompson',
      'notes': 'Normal male karyotype',
    },
    {
      'id': 'LR008',
      'patientId': 'P003',
      'patientName': 'Jennifer Davis',
      'testType': 'Ultrasound Report',
      'testName': 'Follicle Count',
      'date': DateTime(2025, 3, 12),
      'result': '8 follicles (right), 7 follicles (left)',
      'normalRange': 'N/A',
      'status': 'Good',
      'doctor': 'Dr. Emily Thompson',
      'notes': 'Good response to stimulation medication',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredResults {
    return _labResults.where((result) {
      // Apply search filter
      final patientNameMatches = result['patientName']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final idMatches = result['id']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final patientIdMatches = result['patientId']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final testNameMatches = result['testName']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final searchMatches = patientNameMatches || idMatches || patientIdMatches || testNameMatches;

      // Apply type filter
      bool typeMatches = true;
      if (_selectedFilter != 'All Results') {
        typeMatches = result['testType'] == _selectedFilter.replaceAll(' Results', '');
      }

      return searchMatches && typeMatches;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab Results'),
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
            // Header and actions row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lab Results',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Add new lab result
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Result'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Search and filter row
            Row(
              children: [
                // Search field
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by patient name, ID, or test name',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                
                // Filter dropdown
                DropdownButton<String>(
                  value: _selectedFilter,
                  items: _filterOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedFilter = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(width: 16),
                
                // Export button
                OutlinedButton.icon(
                  onPressed: () {
                    // Export lab results data
                  },
                  icon: const Icon(Icons.download_outlined),
                  label: const Text('Export'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Results count
            Text(
              '${filteredResults.length} results found',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            
            // Results list
            Expanded(
              child: ListView.builder(
                itemCount: filteredResults.length,
                itemBuilder: (context, index) {
                  final result = filteredResults[index];
                  return _buildResultCard(result);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(Map<String, dynamic> result) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Test type icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getTestTypeColor(result['testType']).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getTestTypeIcon(result['testType']),
                    color: _getTestTypeColor(result['testType']),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Test info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${result['testType']} - ${result['testName']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(result['status']).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              result['status'],
                              style: TextStyle(
                                color: _getStatusColor(result['status']),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            result['patientName'],
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.badge_outlined, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            result['patientId'],
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            'Date: ${DateFormat('MMM d, yyyy').format(result['date'])}',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.medical_services_outlined, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            'Doctor: ${result['doctor']}',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            
            // Result details
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Result',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        result['result'],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Normal Range',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        result['normalRange'],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Notes
            if (result['notes'] != null && result['notes'].isNotEmpty) ...[  
              const Text(
                'Notes',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(result['notes']),
            ],
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // View patient profile
                    Navigator.pushNamed(
                      context,
                      '/patient_detail',
                      arguments: {
                        'id': result['patientId'],
                        'name': result['patientName'],
                        'age': 35, // This would come from actual patient data
                        'treatmentType': 'IVF', // This would come from actual patient data
                        'stage': 'Active', // This would come from actual patient data
                        'startDate': DateTime.now().subtract(const Duration(days: 30)), // This would come from actual patient data
                        'nextAppointment': DateTime.now().add(const Duration(days: 5)), // This would come from actual patient data
                        'status': 'Active', // This would come from actual patient data
                        'priority': 'Medium', // This would come from actual patient data
                        'phone': '+1 (555) 123-4567', // This would come from actual patient data
                        'email': 'patient@example.com', // This would come from actual patient data
                      },
                    );
                  },
                  icon: const Icon(Icons.person_outline, size: 16),
                  label: const Text('Patient Profile'),
                ),
                TextButton.icon(
                  onPressed: () {
                    // View full report
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Full Report Options'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.visibility_outlined),
                                title: const Text('View Report'),
                                onTap: () {
                                  Navigator.pop(context);
                                  // Show the report viewer
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Opening report viewer...')),
                                  );
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.download_outlined),
                                title: const Text('Download PDF'),
                                onTap: () {
                                  Navigator.pop(context);
                                  // Download the report
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Downloading report...')),
                                  );
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.print_outlined),
                                title: const Text('Print Report'),
                                onTap: () {
                                  Navigator.pop(context);
                                  // Print the report
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Sending to printer...')),
                                  );
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.share_outlined),
                                title: const Text('Share Report'),
                                onTap: () {
                                  Navigator.pop(context);
                                  // Share the report
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Opening share options...')),
                                  );
                                },
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.description_outlined, size: 16),
                  label: const Text('Full Report'),
                ),
                TextButton.icon(
                  onPressed: () {
                    // Edit result
                  },
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Edit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTestTypeIcon(String type) {
    switch (type) {
      case 'Hormone Test':
        return Icons.science_outlined;
      case 'Genetic Test':
        return Icons.biotech_outlined;
      case 'Semen Analysis':
        return Icons.biotech_outlined;
      case 'Blood Test':
        return Icons.bloodtype_outlined;
      case 'Ultrasound Report':
        return Icons.medical_information_outlined;
      default:
        return Icons.medical_information_outlined;
    }
  }

  Color _getTestTypeColor(String type) {
    switch (type) {
      case 'Hormone Test':
        return const Color(0xFF8BA888); // Primary color
      case 'Genetic Test':
        return const Color(0xFF6B9B9E); // Secondary color
      case 'Semen Analysis':
        return const Color(0xFF575756); // Accent color
      case 'Blood Test':
        return Colors.red;
      case 'Ultrasound Report':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Normal':
        return Colors.green;
      case 'Good':
        return Colors.green;
      case 'Abnormal':
        return Colors.red;
      case 'Low':
        return Colors.orange;
      case 'High':
        return Colors.orange;
      default:
        return Colors.grey;
    }
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
            isSelected: true,
            onTap: () => Navigator.pop(context),
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
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
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

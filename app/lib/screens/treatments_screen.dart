import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TreatmentsScreen extends StatefulWidget {
  const TreatmentsScreen({Key? key}) : super(key: key);

  @override
  State<TreatmentsScreen> createState() => _TreatmentsScreenState();
}

class _TreatmentsScreenState extends State<TreatmentsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedStatus = 'All Treatments';
  final List<String> _statusOptions = [
    'All Treatments',
    'Active',
    'Completed',
    'Scheduled',
    'Cancelled',
  ];

  // Sample treatments data
  final List<Map<String, dynamic>> _treatments = [
    {
      'id': 'T001',
      'patientId': 'P001',
      'patientName': 'Sarah Johnson',
      'type': 'IVF',
      'protocol': 'Long Protocol with Antagonist',
      'startDate': DateTime(2025, 2, 15),
      'currentPhase': 'Ovarian Stimulation',
      'nextProcedure': 'Egg Retrieval',
      'nextProcedureDate': DateTime(2025, 3, 15),
      'status': 'Active',
      'doctor': 'Dr. Emily Thompson',
    },
    {
      'id': 'T002',
      'patientId': 'P002',
      'patientName': 'Michael Roberts',
      'type': 'ICSI',
      'protocol': 'Short Protocol',
      'startDate': DateTime(2025, 1, 10),
      'currentPhase': 'Embryo Transfer',
      'nextProcedure': 'Pregnancy Test',
      'nextProcedureDate': DateTime(2025, 4, 5),
      'status': 'Active',
      'doctor': 'Dr. Robert Chen',
    },
    {
      'id': 'T003',
      'patientId': 'P003',
      'patientName': 'Jennifer Davis',
      'type': 'IVF',
      'protocol': 'Antagonist Protocol',
      'startDate': DateTime(2024, 12, 5),
      'currentPhase': 'Pregnancy Test',
      'nextProcedure': 'Ultrasound',
      'nextProcedureDate': DateTime(2025, 4, 10),
      'status': 'Active',
      'doctor': 'Dr. Emily Thompson',
    },
    {
      'id': 'T004',
      'patientId': 'P004',
      'patientName': 'David Wilson',
      'type': 'IUI',
      'protocol': 'Natural Cycle',
      'startDate': DateTime(2025, 3, 20),
      'currentPhase': 'Monitoring',
      'nextProcedure': 'Insemination',
      'nextProcedureDate': DateTime(2025, 4, 2),
      'status': 'Active',
      'doctor': 'Dr. Robert Chen',
    },
    {
      'id': 'T005',
      'patientId': 'P005',
      'patientName': 'Emily Thompson',
      'type': 'IVF',
      'protocol': 'Long Protocol',
      'startDate': DateTime(2024, 9, 12),
      'currentPhase': 'Completed',
      'nextProcedure': null,
      'nextProcedureDate': null,
      'status': 'Completed',
      'doctor': 'Dr. Emily Thompson',
    },
    {
      'id': 'T006',
      'patientId': 'P006',
      'patientName': 'James Anderson',
      'type': 'ICSI',
      'protocol': 'Antagonist Protocol',
      'startDate': DateTime(2025, 2, 28),
      'currentPhase': 'Egg Retrieval',
      'nextProcedure': 'Embryo Transfer',
      'nextProcedureDate': DateTime(2025, 4, 3),
      'status': 'Active',
      'doctor': 'Dr. Robert Chen',
    },
    {
      'id': 'T007',
      'patientId': 'P007',
      'patientName': 'Jessica Martinez',
      'type': 'IUI',
      'protocol': 'Stimulated Cycle',
      'startDate': DateTime(2025, 3, 5),
      'currentPhase': 'Monitoring',
      'nextProcedure': 'Insemination',
      'nextProcedureDate': DateTime(2025, 4, 1),
      'status': 'Active',
      'doctor': 'Dr. Emily Thompson',
    },
    {
      'id': 'T008',
      'patientId': 'P008',
      'patientName': 'Robert Taylor',
      'type': 'IVF',
      'protocol': 'Antagonist Protocol',
      'startDate': DateTime(2024, 10, 18),
      'currentPhase': 'Completed',
      'nextProcedure': null,
      'nextProcedureDate': null,
      'status': 'Completed',
      'doctor': 'Dr. Robert Chen',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredTreatments {
    return _treatments.where((treatment) {
      // Apply search filter
      final patientNameMatches = treatment['patientName']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final idMatches = treatment['id']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final patientIdMatches = treatment['patientId']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final typeMatches = treatment['type']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final searchMatches = patientNameMatches || idMatches || patientIdMatches || typeMatches;

      // Apply status filter
      bool statusMatches = true;
      if (_selectedStatus != 'All Treatments') {
        statusMatches = treatment['status'] == _selectedStatus;
      }

      return searchMatches && statusMatches;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Treatment Management'),
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
                  'Treatments',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Add new treatment
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('New Treatment'),
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
                      hintText: 'Search by patient name, ID, or treatment type',
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
                
                // Status filter dropdown
                DropdownButton<String>(
                  value: _selectedStatus,
                  items: _statusOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedStatus = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(width: 16),
                
                // Export button
                OutlinedButton.icon(
                  onPressed: () {
                    // Export treatment data
                  },
                  icon: const Icon(Icons.download_outlined),
                  label: const Text('Export'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Treatments count
            Text(
              '${filteredTreatments.length} treatments found',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            
            // Treatments list
            Expanded(
              child: ListView.builder(
                itemCount: filteredTreatments.length,
                itemBuilder: (context, index) {
                  final treatment = filteredTreatments[index];
                  return _buildTreatmentCard(treatment);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTreatmentCard(Map<String, dynamic> treatment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () {
          // View treatment details
          Navigator.pushNamed(
            context,
            '/patient_detail',
            arguments: {
              'id': treatment['patientId'],
              'name': treatment['patientName'],
              'age': 35, // This would come from actual patient data
              'treatmentType': treatment['type'],
              'stage': treatment['currentPhase'],
              'startDate': treatment['startDate'],
              'nextAppointment': treatment['nextProcedureDate'],
              'status': treatment['status'],
              'priority': 'Medium', // This would come from actual patient data
              'phone': '+1 (555) 123-4567', // This would come from actual patient data
              'email': 'patient@example.com', // This would come from actual patient data
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Treatment type icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getTreatmentTypeColor(treatment['type']).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getTreatmentTypeIcon(treatment['type']),
                      color: _getTreatmentTypeColor(treatment['type']),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Treatment info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${treatment['type']} - ${treatment['protocol']}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(treatment['status']).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                treatment['status'],
                                style: TextStyle(
                                  color: _getStatusColor(treatment['status']),
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
                              treatment['patientName'],
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 16),
                            const Icon(Icons.badge_outlined, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              treatment['patientId'],
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
                              'Started: ${DateFormat('MMM d, yyyy').format(treatment['startDate'])}',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            const SizedBox(width: 16),
                            const Icon(Icons.medical_services_outlined, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              'Phase: ${treatment['currentPhase']}',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              'Doctor: ${treatment['doctor']}',
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
              
              // Next procedure
              if (treatment['nextProcedure'] != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.event_outlined, color: Color(0xFF8BA888)),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Next Procedure',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            Text(
                              treatment['nextProcedure'],
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (treatment['nextProcedureDate'] != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Scheduled Date',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          Text(
                            DateFormat('MMM d, yyyy').format(treatment['nextProcedureDate']),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                  ],
                ),
              
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
                          'id': treatment['patientId'],
                          'name': treatment['patientName'],
                          'age': 35, // This would come from actual patient data
                          'treatmentType': treatment['type'],
                          'stage': treatment['currentPhase'],
                          'startDate': treatment['startDate'],
                          'nextAppointment': treatment['nextProcedureDate'],
                          'status': treatment['status'],
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
                      // Edit treatment
                    },
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Edit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTreatmentTypeIcon(String type) {
    switch (type) {
      case 'IVF':
        return Icons.science_outlined;
      case 'ICSI':
        return Icons.biotech_outlined;
      case 'IUI':
        return Icons.medical_services_outlined;
      default:
        return Icons.medical_information_outlined;
    }
  }

  Color _getTreatmentTypeColor(String type) {
    switch (type) {
      case 'IVF':
        return const Color(0xFF8BA888); // Primary color
      case 'ICSI':
        return const Color(0xFF6B9B9E); // Secondary color
      case 'IUI':
        return const Color(0xFF575756); // Accent color
      default:
        return Colors.orange;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Scheduled':
        return const Color(0xFF8BA888);
      case 'Completed':
        return Colors.blue;
      case 'Cancelled':
        return Colors.red;
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
            isSelected: true,
            onTap: () => Navigator.pop(context),
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

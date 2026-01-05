import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:intl/intl.dart';

import '../widgets/app_drawer.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({Key? key}) : super(key: key);

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All Patients';
  final List<String> _filterOptions = [
    'All Patients',
    'Active Treatments',
    'Completed Treatments',
    'New Patients',
    'High Priority',
  ];

  // Sample patient data
  final List<Map<String, dynamic>> _patients = [
    {
      'id': 'P001',
      'name': 'Sarah Johnson',
      'age': 34,
      'treatmentType': 'IVF',
      'stage': 'Ovarian Stimulation',
      'startDate': DateTime(2025, 2, 15),
      'nextAppointment': DateTime(2025, 3, 31, 10, 30),
      'status': 'Active',
      'priority': 'Medium',
      'phone': '+1 (555) 123-4567',
      'email': 'sarah.johnson@example.com',
    },
    {
      'id': 'P002',
      'name': 'Michael Roberts',
      'age': 38,
      'treatmentType': 'ICSI',
      'stage': 'Embryo Transfer',
      'startDate': DateTime(2025, 1, 10),
      'nextAppointment': DateTime(2025, 4, 2, 14, 15),
      'status': 'Active',
      'priority': 'High',
      'phone': '+1 (555) 987-6543',
      'email': 'michael.roberts@example.com',
    },
    {
      'id': 'P003',
      'name': 'Jennifer Davis',
      'age': 32,
      'treatmentType': 'IVF',
      'stage': 'Pregnancy Test',
      'startDate': DateTime(2024, 12, 5),
      'nextAppointment': DateTime(2025, 3, 31, 13, 15),
      'status': 'Active',
      'priority': 'High',
      'phone': '+1 (555) 456-7890',
      'email': 'jennifer.davis@example.com',
    },
    {
      'id': 'P004',
      'name': 'David Wilson',
      'age': 41,
      'treatmentType': 'IUI',
      'stage': 'Initial Consultation',
      'startDate': DateTime(2025, 3, 20),
      'nextAppointment': DateTime(2025, 3, 31, 15, 0),
      'status': 'New',
      'priority': 'Medium',
      'phone': '+1 (555) 789-0123',
      'email': 'david.wilson@example.com',
    },
    {
      'id': 'P005',
      'name': 'Emily Thompson',
      'age': 29,
      'treatmentType': 'IVF',
      'stage': 'Completed',
      'startDate': DateTime(2024, 9, 12),
      'nextAppointment': null,
      'status': 'Completed',
      'priority': 'Low',
      'phone': '+1 (555) 234-5678',
      'email': 'emily.thompson@example.com',
    },
    {
      'id': 'P006',
      'name': 'James Anderson',
      'age': 36,
      'treatmentType': 'ICSI',
      'stage': 'Egg Retrieval',
      'startDate': DateTime(2025, 2, 28),
      'nextAppointment': DateTime(2025, 4, 5, 9, 0),
      'status': 'Active',
      'priority': 'Medium',
      'phone': '+1 (555) 345-6789',
      'email': 'james.anderson@example.com',
    },
    {
      'id': 'P007',
      'name': 'Jessica Martinez',
      'age': 33,
      'treatmentType': 'IUI',
      'stage': 'Monitoring',
      'startDate': DateTime(2025, 3, 5),
      'nextAppointment': DateTime(2025, 4, 1, 11, 45),
      'status': 'Active',
      'priority': 'Medium',
      'phone': '+1 (555) 567-8901',
      'email': 'jessica.martinez@example.com',
    },
    {
      'id': 'P008',
      'name': 'Robert Taylor',
      'age': 40,
      'treatmentType': 'IVF',
      'stage': 'Completed',
      'startDate': DateTime(2024, 10, 18),
      'nextAppointment': null,
      'status': 'Completed',
      'priority': 'Low',
      'phone': '+1 (555) 678-9012',
      'email': 'robert.taylor@example.com',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredPatients {
    return _patients.where((patient) {
      // Apply search filter
      final nameMatches = patient['name']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final idMatches = patient['id']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final searchMatches = nameMatches || idMatches;

      // Apply category filter
      bool categoryMatches = true;
      if (_selectedFilter == 'Active Treatments') {
        categoryMatches = patient['status'] == 'Active';
      } else if (_selectedFilter == 'Completed Treatments') {
        categoryMatches = patient['status'] == 'Completed';
      } else if (_selectedFilter == 'New Patients') {
        categoryMatches = patient['status'] == 'New';
      } else if (_selectedFilter == 'High Priority') {
        categoryMatches = patient['priority'] == 'High';
      }

      return searchMatches && categoryMatches;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Management'),
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
      drawer: const AppDrawer(currentRoute: '/patients'),
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
                  'Patients',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _showAddPatientDialog();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Patient'),
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
                      hintText: 'Search by name or ID',
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
                    // Export patient data
                  },
                  icon: const Icon(Icons.download_outlined),
                  label: const Text('Export'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Patients count
            Text(
              '${filteredPatients.length} patients found',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            
            // Patients table
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DataTable2(
                    columnSpacing: 12,
                    horizontalMargin: 12,
                    minWidth: 900,
                    columns: const [
                      DataColumn2(
                        label: Text('ID'),
                        size: ColumnSize.S,
                      ),
                      DataColumn2(
                        label: Text('Name'),
                        size: ColumnSize.M,
                      ),
                      DataColumn2(
                        label: Text('Age'),
                        size: ColumnSize.S,
                        numeric: true,
                      ),
                      DataColumn2(
                        label: Text('Treatment'),
                        size: ColumnSize.S,
                      ),
                      DataColumn2(
                        label: Text('Stage'),
                        size: ColumnSize.M,
                      ),
                      DataColumn2(
                        label: Text('Next Appointment'),
                        size: ColumnSize.M,
                      ),
                      DataColumn2(
                        label: Text('Status'),
                        size: ColumnSize.S,
                      ),
                      DataColumn2(
                        label: Text('Actions'),
                        size: ColumnSize.S,
                      ),
                    ],
                    rows: filteredPatients.map((patient) {
                      return DataRow(
                        cells: [
                          DataCell(Text(patient['id'])),
                          DataCell(
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                                  child: Text(
                                    patient['name'].substring(0, 1),
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    patient['name'],
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DataCell(Text(patient['age'].toString())),
                          DataCell(Text(patient['treatmentType'])),
                          DataCell(Text(patient['stage'])),
                          DataCell(
                            patient['nextAppointment'] != null
                                ? Text(
                                    DateFormat('MMM d, h:mm a').format(patient['nextAppointment']),
                                  )
                                : const Text('N/A'),
                          ),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(patient['status']).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                patient['status'],
                                style: TextStyle(
                                  color: _getStatusColor(patient['status']),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.visibility_outlined),
                                  onPressed: () {
                                    // View patient details
                                    Navigator.pushNamed(
                                      context,
                                      '/patient_detail',
                                      arguments: patient,
                                    );
                                  },
                                  tooltip: 'View Details',
                                  iconSize: 20,
                                  color: Theme.of(context).primaryColor,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined),
                                  onPressed: () {
                                    // Edit patient
                                  },
                                  tooltip: 'Edit',
                                  iconSize: 20,
                                  color: const Color(0xFFE8C68E),
                                ),
                              ],
                            ),
                          ),
                        ],
                        onSelectChanged: (selected) {
                          if (selected == true) {
                            Navigator.pushNamed(
                              context,
                              '/patient_detail',
                              arguments: patient,
                            );
                          }
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return Theme.of(context).primaryColor;
      case 'New':
        return Theme.of(context).primaryColor;
      case 'Completed':
        return Theme.of(context).colorScheme.secondary;
      default:
        return Colors.grey[600]!;
    }
  }

  void _showAddPatientDialog() {
    final formKey = GlobalKey<FormState>();
    String name = '';
    String age = '';
    String email = '';
    String phone = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Patient'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (val) => val!.isEmpty ? 'Name is required' : null,
                onSaved: (val) => name = val!,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                onSaved: (val) => age = val!,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onSaved: (val) => email = val!,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone'),
                onSaved: (val) => phone = val!,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Patient $name added successfully (Age: $age, Email: $email, Phone: $phone)'),
                    backgroundColor: Colors.green,
                  ),
                );
                _showProtocolAssignmentOptions(name);
              }
            },
            child: const Text('Create Patient'),
          ),
        ],
      ),
    );
  }

  void _showProtocolAssignmentOptions(String patientName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Assign Protocol to $patientName'),
        content: const Text('Would you like to assign a treatment protocol to this patient now?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Skip'),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/protocols');
            },
            child: const Text('Select Preset'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to creating a custom protocol (mock)
              Navigator.pushNamed(context, '/protocols');
            },
            child: const Text('Create Custom'),
          ),
        ],
      ),
    );
  }
}

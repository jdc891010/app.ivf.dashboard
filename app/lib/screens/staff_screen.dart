import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class StaffScreen extends StatefulWidget {
  const StaffScreen({Key? key}) : super(key: key);

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedDepartment = 'All Departments';
  final List<String> _departmentOptions = [
    'All Departments',
    'Doctors',
    'Nurses',
    'Lab Technicians',
    'Administration',
  ];

  // Sample staff data
  final List<Map<String, dynamic>> _staffMembers = [
    {
      'id': 'S001',
      'name': 'Dr. Emily Thompson',
      'role': 'Fertility Specialist',
      'department': 'Doctors',
      'email': 'emily.thompson@ivfclinic.com',
      'phone': '+1 (555) 123-4567',
      'avatar': 'ET',
      'status': 'Active',
    },
    {
      'id': 'S002',
      'name': 'Dr. Robert Chen',
      'role': 'Reproductive Endocrinologist',
      'department': 'Doctors',
      'email': 'robert.chen@ivfclinic.com',
      'phone': '+1 (555) 234-5678',
      'avatar': 'RC',
      'status': 'Active',
    },
    {
      'id': 'S003',
      'name': 'Sarah Williams',
      'role': 'Nurse Practitioner',
      'department': 'Nurses',
      'email': 'sarah.williams@ivfclinic.com',
      'phone': '+1 (555) 345-6789',
      'avatar': 'SW',
      'status': 'Active',
    },
    {
      'id': 'S004',
      'name': 'Michael Johnson',
      'role': 'Lab Director',
      'department': 'Lab Technicians',
      'email': 'michael.johnson@ivfclinic.com',
      'phone': '+1 (555) 456-7890',
      'avatar': 'MJ',
      'status': 'Active',
    },
    {
      'id': 'S005',
      'name': 'Jessica Martinez',
      'role': 'Embryologist',
      'department': 'Lab Technicians',
      'email': 'jessica.martinez@ivfclinic.com',
      'phone': '+1 (555) 567-8901',
      'avatar': 'JM',
      'status': 'Active',
    },
    {
      'id': 'S006',
      'name': 'David Wilson',
      'role': 'Clinic Manager',
      'department': 'Administration',
      'email': 'david.wilson@ivfclinic.com',
      'phone': '+1 (555) 678-9012',
      'avatar': 'DW',
      'status': 'Active',
    },
    {
      'id': 'S007',
      'name': 'Lisa Anderson',
      'role': 'Nurse',
      'department': 'Nurses',
      'email': 'lisa.anderson@ivfclinic.com',
      'phone': '+1 (555) 789-0123',
      'avatar': 'LA',
      'status': 'On Leave',
    },
    {
      'id': 'S008',
      'name': 'James Taylor',
      'role': 'Andrologist',
      'department': 'Lab Technicians',
      'email': 'james.taylor@ivfclinic.com',
      'phone': '+1 (555) 890-1234',
      'avatar': 'JT',
      'status': 'Active',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredStaff {
    return _staffMembers.where((staff) {
      // Apply search filter
      final nameMatches = staff['name']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final roleMatches = staff['role']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final idMatches = staff['id']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final searchMatches = nameMatches || roleMatches || idMatches;

      // Apply department filter
      bool departmentMatches = true;
      if (_selectedDepartment != 'All Departments') {
        departmentMatches = staff['department'] == _selectedDepartment;
      }

      return searchMatches && departmentMatches;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            tooltip: 'Dashboard',
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, '/dashboard', (route) => false),
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
      drawer: const AppDrawer(currentRoute: '/staff'),
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
                  'Staff',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Add new staff member
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Staff Member'),
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
                      hintText: 'Search by name, role, or ID',
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

                // Department filter dropdown
                DropdownButton<String>(
                  value: _selectedDepartment,
                  items: _departmentOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedDepartment = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(width: 16),

                // Export button
                OutlinedButton.icon(
                  onPressed: () {
                    // Export staff data
                  },
                  icon: const Icon(Icons.download_outlined),
                  label: const Text('Export'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Staff count
            Text(
              '${filteredStaff.length} staff members found',
              style: const TextStyle(color: Color(0xFF6B6B6B)),
            ),
            const SizedBox(height: 16),

            // Staff grid
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final bool narrow = width < 900;
                  final int crossAxisCount = narrow ? 2 : 3;
                  final double childAspectRatio = narrow ? 0.85 : 0.70;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: childAspectRatio,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredStaff.length,
                    itemBuilder: (context, index) {
                      final staff = filteredStaff[index];
                      return _buildStaffCard(context, staff);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaffCard(BuildContext context, Map<String, dynamic> staff) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      staff['avatar'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          staff['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          staff['role'],
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getStatusColor(staff['status'])
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            staff['status'],
                            style: TextStyle(
                              color: _getStatusColor(staff['status']),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16), // Space instead of divider
              Row(
                children: [
                  const Icon(Icons.email_outlined,
                      size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      staff['email'],
                      style: TextStyle(color: Colors.grey[700], fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.phone_outlined,
                      size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    staff['phone'],
                    style: TextStyle(color: Colors.grey[700], fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () {},
                    tooltip: 'Edit',
                    iconSize: 20,
                    color: const Color(0xFFE8C68E),
                  ),
                  IconButton(
                    icon: const Icon(Icons.message_outlined),
                    onPressed: () {},
                    tooltip: 'Message',
                    iconSize: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return const Color(0xFF7FB685);
      case 'On Leave':
        return const Color(0xFFE8C68E);
      case 'Inactive':
        return const Color(0xFFE89B8E);
      default:
        return const Color(0xFF6B6B6B);
    }
  }
}

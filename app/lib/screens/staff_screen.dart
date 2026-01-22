import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/staff_provider.dart';
import 'staff_form_screen.dart';
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
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  final List<String> _departmentOptions = [
    'All Departments',
    'Doctors',
    'Nurses',
    'Lab Technicians',
    'Administration',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _sort<T>(Comparable<T> Function(Staff user) getField, int columnIndex, bool ascending, List<Staff> staffList) {
    staffList.sort((a, b) {
      if (!ascending) {
        final Staff c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return aValue.compareTo(bValue as T);
    });
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  List<Staff> getFilteredStaff(List<Staff> allStaff) {
    return allStaff.where((staff) {
      // Apply search filter
      final nameMatches = staff.name
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final roleMatches = staff.role
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final idMatches = staff.id
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final searchMatches = nameMatches || roleMatches || idMatches;

      // Apply department filter
      bool departmentMatches = true;
      if (_selectedDepartment != 'All Departments') {
        departmentMatches = staff.department == _selectedDepartment;
      }

      return searchMatches && departmentMatches;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final staffProvider = Provider.of<StaffProvider>(context);
    final filteredStaff = getFilteredStaff(staffProvider.staffMembers);

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
      drawer: const AppDrawer(currentRoute: '/staff'),
      body: staffProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Staff',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const StaffFormScreen()),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Staff Member'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
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
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.download_outlined),
                        label: const Text('Export'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${filteredStaff.length} staff members found',
                    style: const TextStyle(color: Color(0xFF6B6B6B)),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.withOpacity(0.2)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: DataTable2(
                        columnSpacing: 12,
                        horizontalMargin: 12,
                        minWidth: 800,
                        sortColumnIndex: _sortColumnIndex,
                        sortAscending: _sortAscending,
                        columns: [
                          DataColumn2(
                            label: const Text('Name'),
                            size: ColumnSize.L,
                            onSort: (columnIndex, ascending) =>
                                _sort<String>((d) => d.name, columnIndex, ascending, filteredStaff),
                          ),
                          DataColumn2(
                            label: const Text('Role'),
                            size: ColumnSize.M,
                            onSort: (columnIndex, ascending) =>
                                _sort<String>((d) => d.role, columnIndex, ascending, filteredStaff),
                          ),
                          const DataColumn2(
                            label: Text('Contact'),
                            size: ColumnSize.L,
                          ),
                          DataColumn2(
                            label: const Text('Status'),
                            size: ColumnSize.S,
                            onSort: (columnIndex, ascending) =>
                                _sort<String>((d) => d.status, columnIndex, ascending, filteredStaff),
                          ),
                          const DataColumn2(
                            label: Text('Notes'),
                            size: ColumnSize.L,
                          ),
                          const DataColumn2(
                            label: Text('Actions'),
                            size: ColumnSize.S,
                            numeric: true,
                          ),
                        ],
                        rows: List<DataRow>.generate(
                          filteredStaff.length,
                          (index) => _buildStaffRow(context, filteredStaff[index], staffProvider),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  DataRow _buildStaffRow(BuildContext context, Staff staff, StaffProvider provider) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Text(
                  staff.avatar,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    staff.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    staff.id,
                    style: TextStyle(color: Colors.grey[500], fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
        DataCell(Text(staff.role)),
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(Icons.email_outlined, size: 12, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(staff.email, style: const TextStyle(fontSize: 12)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.phone_outlined, size: 12, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(staff.phone, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: _getStatusColor(staff.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              staff.status,
              style: TextStyle(
                color: _getStatusColor(staff.status),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        DataCell(
          Row(
            children: [
              if (staff.notes.isNotEmpty)
                const Icon(Icons.note_alt_outlined, size: 16, color: Colors.grey),
              if (staff.notes.isNotEmpty) const SizedBox(width: 4),
              Expanded(
                child: Text(
                  staff.notes,
                  style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 14, color: Colors.grey),
                onPressed: () => _showEditNoteDialog(context, staff, provider),
                tooltip: 'Edit Note',
              )
            ],
          ),
        ),
        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StaffFormScreen(staff: staff)),
                  );
                },
                tooltip: 'Edit Details',
                color: Theme.of(context).primaryColor,
                iconSize: 20,
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _showDeleteConfirmation(context, staff, provider),
                tooltip: 'Remove',
                color: Colors.red[300],
                iconSize: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showEditNoteDialog(BuildContext context, Staff staff, StaffProvider provider) {
    final controller = TextEditingController(text: staff.notes);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Notes for ${staff.name}'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(hintText: 'Enter notes...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              provider.updateStaff(staff.copyWith(notes: controller.text));
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Staff staff, StaffProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to remove ${staff.name} from the staff list?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              provider.removeStaff(staff.id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
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

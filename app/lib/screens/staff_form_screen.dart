import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/staff_provider.dart';

class StaffFormScreen extends StatefulWidget {
  final Staff? staff;

  const StaffFormScreen({Key? key, this.staff}) : super(key: key);

  @override
  State<StaffFormScreen> createState() => _StaffFormScreenState();
}

class _StaffFormScreenState extends State<StaffFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _roleController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _notesController;
  late String _selectedDepartment;
  late String _selectedStatus;

  final List<String> _departments = [
    'Doctors',
    'Nurses',
    'Lab Technicians',
    'Administration',
  ];

  final List<String> _statuses = [
    'Active',
    'On Leave',
    'Inactive',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.staff?.name ?? '');
    _roleController = TextEditingController(text: widget.staff?.role ?? '');
    _emailController = TextEditingController(text: widget.staff?.email ?? '');
    _phoneController = TextEditingController(text: widget.staff?.phone ?? '');
    _notesController = TextEditingController(text: widget.staff?.notes ?? '');
    _selectedDepartment = widget.staff?.department ?? _departments[0];
    _selectedStatus = widget.staff?.status ?? _statuses[0];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final staffProvider = Provider.of<StaffProvider>(context, listen: false);
      
      final avatar = _nameController.text.isNotEmpty 
          ? _nameController.text.split(' ').map((e) => e[0]).take(2).join('').toUpperCase()
          : '??';

      if (widget.staff == null) {
        // Add new
        final newStaff = Staff(
          id: 'S${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
          name: _nameController.text,
          role: _roleController.text,
          department: _selectedDepartment,
          email: _emailController.text,
          phone: _phoneController.text,
          avatar: avatar,
          status: _selectedStatus,
          notes: _notesController.text,
        );
        staffProvider.addStaff(newStaff);
      } else {
        // Update existing
        final updatedStaff = widget.staff!.copyWith(
          name: _nameController.text,
          role: _roleController.text,
          department: _selectedDepartment,
          email: _emailController.text,
          phone: _phoneController.text,
          avatar: avatar,
          status: _selectedStatus,
          notes: _notesController.text,
        );
        staffProvider.updateStaff(updatedStaff);
      }
      
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.staff == null ? 'Add Staff Member' : 'Edit Staff Member'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Employee Details',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _roleController,
                              decoration: const InputDecoration(
                                labelText: 'Role',
                                prefixIcon: Icon(Icons.work_outline),
                              ),
                              validator: (value) => value!.isEmpty ? 'Please enter a role' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedDepartment,
                              decoration: const InputDecoration(
                                labelText: 'Department',
                                prefixIcon: Icon(Icons.business_outlined),
                              ),
                              items: _departments.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedDepartment = newValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email Address',
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              validator: (value) => value!.isEmpty ? 'Please enter an email' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _phoneController,
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                prefixIcon: Icon(Icons.phone_outlined),
                              ),
                              validator: (value) => value!.isEmpty ? 'Please enter a phone number' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          prefixIcon: Icon(Icons.info_outline),
                        ),
                        items: _statuses.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedStatus = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _notesController,
                        decoration: const InputDecoration(
                          labelText: 'Notes / Availability',
                          prefixIcon: Icon(Icons.note_alt_outlined),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: _saveForm,
                            child: Text(widget.staff == null ? 'Add Staff Member' : 'Save Changes'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

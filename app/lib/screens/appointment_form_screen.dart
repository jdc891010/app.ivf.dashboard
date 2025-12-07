import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentFormScreen extends StatefulWidget {
  const AppointmentFormScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentFormScreen> createState() => _AppointmentFormScreenState();
}

class _AppointmentFormScreenState extends State<AppointmentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final TextEditingController _patientSearchController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  
  // Form values
  Map<String, dynamic>? _selectedPatient;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedDuration = '30 minutes';
  String _selectedType = 'Consultation';
  Map<String, dynamic>? _existingAppointment;
  bool _isRescheduling = false;
  
  // Sample patients data (would come from API/database in real app)
  final List<Map<String, dynamic>> _patients = [
    {'id': 'P001', 'name': 'Sarah Johnson', 'age': 32, 'phone': '(555) 123-4567'},
    {'id': 'P002', 'name': 'Michael Roberts', 'age': 35, 'phone': '(555) 234-5678'},
    {'id': 'P003', 'name': 'Jennifer Davis', 'age': 29, 'phone': '(555) 345-6789'},
    {'id': 'P004', 'name': 'David Wilson', 'age': 38, 'phone': '(555) 456-7890'},
    {'id': 'P006', 'name': 'James Anderson', 'age': 34, 'phone': '(555) 567-8901'},
    {'id': 'P007', 'name': 'Jessica Martinez', 'age': 31, 'phone': '(555) 678-9012'},
  ];
  
  List<Map<String, dynamic>> _filteredPatients = [];
  
  final List<String> _appointmentTypes = [
    'Consultation',
    'Ultrasound Scan',
    'Blood Test',
    'Egg Retrieval',
    'Embryo Transfer',
    'Follow-up',
    'Medication Review',
    'Other',
  ];
  
  final List<String> _durationOptions = [
    '15 minutes',
    '30 minutes',
    '45 minutes',
    '1 hour',
    '1.5 hours',
    '2 hours',
  ];

  @override
  void initState() {
    super.initState();
    _durationController.text = _selectedDuration;
    _filteredPatients = _patients;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if we're rescheduling an existing appointment
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      if (args.containsKey('appointment')) {
        _existingAppointment = args['appointment'];
        _isRescheduling = true;
        _populateFormWithExistingAppointment();
      }
      
      if (args.containsKey('selectedDate')) {
        _selectedDate = args['selectedDate'];
        _dateController.text = DateFormat('MMM d, yyyy').format(_selectedDate);
      }
    }
    
    if (_dateController.text.isEmpty) {
      _dateController.text = DateFormat('MMM d, yyyy').format(_selectedDate);
    }
    
    if (_timeController.text.isEmpty) {
      _timeController.text = _selectedTime.format(context);
    }
  }
  
  void _populateFormWithExistingAppointment() {
    if (_existingAppointment != null) {
      // Find patient in list
      final patientId = _existingAppointment!['patientId'];
      _selectedPatient = _patients.firstWhere(
        (patient) => patient['id'] == patientId,
        orElse: () => {
          'id': patientId,
          'name': _existingAppointment!['patientName'],
          'age': 0,
          'phone': 'Unknown',
        },
      );
      
      _patientSearchController.text = _selectedPatient!['name'];
      
      // Set date and time
      if (_existingAppointment!['time'] is DateTime) {
        _selectedDate = _existingAppointment!['time'];
        _selectedTime = TimeOfDay.fromDateTime(_existingAppointment!['time']);
      } else {
        // Handle string time format if needed
        final timeParts = _existingAppointment!['time'].toString().split(':');
        if (timeParts.length >= 2) {
          _selectedTime = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
        }
      }
      
      _dateController.text = DateFormat('MMM d, yyyy').format(_selectedDate);
      _timeController.text = _selectedTime.format(context);
      
      // Set type and notes
      _selectedType = _existingAppointment!['type'];
      _purposeController.text = _selectedType;
      
      if (_existingAppointment!.containsKey('notes')) {
        _notesController.text = _existingAppointment!['notes'];
      }
      
      // Calculate duration
      if (_existingAppointment!.containsKey('endTime') && _existingAppointment!['endTime'] is DateTime) {
        final start = _existingAppointment!['time'] as DateTime;
        final end = _existingAppointment!['endTime'] as DateTime;
        final durationMinutes = end.difference(start).inMinutes;
        
        if (durationMinutes <= 15) {
          _selectedDuration = '15 minutes';
        } else if (durationMinutes <= 30) {
          _selectedDuration = '30 minutes';
        } else if (durationMinutes <= 45) {
          _selectedDuration = '45 minutes';
        } else if (durationMinutes <= 60) {
          _selectedDuration = '1 hour';
        } else if (durationMinutes <= 90) {
          _selectedDuration = '1.5 hours';
        } else {
          _selectedDuration = '2 hours';
        }
        
        _durationController.text = _selectedDuration;
      }
    }
  }

  @override
  void dispose() {
    _patientSearchController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _durationController.dispose();
    _purposeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isRescheduling ? 'Reschedule Appointment' : 'New Appointment'),
        actions: [
          TextButton.icon(
            onPressed: _saveAppointment,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save'),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Patient selection
              _buildPatientSelection(),
              
              const SizedBox(height: 24),
              
              // Date and time
              _buildDateTimeSection(),
              
              const SizedBox(height: 24),
              
              // Appointment details
              _buildAppointmentDetails(),
              
              const SizedBox(height: 32),
              
              // Action buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientSelection() {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Patient Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (_selectedPatient != null) ...[  
              // Selected patient info
              Row(
                children: [
                  const Icon(Icons.person, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedPatient!['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text('ID: ${_selectedPatient!['id']}'),
                        Text('Age: ${_selectedPatient!['age']}'),
                        Text('Phone: ${_selectedPatient!['phone']}'),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _selectedPatient = null;
                        _patientSearchController.clear();
                      });
                    },
                    tooltip: 'Clear Selection',
                  ),
                ],
              ),
            ] else ...[  
              // Patient search
              TextFormField(
                controller: _patientSearchController,
                decoration: const InputDecoration(
                  labelText: 'Search Patient',
                  hintText: 'Enter patient name or ID',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      _filteredPatients = _patients;
                    } else {
                      _filteredPatients = _patients.where((patient) {
                        return patient['name'].toLowerCase().contains(value.toLowerCase()) ||
                               patient['id'].toLowerCase().contains(value.toLowerCase());
                      }).toList();
                    }
                  });
                },
                validator: (value) {
                  if (_selectedPatient == null) {
                    return 'Please select a patient';
                  }
                  return null;
                },
              ),
              if (_patientSearchController.text.isNotEmpty) ...[  
                const SizedBox(height: 8),
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredPatients.length,
                    itemBuilder: (context, index) {
                      final patient = _filteredPatients[index];
                      return ListTile(
                        title: Text(patient['name']),
                        subtitle: Text('ID: ${patient['id']} | Age: ${patient['age']}'),
                        onTap: () {
                          setState(() {
                            _selectedPatient = patient;
                            _patientSearchController.text = patient['name'];
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeSection() {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Date & Time',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      
                      if (pickedDate != null) {
                        setState(() {
                          _selectedDate = pickedDate;
                          _dateController.text = DateFormat('MMM d, yyyy').format(pickedDate);
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a date';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _timeController,
                    decoration: const InputDecoration(
                      labelText: 'Time',
                      prefixIcon: Icon(Icons.access_time),
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: _selectedTime,
                      );
                      
                      if (pickedTime != null) {
                        setState(() {
                          _selectedTime = pickedTime;
                          _timeController.text = pickedTime.format(context);
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a time';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedDuration,
              decoration: const InputDecoration(
                labelText: 'Duration',
                prefixIcon: Icon(Icons.timelapse),
                border: OutlineInputBorder(),
              ),
              items: _durationOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedDuration = newValue;
                  });
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a duration';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentDetails() {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Appointment Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Appointment Type',
                prefixIcon: Icon(Icons.medical_services_outlined),
                border: OutlineInputBorder(),
              ),
              items: _appointmentTypes.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedType = newValue;
                    _purposeController.text = newValue;
                  });
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select an appointment type';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _purposeController,
              decoration: const InputDecoration(
                labelText: 'Purpose',
                hintText: 'Enter the purpose of the appointment',
                prefixIcon: Icon(Icons.subject),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the purpose';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Enter any additional notes',
                prefixIcon: Icon(Icons.note_outlined),
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: _saveAppointment,
          icon: const Icon(Icons.save),
          label: const Text('Save Appointment'),
        ),
      ],
    );
  }

  void _saveAppointment() {
    if (_formKey.currentState!.validate()) {
      // Create appointment object
      final appointmentId = _existingAppointment != null 
          ? _existingAppointment!['id']
          : 'A${DateTime.now().millisecondsSinceEpoch}';
      
      // Calculate end time based on duration
      final startTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );
      
      int durationMinutes = 30; // Default
      if (_selectedDuration == '15 minutes') {
        durationMinutes = 15;
      } else if (_selectedDuration == '30 minutes') {
        durationMinutes = 30;
      } else if (_selectedDuration == '45 minutes') {
        durationMinutes = 45;
      } else if (_selectedDuration == '1 hour') {
        durationMinutes = 60;
      } else if (_selectedDuration == '1.5 hours') {
        durationMinutes = 90;
      } else if (_selectedDuration == '2 hours') {
        durationMinutes = 120;
      }
      
      final endTime = startTime.add(Duration(minutes: durationMinutes));
      
      final appointment = {
        'id': appointmentId,
        'patientId': _selectedPatient!['id'],
        'patientName': _selectedPatient!['name'],
        'time': startTime,
        'endTime': endTime,
        'type': _selectedType,
        'notes': _notesController.text,
        'status': 'Scheduled',
      };
      
      // In a real app, save to database
      // For now, just return to previous screen with the appointment data
      Navigator.pop(context, appointment);
    }
  }
}

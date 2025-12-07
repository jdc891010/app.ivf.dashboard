import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;

  // Sample appointment data
  final Map<DateTime, List<Map<String, dynamic>>> _appointments = {};

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  void _loadAppointments() {
    // This would normally fetch from an API or database
    // For now, we'll use sample data
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    final dayAfterTomorrow = today.add(const Duration(days: 2));

    // Format dates to remove time component for comparison
    final todayFormatted = DateTime(today.year, today.month, today.day);
    final tomorrowFormatted = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
    final dayAfterTomorrowFormatted = DateTime(dayAfterTomorrow.year, dayAfterTomorrow.month, dayAfterTomorrow.day);

    _appointments[todayFormatted] = [
      {
        'id': 'A001',
        'patientId': 'P001',
        'patientName': 'Sarah Johnson',
        'time': DateTime(today.year, today.month, today.day, 9, 0),
        'endTime': DateTime(today.year, today.month, today.day, 9, 30),
        'type': 'Ultrasound Scan',
        'notes': 'Follicle monitoring',
        'status': 'Completed',
      },
      {
        'id': 'A002',
        'patientId': 'P002',
        'patientName': 'Michael Roberts',
        'time': DateTime(today.year, today.month, today.day, 10, 30),
        'endTime': DateTime(today.year, today.month, today.day, 11, 0),
        'type': 'Consultation',
        'notes': 'Treatment plan discussion',
        'status': 'Completed',
      },
      {
        'id': 'A003',
        'patientId': 'P003',
        'patientName': 'Jennifer Davis',
        'time': DateTime(today.year, today.month, today.day, 13, 15),
        'endTime': DateTime(today.year, today.month, today.day, 14, 0),
        'type': 'Embryo Transfer',
        'notes': 'Procedure room 2',
        'status': 'Scheduled',
      },
      {
        'id': 'A004',
        'patientId': 'P004',
        'patientName': 'David Wilson',
        'time': DateTime(today.year, today.month, today.day, 15, 0),
        'endTime': DateTime(today.year, today.month, today.day, 15, 30),
        'type': 'Follow-up',
        'notes': 'Post-treatment check',
        'status': 'Scheduled',
      },
    ];

    _appointments[tomorrowFormatted] = [
      {
        'id': 'A005',
        'patientId': 'P006',
        'patientName': 'James Anderson',
        'time': DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 9, 30),
        'endTime': DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 10, 0),
        'type': 'Blood Test',
        'notes': 'Hormone level check',
        'status': 'Scheduled',
      },
      {
        'id': 'A006',
        'patientId': 'P007',
        'patientName': 'Jessica Martinez',
        'time': DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 11, 45),
        'endTime': DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 12, 15),
        'type': 'Ultrasound Scan',
        'notes': 'Follicle monitoring',
        'status': 'Scheduled',
      },
    ];

    _appointments[dayAfterTomorrowFormatted] = [
      {
        'id': 'A007',
        'patientId': 'P002',
        'patientName': 'Michael Roberts',
        'time': DateTime(dayAfterTomorrow.year, dayAfterTomorrow.month, dayAfterTomorrow.day, 14, 15),
        'endTime': DateTime(dayAfterTomorrow.year, dayAfterTomorrow.month, dayAfterTomorrow.day, 15, 0),
        'type': 'Egg Retrieval',
        'notes': 'Procedure room 1',
        'status': 'Scheduled',
      },
    ];
  }

  List<Map<String, dynamic>> _getAppointmentsForDay(DateTime day) {
    // Format date to remove time component for comparison
    final formattedDay = DateTime(day.year, day.month, day.day);
    return _appointments[formattedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
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
                  'Appointment Schedule',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Add new appointment
                    Navigator.pushNamed(
                      context,
                      '/appointment_form',
                      arguments: {'selectedDate': _selectedDay},
                    ).then((result) {
                      if (result != null && result is Map<String, dynamic>) {
                        // Handle new appointment
                        setState(() {
                          final formattedDay = DateTime(
                            (result['time'] as DateTime).year,
                            (result['time'] as DateTime).month,
                            (result['time'] as DateTime).day,
                          );
                          
                          if (_appointments.containsKey(formattedDay)) {
                            _appointments[formattedDay]!.add(result);
                          } else {
                            _appointments[formattedDay] = [result];
                          }
                          
                          // Update selected day to show the new appointment
                          _selectedDay = formattedDay;
                          _focusedDay = formattedDay;
                        });
                      }
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('New Appointment'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Calendar
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TableCalendar(
                  firstDay: DateTime.utc(2023, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  eventLoader: (day) {
                    return _getAppointmentsForDay(day);
                  },
                  calendarStyle: CalendarStyle(
                    markersMaxCount: 3,
                    markerDecoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonDecoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    formatButtonTextStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    titleCentered: true,
                    formatButtonShowsNext: false,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Appointments for selected day
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Appointments for ${DateFormat('MMMM d, yyyy').format(_selectedDay)}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        // Print schedule
                      },
                      icon: const Icon(Icons.print_outlined),
                      label: const Text('Print'),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () {
                        // Export schedule
                      },
                      icon: const Icon(Icons.download_outlined),
                      label: const Text('Export'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Appointments list
            Expanded(
              child: _buildAppointmentsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsList() {
    final appointmentsForDay = _getAppointmentsForDay(_selectedDay);
    
    if (appointmentsForDay.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No appointments scheduled for this day',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Schedule appointment
                Navigator.pushNamed(
                  context,
                  '/appointment_form',
                  arguments: {'selectedDate': _selectedDay},
                ).then((result) {
                  if (result != null && result is Map<String, dynamic>) {
                    // Handle new appointment
                    setState(() {
                      final formattedDay = DateTime(
                        (result['time'] as DateTime).year,
                        (result['time'] as DateTime).month,
                        (result['time'] as DateTime).day,
                      );
                      
                      if (_appointments.containsKey(formattedDay)) {
                        _appointments[formattedDay]!.add(result);
                      } else {
                        _appointments[formattedDay] = [result];
                      }
                      
                      // Update selected day to show the new appointment
                      _selectedDay = formattedDay;
                      _focusedDay = formattedDay;
                    });
                  }
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Schedule Appointment'),
            ),
          ],
        ),
      );
    }

    // Sort appointments by time
    appointmentsForDay.sort((a, b) => a['time'].compareTo(b['time']));

    return ListView.builder(
      itemCount: appointmentsForDay.length,
      itemBuilder: (context, index) {
        final appointment = appointmentsForDay[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('h:mm').format(appointment['time']),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      DateFormat('a').format(appointment['time']),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat('h:mm').format(appointment['endTime']),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Text(
                      DateFormat('a').format(appointment['endTime']),
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                
                // Appointment details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            appointment['type'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _buildStatusBadge(appointment['status']),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            appointment['patientName'],
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.badge_outlined, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            appointment['patientId'],
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      if (appointment['notes'] != null && appointment['notes'].isNotEmpty) ...[  
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.notes_outlined, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              appointment['notes'],
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Action buttons
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.note_add_outlined),
                      onPressed: () {
                        // Add medical notes
                        Navigator.pushNamed(
                          context,
                          '/medical_notes',
                          arguments: {
                            'appointment': appointment,
                            'patient': {
                              'id': appointment['patientId'],
                              'name': appointment['patientName'],
                              'age': '35', // This would come from patient data in a real app
                            },
                          },
                        );
                      },
                      tooltip: 'Add Medical Notes',
                      color: Colors.green,
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_calendar_outlined),
                      onPressed: () {
                        // Reschedule appointment
                        Navigator.pushNamed(
                          context,
                          '/appointment_form',
                          arguments: {'appointment': appointment},
                        ).then((result) {
                          if (result != null && result is Map<String, dynamic>) {
                            // Handle rescheduled appointment
                            setState(() {
                              // Remove old appointment
                              final oldFormattedDay = DateTime(
                                (appointment['time'] as DateTime).year,
                                (appointment['time'] as DateTime).month,
                                (appointment['time'] as DateTime).day,
                              );
                              
                              _appointments[oldFormattedDay]?.removeWhere(
                                (a) => a['id'] == appointment['id']
                              );
                              
                              // Add updated appointment
                              final newFormattedDay = DateTime(
                                (result['time'] as DateTime).year,
                                (result['time'] as DateTime).month,
                                (result['time'] as DateTime).day,
                              );
                              
                              if (_appointments.containsKey(newFormattedDay)) {
                                _appointments[newFormattedDay]!.add(result);
                              } else {
                                _appointments[newFormattedDay] = [result];
                              }
                              
                              // Update selected day to show the rescheduled appointment
                              _selectedDay = newFormattedDay;
                              _focusedDay = newFormattedDay;
                            });
                          }
                        });
                      },
                      tooltip: 'Reschedule',
                      color: Colors.blue,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        // Delete appointment
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Cancel Appointment'),
                              content: const Text('Are you sure you want to cancel this appointment?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    // Cancel appointment logic
                                    setState(() {
                                      final formattedDay = DateTime(
                                        (appointment['time'] as DateTime).year,
                                        (appointment['time'] as DateTime).month,
                                        (appointment['time'] as DateTime).day,
                                      );
                                      
                                      // Update status to cancelled
                                      final index = _appointments[formattedDay]?.indexWhere(
                                        (a) => a['id'] == appointment['id']
                                      ) ?? -1;
                                      
                                      if (index != -1) {
                                        _appointments[formattedDay]![index]['status'] = 'Cancelled';
                                      }
                                    });
                                  },
                                  child: const Text('Yes, Cancel'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      tooltip: 'Cancel',
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'Completed':
        color = Colors.green;
        break;
      case 'Scheduled':
        color = const Color(0xFF8BA888);
        break;
      case 'Cancelled':
        color = Colors.red;
        break;
      case 'No Show':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
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
            isSelected: true,
            onTap: () => Navigator.pop(context),
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

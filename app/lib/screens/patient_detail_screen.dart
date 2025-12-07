import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PatientDetailScreen extends StatefulWidget {
  const PatientDetailScreen({Key? key}) : super(key: key);

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? patientData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get patient data from route arguments
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      patientData = args;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (patientData == null) {
      return const Scaffold(
        body: Center(
          child: Text('Patient data not found'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Patient: ${patientData!['name']}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            tooltip: 'Dashboard',
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              // Edit patient
            },
            tooltip: 'Edit Patient',
          ),

          IconButton(
            icon: const Icon(Icons.print_outlined),
            onPressed: () {
              // Print patient record
            },
            tooltip: 'Print Record',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildPatientHeader(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildTreatmentTab(),
                _buildAppointmentsTab(),
                _buildMedicalRecordsTab(),
                _buildMessagesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Patient avatar
          CircleAvatar(
            radius: 40,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              patientData!['name'].substring(0, 1),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 24),
          
          // Patient basic info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      patientData!['name'],
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(patientData!['status']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        patientData!['status'],
                        style: TextStyle(
                          color: _getStatusColor(patientData!['status']),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(patientData!['priority']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${patientData!['priority']} Priority',
                        style: TextStyle(
                          color: _getPriorityColor(patientData!['priority']),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildInfoItem(Icons.badge_outlined, 'ID: ${patientData!['id']}'),
                    _buildInfoItem(Icons.cake_outlined, '${patientData!['age']} years old'),
                    _buildInfoItem(
                      Icons.calendar_today_outlined,
                      'Started: ${DateFormat('MMM d, yyyy').format(patientData!['startDate'])}',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildInfoItem(Icons.email_outlined, patientData!['email']),
                    _buildInfoItem(Icons.phone_outlined, patientData!['phone']),
                  ],
                ),
              ],
            ),
          ),
          
          // Quick action buttons
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  // Schedule appointment
                },
                icon: const Icon(Icons.calendar_month_outlined),
                label: const Text('Schedule Appointment'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () {
                  // Send message
                },
                icon: const Icon(Icons.message_outlined),
                label: const Text('Send Message'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 24.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Colors.grey[700],
        indicatorColor: Theme.of(context).primaryColor,
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Treatment Plan'),
          Tab(text: 'Appointments'),
          Tab(text: 'Medical Records'),
          Tab(text: 'Messages'),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Treatment summary card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Treatment Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryItem(
                          'Treatment Type',
                          patientData!['treatmentType'],
                          Icons.medical_services_outlined,
                        ),
                      ),
                      Expanded(
                        child: _buildSummaryItem(
                          'Current Stage',
                          patientData!['stage'],
                          Icons.timeline_outlined,
                        ),
                      ),
                      Expanded(
                        child: _buildSummaryItem(
                          'Next Appointment',
                          patientData!['nextAppointment'] != null
                              ? DateFormat('MMM d, h:mm a').format(patientData!['nextAppointment'])
                              : 'None Scheduled',
                          Icons.event_outlined,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Progress and stats
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Treatment progress
              Expanded(
                flex: 2,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Treatment Progress',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildTreatmentTimeline(),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Hormone levels
              Expanded(
                flex: 1,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Latest Hormone Levels',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildHormoneLevels(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Recent activities
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Activities',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildRecentActivities(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildTreatmentTimeline() {
    // Sample timeline data
    final List<Map<String, dynamic>> timelineItems = [
      {
        'title': 'Initial Consultation',
        'date': DateTime(2025, 2, 15),
        'description': 'Initial assessment and treatment plan discussion',
        'completed': true,
      },
      {
        'title': 'Ovarian Stimulation',
        'date': DateTime(2025, 3, 1),
        'description': 'Started medication for ovarian stimulation',
        'completed': true,
      },
      {
        'title': 'Monitoring',
        'date': DateTime(2025, 3, 10),
        'description': 'Ultrasound and blood tests to monitor follicle development',
        'completed': true,
      },
      {
        'title': 'Egg Retrieval',
        'date': DateTime(2025, 3, 15),
        'description': 'Procedure to collect mature eggs',
        'completed': patientData!['stage'] == 'Egg Retrieval' || patientData!['stage'] == 'Embryo Transfer',
      },
      {
        'title': 'Embryo Transfer',
        'date': DateTime(2025, 3, 20),
        'description': 'Transfer of embryos to the uterus',
        'completed': patientData!['stage'] == 'Embryo Transfer',
      },
      {
        'title': 'Pregnancy Test',
        'date': DateTime(2025, 4, 5),
        'description': 'Blood test to confirm pregnancy',
        'completed': false,
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: timelineItems.length,
      itemBuilder: (context, index) {
        final item = timelineItems[index];
        final isLast = index == timelineItems.length - 1;
        
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item['completed'] ? Colors.green : Colors.grey[300],
                    border: Border.all(
                      color: item['completed'] ? Colors.green : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  child: item['completed']
                      ? const Icon(Icons.check, size: 12, color: Colors.white)
                      : null,
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 50,
                    color: timelineItems[index + 1]['completed'] ? Colors.green : Colors.grey[300],
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          DateFormat('MMM d, yyyy').format(item['date']),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['description'],
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHormoneLevels() {
    // Sample hormone data
    final List<Map<String, dynamic>> hormoneData = [
      {
        'name': 'Estradiol',
        'value': '225 pg/mL',
        'range': '150-300 pg/mL',
        'status': 'normal',
      },
      {
        'name': 'FSH',
        'value': '6.5 mIU/mL',
        'range': '3.5-12.5 mIU/mL',
        'status': 'normal',
      },
      {
        'name': 'LH',
        'value': '5.2 mIU/mL',
        'range': '2.4-12.6 mIU/mL',
        'status': 'normal',
      },
      {
        'name': 'Progesterone',
        'value': '0.8 ng/mL',
        'range': '0.1-1.5 ng/mL',
        'status': 'normal',
      },
      {
        'name': 'AMH',
        'value': '2.1 ng/mL',
        'range': '1.0-3.5 ng/mL',
        'status': 'normal',
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: hormoneData.length,
      itemBuilder: (context, index) {
        final hormone = hormoneData[index];
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    hormone['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    hormone['value'],
                    style: TextStyle(
                      color: _getHormoneStatusColor(hormone['status']),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Normal range: ${hormone['range']}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: 0.6, // This would be calculated based on actual values
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(_getHormoneStatusColor(hormone['status'])),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecentActivities() {
    // Sample activities
    final List<Map<String, dynamic>> activities = [
      {
        'type': 'appointment',
        'title': 'Ultrasound Scan',
        'description': 'Follicle monitoring ultrasound completed',
        'date': DateTime(2025, 3, 25, 10, 30),
        'icon': Icons.medical_services_outlined,
        'color': Colors.blue,
      },
      {
        'type': 'lab',
        'title': 'Blood Test Results',
        'description': 'Hormone levels within normal range',
        'date': DateTime(2025, 3, 25, 9, 0),
        'icon': Icons.science_outlined,
        'color': Colors.green,
      },
      {
        'type': 'medication',
        'title': 'Medication Updated',
        'description': 'Gonal-F dosage adjusted to 225 IU',
        'date': DateTime(2025, 3, 24, 14, 0),
        'icon': Icons.medication_outlined,
        'color': Colors.orange,
      },
      {
        'type': 'message',
        'title': 'Message Sent',
        'description': 'Instructions for medication administration',
        'date': DateTime(2025, 3, 23, 16, 45),
        'icon': Icons.message_outlined,
        'color': const Color(0xFF8BA888),
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: activity['color'].withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  activity['icon'],
                  color: activity['color'],
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity['description'],
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                DateFormat('MMM d, h:mm a').format(activity['date']),
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTreatmentTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Treatment protocol card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Treatment Protocol',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          // Edit protocol
                        },
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('Edit Protocol'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildProtocolDetails(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Medication schedule
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Medication Schedule',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          // Add medication
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Medication'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildMedicationSchedule(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Follicle monitoring
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Follicle Monitoring',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          // Add new monitoring
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add New Entry'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildFollicleMonitoring(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Notes and observations
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notes & Observations',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildNotesAndObservations(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProtocolDetails() {
    // Sample protocol data
    final Map<String, dynamic> protocol = {
      'name': 'Long Protocol with Antagonist',
      'startDate': DateTime(2025, 2, 15),
      'currentPhase': 'Ovarian Stimulation',
      'estimatedEggRetrieval': DateTime(2025, 3, 15),
      'estimatedEmbryoTransfer': DateTime(2025, 3, 20),
      'notes': 'Patient responding well to stimulation. Follicle growth as expected.',
      'medications': [
        {
          'name': 'Gonal-F',
          'dosage': '225 IU',
          'frequency': 'Daily',
          'duration': '10-12 days',
          'phase': 'Stimulation',
        },
        {
          'name': 'Cetrotide',
          'dosage': '0.25 mg',
          'frequency': 'Daily',
          'duration': '5-6 days',
          'phase': 'Prevention of premature ovulation',
        },
        {
          'name': 'Ovidrel',
          'dosage': '250 mcg',
          'frequency': 'Once',
          'duration': '1 day',
          'phase': 'Trigger',
        },
      ],
      'duration': '4-5 weeks',
      'successRate': '38%',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildInfoField(
                'Protocol Type',
                protocol['name'],
              ),
            ),
            Expanded(
              child: _buildInfoField(
                'Start Date',
                DateFormat('MMM d, yyyy').format(protocol['startDate']),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildInfoField(
                'Current Phase',
                protocol['currentPhase'],
              ),
            ),
            Expanded(
              child: _buildInfoField(
                'Est. Egg Retrieval',
                DateFormat('MMM d, yyyy').format(protocol['estimatedEggRetrieval']),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildInfoField(
                'Est. Embryo Transfer',
                DateFormat('MMM d, yyyy').format(protocol['estimatedEmbryoTransfer']),
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Notes:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(protocol['notes']),
      ],
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildMedicationSchedule() {
    // Sample medication data
    final List<Map<String, dynamic>> medications = [
      {
        'name': 'Gonal-F',
        'dosage': '225 IU',
        'frequency': 'Once daily',
        'startDate': DateTime(2025, 3, 1),
        'endDate': DateTime(2025, 3, 14),
        'instructions': 'Subcutaneous injection in the evening (6-8 PM)',
        'status': 'Active',
      },
      {
        'name': 'Cetrotide',
        'dosage': '0.25 mg',
        'frequency': 'Once daily',
        'startDate': DateTime(2025, 3, 5),
        'endDate': DateTime(2025, 3, 14),
        'instructions': 'Subcutaneous injection in the morning (7-9 AM)',
        'status': 'Active',
      },
      {
        'name': 'Progesterone',
        'dosage': '100 mg',
        'frequency': 'Twice daily',
        'startDate': DateTime(2025, 3, 20),
        'endDate': null,
        'instructions': 'Vaginal suppository, morning and evening',
        'status': 'Scheduled',
      },
    ];

    return Column(
      children: [
        for (final medication in medications)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: _buildMedicationItem(medication),
          ),
      ],
    );
  }

  Widget _buildMedicationItem(Map<String, dynamic> medication) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.medication_outlined,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      medication['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getMedicationStatusColor(medication['status']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    medication['status'],
                    style: TextStyle(
                      color: _getMedicationStatusColor(medication['status']),
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
                Expanded(
                  child: _buildInfoField(
                    'Dosage',
                    medication['dosage'],
                  ),
                ),
                Expanded(
                  child: _buildInfoField(
                    'Frequency',
                    medication['frequency'],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildInfoField(
                    'Start Date',
                    DateFormat('MMM d, yyyy').format(medication['startDate']),
                  ),
                ),
                Expanded(
                  child: _buildInfoField(
                    'End Date',
                    medication['endDate'] != null
                        ? DateFormat('MMM d, yyyy').format(medication['endDate'])
                        : 'Ongoing',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildInfoField(
              'Instructions',
              medication['instructions'],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // Edit medication
                  },
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Edit'),
                ),
                TextButton.icon(
                  onPressed: () {
                    // Delete medication
                  },
                  icon: const Icon(Icons.delete_outline, size: 16),
                  label: const Text('Delete'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFollicleMonitoring() {
    // Sample follicle monitoring data
    final List<Map<String, dynamic>> monitoringData = [
      {
        'date': DateTime(2025, 3, 5),
        'day': 5,
        'rightOvary': [
          {'size': 10, 'count': 3},
          {'size': 8, 'count': 5},
        ],
        'leftOvary': [
          {'size': 11, 'count': 2},
          {'size': 9, 'count': 4},
        ],
        'endometriumThickness': 6.5,
        'estradiolLevel': 150,
        'notes': 'Good initial response to stimulation',
      },
      {
        'date': DateTime(2025, 3, 8),
        'day': 8,
        'rightOvary': [
          {'size': 14, 'count': 3},
          {'size': 12, 'count': 4},
          {'size': 10, 'count': 2},
        ],
        'leftOvary': [
          {'size': 15, 'count': 2},
          {'size': 13, 'count': 3},
          {'size': 11, 'count': 2},
        ],
        'endometriumThickness': 8.2,
        'estradiolLevel': 420,
        'notes': 'Follicles growing as expected',
      },
      {
        'date': DateTime(2025, 3, 11),
        'day': 11,
        'rightOvary': [
          {'size': 18, 'count': 2},
          {'size': 16, 'count': 3},
          {'size': 14, 'count': 2},
        ],
        'leftOvary': [
          {'size': 19, 'count': 1},
          {'size': 17, 'count': 2},
          {'size': 15, 'count': 3},
        ],
        'endometriumThickness': 9.8,
        'estradiolLevel': 1250,
        'notes': 'Good progress, trigger shot scheduled soon',
      },
    ];

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(flex: 1, child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]))),
                Expanded(flex: 1, child: Text('Day', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]))),
                Expanded(flex: 2, child: Text('Right Ovary', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]))),
                Expanded(flex: 2, child: Text('Left Ovary', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]))),
                Expanded(flex: 1, child: Text('Endo. (mm)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]))),
                Expanded(flex: 1, child: Text('E2 (pg/mL)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]))),
                Expanded(flex: 1, child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]))),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        for (final data in monitoringData.reversed)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: _buildMonitoringRow(data),
          ),
      ],
    );
  }

  Widget _buildMonitoringRow(Map<String, dynamic> data) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Date
            Expanded(
              flex: 1,
              child: Text(
                DateFormat('MM/dd').format(data['date']),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Day
            Expanded(
              flex: 1,
              child: Text(
                'Day ${data['day']}',
              ),
            ),
            // Right Ovary
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final follicle in data['rightOvary'])
                    Text('${follicle['size']}mm × ${follicle['count']}'),
                ],
              ),
            ),
            // Left Ovary
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final follicle in data['leftOvary'])
                    Text('${follicle['size']}mm × ${follicle['count']}'),
                ],
              ),
            ),
            // Endometrium
            Expanded(
              flex: 1,
              child: Text(
                data['endometriumThickness'].toString(),
              ),
            ),
            // Estradiol
            Expanded(
              flex: 1,
              child: Text(
                data['estradiolLevel'].toString(),
              ),
            ),
            // Actions
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    onPressed: () {
                      // Edit monitoring data
                    },
                    tooltip: 'Edit',
                    color: Colors.orange,
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline, size: 16),
                    onPressed: () {
                      // Show detailed info
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Monitoring - Day ${data['day']}'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Date: ${DateFormat('MMMM d, yyyy').format(data['date'])}'),
                              const SizedBox(height: 8),
                              Text('Notes: ${data['notes']}'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                    tooltip: 'Details',
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesAndObservations() {
    // Sample notes data
    final List<Map<String, dynamic>> notes = [
      {
        'date': DateTime(2025, 3, 11),
        'author': 'Dr. Emily Thompson',
        'content': 'Patient is responding well to stimulation. Follicle growth is consistent with expectations. Recommend continuing current protocol.',
        'type': 'Clinical Note',
      },
      {
        'date': DateTime(2025, 3, 8),
        'author': 'Sarah Williams, NP',
        'content': 'Patient reported mild bloating and discomfort. Advised to increase fluid intake and monitor symptoms. No signs of OHSS at this time.',
        'type': 'Observation',
      },
      {
        'date': DateTime(2025, 3, 5),
        'author': 'Dr. Emily Thompson',
        'content': 'Initial response to stimulation is promising. Baseline ultrasound shows good antral follicle count. Starting Gonal-F at 225 IU daily.',
        'type': 'Clinical Note',
      },
    ];

    return Column(
      children: [
        // Add note button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              // Add new note
            },
            icon: const Icon(Icons.add),
            label: const Text('Add New Note'),
          ),
        ),
        const SizedBox(height: 16),
        
        // Notes list
        for (final note in notes)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: _buildNoteItem(note),
          ),
      ],
    );
  }

  Widget _buildNoteItem(Map<String, dynamic> note) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        note['type'],
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('MMM d, yyyy').format(note['date']),
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      onPressed: () {
                        // Edit note
                      },
                      tooltip: 'Edit',
                      color: Colors.orange,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 16),
                      onPressed: () {
                        // Delete note
                      },
                      tooltip: 'Delete',
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              note['author'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(note['content']),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsTab() {
    // Sample appointments data
    final List<Map<String, dynamic>> appointments = [
      {
        'id': 'A001',
        'date': DateTime.now().add(const Duration(days: 2, hours: 10)),
        'type': 'Monitoring Ultrasound',
        'doctor': 'Dr. Emily Thompson',
        'location': 'Main Clinic - Room 3',
        'duration': 30,
        'notes': 'Follicle monitoring for current IVF cycle',
        'status': 'Scheduled',
      },
      {
        'id': 'A002',
        'date': DateTime.now().add(const Duration(days: 7, hours: 9)),
        'type': 'Egg Retrieval',
        'doctor': 'Dr. Emily Thompson',
        'location': 'Surgery Center - Room 2',
        'duration': 60,
        'notes': 'Patient should arrive 1 hour before procedure. NPO after midnight.',
        'status': 'Scheduled',
      },
      {
        'id': 'A003',
        'date': DateTime.now().subtract(const Duration(days: 3, hours: 11)),
        'type': 'Initial Consultation',
        'doctor': 'Dr. Emily Thompson',
        'location': 'Main Clinic - Room 5',
        'duration': 45,
        'notes': 'Initial consultation to discuss treatment options',
        'status': 'Completed',
      },
      {
        'id': 'A004',
        'date': DateTime.now().subtract(const Duration(days: 10, hours: 14)),
        'type': 'Blood Test',
        'doctor': 'Sarah Williams, NP',
        'location': 'Lab - First Floor',
        'duration': 15,
        'notes': 'Baseline hormone levels',
        'status': 'Completed',
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header and actions row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Appointments',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Schedule new appointment
                },
                icon: const Icon(Icons.add),
                label: const Text('Schedule New'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Upcoming appointments section
          Text(
            'Upcoming Appointments',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          
          // Upcoming appointments list
          ...appointments
              .where((appointment) => appointment['date'].isAfter(DateTime.now()))
              .map((appointment) => _buildAppointmentCard(appointment, isUpcoming: true))
              .toList(),
          
          const SizedBox(height: 32),
          
          // Past appointments section
          Text(
            'Past Appointments',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          
          // Past appointments list
          ...appointments
              .where((appointment) => appointment['date'].isBefore(DateTime.now()))
              .map((appointment) => _buildAppointmentCard(appointment, isUpcoming: false))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment, {required bool isUpcoming}) {
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
                // Date indicator
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUpcoming 
                        ? Theme.of(context).primaryColor.withOpacity(0.1) 
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        DateFormat('dd').format(appointment['date']),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isUpcoming ? Theme.of(context).primaryColor : Colors.grey[700],
                        ),
                      ),
                      Text(
                        DateFormat('MMM').format(appointment['date']),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isUpcoming ? Theme.of(context).primaryColor : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                
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
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getAppointmentStatusColor(appointment['status']).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              appointment['status'],
                              style: TextStyle(
                                color: _getAppointmentStatusColor(appointment['status']),
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
                          const Icon(Icons.access_time, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '${DateFormat('h:mm a').format(appointment['date'])} (${appointment['duration']} min)',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            appointment['doctor'],
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            appointment['location'],
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Notes section if available
            if (appointment['notes'] != null && appointment['notes'].isNotEmpty) ...[  
              const Divider(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.notes_outlined, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      appointment['notes'],
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    ),
                  ),
                ],
              ),
            ],
            
            // Action buttons
            if (isUpcoming) ...[  
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      // Reschedule appointment
                    },
                    icon: const Icon(Icons.calendar_month_outlined, size: 16),
                    label: const Text('Reschedule'),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // Cancel appointment
                    },
                    icon: const Icon(Icons.cancel_outlined, size: 16),
                    label: const Text('Cancel'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getAppointmentStatusColor(String status) {
    switch (status) {
      case 'Scheduled':
        return const Color(0xFF8BA888);
      case 'Completed':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      case 'No Show':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _buildMedicalRecordsTab() {
    // Sample medical records data
    final List<Map<String, dynamic>> medicalRecords = [
      {
        'id': 'MR001',
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'type': 'Lab Result',
        'title': 'Hormone Panel',
        'provider': 'Dr. Emily Thompson',
        'summary': 'Estradiol: 225 pg/mL, FSH: 8.5 mIU/mL, LH: 7.2 mIU/mL, Progesterone: 0.4 ng/mL',
        'category': 'Fertility',
        'fileType': 'PDF',
        'fileSize': '1.2 MB',
      },
      {
        'id': 'MR002',
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'type': 'Ultrasound',
        'title': 'Baseline Ultrasound',
        'provider': 'Dr. Emily Thompson',
        'summary': 'Endometrial thickness: 7mm. Right ovary: 6 antral follicles. Left ovary: 5 antral follicles.',
        'category': 'Imaging',
        'fileType': 'DICOM',
        'fileSize': '24.5 MB',
      },
      {
        'id': 'MR003',
        'date': DateTime.now().subtract(const Duration(days: 14)),
        'type': 'Medical History',
        'title': 'Initial Assessment',
        'provider': 'Dr. Emily Thompson',
        'summary': 'Patient history, physical examination, and initial fertility assessment.',
        'category': 'Consultation',
        'fileType': 'PDF',
        'fileSize': '3.4 MB',
      },
      {
        'id': 'MR004',
        'date': DateTime.now().subtract(const Duration(days: 30)),
        'type': 'Lab Result',
        'title': 'AMH Test',
        'provider': 'Dr. Robert Chen',
        'summary': 'Anti-Müllerian Hormone: 2.5 ng/mL',
        'category': 'Fertility',
        'fileType': 'PDF',
        'fileSize': '0.8 MB',
      },
      {
        'id': 'MR005',
        'date': DateTime.now().subtract(const Duration(days: 30)),
        'type': 'Medical History',
        'title': 'Previous Medical Records',
        'provider': 'External Provider',
        'summary': 'Previous medical history from referring physician.',
        'category': 'General',
        'fileType': 'PDF',
        'fileSize': '5.7 MB',
      },
    ];

    // Group records by category
    final Map<String, List<Map<String, dynamic>>> recordsByCategory = {};
    for (final record in medicalRecords) {
      final category = record['category'] as String;
      if (!recordsByCategory.containsKey(category)) {
        recordsByCategory[category] = [];
      }
      recordsByCategory[category]!.add(record);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header and actions row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Medical Records',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      // Import records
                    },
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Import'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Add new record
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add New'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Records by category
          for (final category in recordsByCategory.keys) ...[  
            Text(
              category,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...recordsByCategory[category]!
                .map((record) => _buildMedicalRecordCard(record))
                .toList(),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }

  Widget _buildMedicalRecordCard(Map<String, dynamic> record) {
    // Get icon based on record type
    IconData recordIcon;
    switch (record['type']) {
      case 'Lab Result':
        recordIcon = Icons.science_outlined;
        break;
      case 'Ultrasound':
        recordIcon = Icons.image_outlined;
        break;
      case 'Medical History':
        recordIcon = Icons.history_edu_outlined;
        break;
      default:
        recordIcon = Icons.description_outlined;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Record type icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                recordIcon,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            
            // Record details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          record['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          record['fileType'],
                          style: TextStyle(
                            color: Colors.grey[700],
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
                      const Icon(Icons.category_outlined, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        record['type'],
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MMM d, yyyy').format(record['date']),
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        record['provider'],
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    record['summary'],
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        record['fileSize'],
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {
                          // View record
                        },
                        icon: const Icon(Icons.visibility_outlined, size: 16),
                        label: const Text('View'),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          // Download record
                        },
                        icon: const Icon(Icons.download_outlined, size: 16),
                        label: const Text('Download'),
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

  Widget _buildMessagesTab() {
    // Sample messages data
    final List<Map<String, dynamic>> messages = [
      {
        'id': 'MSG001',
        'date': DateTime.now().subtract(const Duration(hours: 3)),
        'sender': 'Patient',
        'content': 'Hello Dr. Thompson, I\'ve been experiencing some mild cramping since yesterday. Is this normal during stimulation?',
        'isRead': false,
        'attachments': [],
      },
      {
        'id': 'MSG002',
        'date': DateTime.now().subtract(const Duration(days: 1, hours: 14)),
        'sender': 'Dr. Emily Thompson',
        'content': 'Your blood test results look good. Your estradiol levels are rising appropriately. Please continue with your current medication dosage.',
        'isRead': true,
        'attachments': [
          {'name': 'Blood_Test_Results.pdf', 'size': '1.2 MB'}
        ],
      },
      {
        'id': 'MSG003',
        'date': DateTime.now().subtract(const Duration(days: 1, hours: 16)),
        'sender': 'Patient',
        'content': 'Thank you for sending my test results. When should I come in for my next monitoring appointment?',
        'isRead': true,
        'attachments': [],
      },
      {
        'id': 'MSG004',
        'date': DateTime.now().subtract(const Duration(days: 2, hours: 9)),
        'sender': 'Dr. Emily Thompson',
        'content': 'Good morning! Just a reminder that you have an ultrasound scheduled for tomorrow at 9:00 AM. Please arrive 15 minutes early to check in.',
        'isRead': true,
        'attachments': [],
      },
      {
        'id': 'MSG005',
        'date': DateTime.now().subtract(const Duration(days: 5, hours: 11)),
        'sender': 'Patient',
        'content': 'I\'ve just picked up my medications from the pharmacy. I want to confirm the dosage: Gonal-F 225 IU and Menopur 75 IU daily, is that correct?',
        'isRead': true,
        'attachments': [
          {'name': 'Medication_List.jpg', 'size': '0.8 MB'}
        ],
      },
    ];

    // Count unread messages
    final int unreadCount = messages.where((msg) => !msg['isRead'] && msg['sender'] == 'Patient').length;

    return Column(
      children: [
        // Header with unread count and compose button
        Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Messages',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  if (unreadCount > 0) ...[  
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$unreadCount unread',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Compose new message
                },
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Compose'),
              ),
            ],
          ),
        ),
        
        // Messages list
        Expanded(
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return _buildMessageItem(message);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMessageItem(Map<String, dynamic> message) {
    final bool isUnread = !message['isRead'] && message['sender'] == 'Patient';
    final bool isFromPatient = message['sender'] == 'Patient';
    
    return Container(
      decoration: BoxDecoration(
        color: isUnread ? Colors.blue.withOpacity(0.05) : Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Message header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Sender avatar
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: isFromPatient 
                          ? Colors.orange 
                          : Theme.of(context).primaryColor,
                      child: Text(
                        isFromPatient 
                            ? message['sender'].substring(0, 1) 
                            : 'D',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    
                    // Sender name
                    Text(
                      message['sender'],
                      style: TextStyle(
                        fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                    
                    // Unread indicator
                    if (isUnread) ...[  
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
                
                // Message date
                Text(
                  _formatMessageDate(message['date']),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Message content
            Text(
              message['content'],
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
            
            // Attachments if any
            if (message['attachments'] != null && message['attachments'].isNotEmpty) ...[  
              const SizedBox(height: 12),
              for (final attachment in message['attachments'])
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getAttachmentIcon(attachment['name']),
                        size: 16,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        attachment['name'],
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        attachment['size'],
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.download_outlined,
                        size: 16,
                        color: Colors.grey[700],
                      ),
                    ],
                  ),
                ),
            ],
            
            // Action buttons
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isUnread)
                  TextButton.icon(
                    onPressed: () {
                      // Mark as read
                    },
                    icon: const Icon(Icons.mark_email_read_outlined, size: 16),
                    label: const Text('Mark as Read'),
                  ),
                TextButton.icon(
                  onPressed: () {
                    // Reply to message
                  },
                  icon: const Icon(Icons.reply_outlined, size: 16),
                  label: const Text('Reply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatMessageDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return DateFormat('h:mm a').format(date);
    } else if (difference.inDays < 7) {
      return DateFormat('E, h:mm a').format(date);
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }

  IconData _getAttachmentIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image_outlined;
      case 'doc':
      case 'docx':
        return Icons.description_outlined;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'New':
        return const Color(0xFF8BA888);
      case 'Completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getHormoneStatusColor(String status) {
    switch (status) {
      case 'high':
        return Colors.red;
      case 'low':
        return Colors.orange;
      case 'normal':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getMedicationStatusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Scheduled':
        return const Color(0xFF8BA888);
      case 'Completed':
        return Colors.blue;
      case 'Discontinued':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

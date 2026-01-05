import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class ProtocolDetailScreen extends StatefulWidget {
  const ProtocolDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProtocolDetailScreen> createState() => _ProtocolDetailScreenState();
}

class _ProtocolDetailScreenState extends State<ProtocolDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? protocolData;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get protocol data from route arguments
    if (protocolData == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      protocolData = args;
    } else {
      // Fallback/Default data for testing or direct access
      protocolData = {
        'id': 'P001',
        'name': 'Long Protocol with Antagonist',
        'description': 'Standard long protocol with GnRH antagonist for controlled ovarian stimulation',
        'patientCount': 12,
        'startDate': DateTime(2025, 2, 15),
        'currentPhase': 'Ovarian Stimulation',
        'estimatedEggRetrieval': DateTime(2025, 3, 15),
        'estimatedEmbryoTransfer': DateTime(2025, 3, 20),
        'notes': 'Patient responding well to stimulation. Follicle growth as expected.',
        'ageRange': '30-38',
        'successRate': '38%',
        'riskLevel': 'Medium',
        'duration': '4-5 weeks',
        'medications': [
          {
            'name': 'Gonal-F',
            'dosage': '225 IU',
            'frequency': 'Daily',
            'duration': '10-12 days',
            'phase': 'Stimulation',
            'startDay': 3,
            'endDay': 14,
          },
          {
            'name': 'Cetrotide',
            'dosage': '0.25 mg',
            'frequency': 'Daily',
            'duration': '5-6 days',
            'phase': 'Prevention of premature ovulation',
            'startDay': 8,
            'endDay': 14,
          },
          {
            'name': 'Ovidrel',
            'dosage': '250 mcg',
            'frequency': 'Once',
            'duration': '1 day',
            'phase': 'Trigger',
            'startDay': 14,
            'endDay': 14,
          },
        ],
        'procedures': [
          {
            'name': 'Baseline Ultrasound',
            'day': 2,
            'description': 'Initial scan to assess ovarian reserve',
          },
          {
            'name': 'Follicle Monitoring',
            'day': 8,
            'description': 'Ultrasound to monitor follicle growth',
          },
          {
            'name': 'Egg Retrieval',
            'day': 16,
            'description': 'Surgical procedure to collect mature eggs',
          },
          {
            'name': 'Embryo Transfer',
            'day': 21,
            'description': 'Transfer of embryos to uterus',
          },
        ],
        'color': 0xFF8BA888,
      };
    }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (protocolData == null) {
      return const Scaffold(
        body: Center(
          child: Text('Protocol data not found'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Protocol: ${protocolData!['name']}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            tooltip: 'Dashboard',
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false),
          ),
          IconButton(
            icon: const Icon(Icons.content_copy_outlined),
            onPressed: () {
              _showCloneDialog();
            },
            tooltip: 'Clone Protocol',
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              _showEditProtocolDialog();
            },
            tooltip: 'Edit Protocol',
          ),
          IconButton(
            icon: const Icon(Icons.print_outlined),
            onPressed: () {
              // Print protocol
            },
            tooltip: 'Print Protocol',
          ),
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_outlined),
            onPressed: () {
              _showAssignDialog();
            },
            tooltip: 'Assign to Patient',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildProtocolHeader(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildMedicationsTab(),
                _buildCalendarTab(),
                _buildStatisticsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProtocolHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(protocolData!['color']).withOpacity(0.1),
        border: Border(
          bottom: BorderSide(color: const Color(0xFFE0E0E0)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(protocolData!['color']).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.medical_services_outlined,
              color: Color(protocolData!['color']),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${protocolData!['name']}${protocolData!.containsKey('version') ? " (v${protocolData!['version']})" : ""}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  protocolData!['description'],
                  style: TextStyle(color: const Color(0xFF4A4A4A)),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 16,
                  children: [
                    _buildInfoChip('Age Range', protocolData!['ageRange']),
                    _buildInfoChip('Success Rate', protocolData!['successRate']),
                    _buildInfoChip('Duration', protocolData!['duration']),
                    _buildInfoChip('Risk Level', protocolData!['riskLevel']),
                    _buildInfoChip('Patients', '${protocolData!['patientCount']}'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontSize: 12, color: const Color(0xFF4A4A4A)),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: const Color(0xFFE0E0E0)),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: const Color(0xFF6B6B6B),
        indicatorColor: Theme.of(context).primaryColor,
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Medications'),
          Tab(text: 'Calendar'),
          Tab(text: 'Statistics'),
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
          // Protocol details
          _buildSectionTitle('Protocol Details'),
          Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow('Protocol ID', protocolData!['id']),
                            _buildDetailRow('Duration', protocolData!['duration']),
                            _buildDetailRow('Current Phase', protocolData!['currentPhase']),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow('Created', DateFormat('MMM d, yyyy').format(protocolData!['startDate'])),
                            _buildDetailRow('Egg Retrieval', DateFormat('MMM d, yyyy').format(protocolData!['estimatedEggRetrieval'])),
                            _buildDetailRow('Embryo Transfer', DateFormat('MMM d, yyyy').format(protocolData!['estimatedEmbryoTransfer'])),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow('Notes', protocolData!['notes']),
                ],
              ),
            ),
          ),

          // Procedure Timeline
          _buildSectionTitle('Procedure Timeline'),
          Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final procedure in protocolData!['procedures'])
                    _buildTimelineItem(
                      day: procedure['day'],
                      title: procedure['name'],
                      description: procedure['description'],
                    ),
                ],
              ),
            ),
          ),

          // Risks and Benefits
          _buildSectionTitle('Risks and Benefits'),
          Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRiskBenefitItem(
                    title: 'Benefits',
                    items: [
                      'Controlled ovarian stimulation to produce multiple eggs',
                      'Increased chances of successful fertilization',
                      'Ability to select the healthiest embryos for transfer',
                      'Option to freeze additional embryos for future use',
                    ],
                    isRisk: false,
                  ),
                  const Divider(),
                  _buildRiskBenefitItem(
                    title: 'Risks',
                    items: [
                      'Ovarian hyperstimulation syndrome (OHSS)',
                      'Multiple pregnancy',
                      'Ectopic pregnancy',
                      'Medication side effects',
                      'Procedural complications during egg retrieval',
                    ],
                    isRisk: true,
                  ),
                ],
              ),
            ),
          ),

          // Patient Eligibility
          _buildSectionTitle('Patient Eligibility'),
          Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEligibilityItem(
                    title: 'Ideal Candidates',
                    description: 'Patients aged ${protocolData!['ageRange']} with good ovarian reserve and no significant medical complications.',
                  ),
                  const Divider(),
                  _buildEligibilityItem(
                    title: 'Contraindications',
                    description: 'Patients with severe medical conditions, uncontrolled endocrine disorders, or certain types of cancers.',
                  ),
                  const Divider(),
                  _buildEligibilityItem(
                    title: 'Special Considerations',
                    description: 'May require dose adjustments for patients with low BMI, PCOS, or previous poor response to stimulation.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Medication Schedule'),
          Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final medication in protocolData!['medications'])
                    _buildMedicationItem(medication),
                ],
              ),
            ),
          ),

          _buildSectionTitle('Medication Timeline'),
          Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 100,
                    child: _buildMedicationTimeline(),
                  ),
                ],
              ),
            ),
          ),

          _buildSectionTitle('Medication Instructions'),
          Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInstructionItem(
                    title: 'Storage',
                    description: 'Most medications should be stored in the refrigerator. Check individual medication instructions for specific requirements.',
                  ),
                  const Divider(),
                  _buildInstructionItem(
                    title: 'Administration',
                    description: 'Injections should be administered at approximately the same time each day. Follow proper injection technique as demonstrated by your nurse.',
                  ),
                  const Divider(),
                  _buildInstructionItem(
                    title: 'Side Effects',
                    description: 'Common side effects include injection site reactions, bloating, mood changes, and breast tenderness. Contact your doctor if you experience severe symptoms.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TableCalendar(
                    firstDay: DateTime.utc(2024, 1, 1),
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
                      return _getEventsForDay(day);
                    },
                    calendarStyle: CalendarStyle(
                      markerDecoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDayEvents(_selectedDay),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Success Rates'),
          Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatItem(
                    title: 'Overall Success Rate',
                    value: protocolData!['successRate'],
                    description: 'Percentage of treatments resulting in live births',
                  ),
                  const Divider(),
                  _buildStatItem(
                    title: 'Success by Age Group',
                    value: '',
                    description: '',
                    showChart: true,
                  ),
                  _buildAgeSuccessRates(),
                ],
              ),
            ),
          ),

          _buildSectionTitle('Protocol Comparison'),
          Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildComparisonItem(
                    title: 'vs. Long Protocol with Agonist',
                    advantages: [
                      'Shorter duration',
                      'Lower risk of OHSS',
                      'More flexible scheduling',
                    ],
                    disadvantages: [
                      'Slightly lower success rates in some patient groups',
                      'More frequent monitoring required',
                    ],
                  ),
                  const Divider(),
                  _buildComparisonItem(
                    title: 'vs. Natural Cycle',
                    advantages: [
                      'Higher success rates',
                      'More embryos available',
                      'Better control over timing',
                    ],
                    disadvantages: [
                      'Higher medication costs',
                      'Increased risk of side effects',
                      'More invasive',
                    ],
                  ),
                ],
              ),
            ),
          ),

          _buildSectionTitle('Patient Outcomes'),
          Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOutcomeItem(
                    title: 'Average Eggs Retrieved',
                    value: '12',
                  ),
                  const Divider(),
                  _buildOutcomeItem(
                    title: 'Fertilization Rate',
                    value: '70%',
                  ),
                  const Divider(),
                  _buildOutcomeItem(
                    title: 'Blastocyst Formation Rate',
                    value: '50%',
                  ),
                  const Divider(),
                  _buildOutcomeItem(
                    title: 'Implantation Rate',
                    value: '45%',
                  ),
                  const Divider(),
                  _buildOutcomeItem(
                    title: 'Multiple Pregnancy Rate',
                    value: '15%',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widgets
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({required int day, required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Color(protocolData!['color']).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                day.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(protocolData!['color']),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(description),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskBenefitItem({required String title, required List<String> items, required bool isRisk}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              isRisk ? Icons.warning_amber_outlined : Icons.check_circle_outline,
              color: isRisk ? const Color(0xFFE89B8E) : const Color(0xFF7FB685),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(left: 32.0, bottom: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• '),
                  Expanded(child: Text(item)),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildEligibilityItem({required String title, required String description}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(description),
      ],
    );
  }

  Widget _buildMedicationItem(Map<String, dynamic> medication) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(protocolData!['color']).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.medication_outlined,
              color: Color(protocolData!['color']),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medication['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text('Dosage: ${medication['dosage']}'),
                Text('Frequency: ${medication['frequency']}'),
                Text('Duration: ${medication['duration']}'),
                Text('Phase: ${medication['phase']}'),
                Text('Days: ${medication['startDay']} to ${medication['endDay']}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationTimeline() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        for (int day = 1; day <= 30; day++)
          _buildDayColumn(day),
      ],
    );
  }

  Widget _buildDayColumn(int day) {
    // Find medications active on this day
    final activeMeds = protocolData!['medications'].where((med) {
      return day >= med['startDay'] && day <= med['endDay'];
    }).toList();

    // Find procedures on this day
    final procedures = protocolData!['procedures'].where((proc) {
      return day == proc['day'];
    }).toList();

    return Container(
      width: 30,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        children: [
          Text(
            day.toString(),
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: activeMeds.isNotEmpty || procedures.isNotEmpty
                    ? Color(protocolData!['color']).withOpacity(activeMeds.isNotEmpty ? 0.2 : 0.05)
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (procedures.isNotEmpty)
                    Icon(
                      Icons.event,
                      size: 14,
                      color: Color(protocolData!['color']),
                    ),
                  if (activeMeds.isNotEmpty)
                    Icon(
                      Icons.medication,
                      size: 14,
                      color: Color(protocolData!['color']),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionItem({required String title, required String description}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(description),
      ],
    );
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    // Find medications active on this day
    final activeMeds = protocolData!['medications'].where((med) {
      final daysSinceStart = day.difference(protocolData!['startDate']).inDays + 1;
      return daysSinceStart >= med['startDay'] && daysSinceStart <= med['endDay'];
    }).toList();

    // Find procedures on this day
    final procedures = protocolData!['procedures'].where((proc) {
      final daysSinceStart = day.difference(protocolData!['startDate']).inDays + 1;
      return daysSinceStart == proc['day'];
    }).toList();

    return [...activeMeds, ...procedures];
  }

  Widget _buildDayEvents(DateTime day) {
    final events = _getEventsForDay(day);

    if (events.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('No events scheduled for this day.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Events for ${DateFormat('MMMM d, yyyy').format(day)}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ...events.map((event) {
          if (event.containsKey('name') && event.containsKey('description')) {
            // This is a procedure
            return ListTile(
              leading: Icon(Icons.event, color: Color(protocolData!['color'])),
              title: Text(event['name']),
              subtitle: Text(event['description']),
            );
          } else {
            // This is a medication
            return ListTile(
              leading: Icon(Icons.medication, color: Color(protocolData!['color'])),
              title: Text(event['name']),
              subtitle: Text('${event['dosage']} - ${event['frequency']}'),
            );
          }
        }).toList(),
      ],
    );
  }

  Widget _buildStatItem({required String title, required String value, required String description, bool showChart = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (description.isNotEmpty) ...[  
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            if (value.isNotEmpty)
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(protocolData!['color']),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildAgeSuccessRates() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          _buildAgeSuccessRow('Under 35', '45%'),
          _buildAgeSuccessRow('35-37', '38%'),
          _buildAgeSuccessRow('38-40', '30%'),
          _buildAgeSuccessRow('41-42', '20%'),
          _buildAgeSuccessRow('Over 42', '10%'),
        ],
      ),
    );
  }

  Widget _buildAgeSuccessRow(String ageGroup, String rate) {
    final percentage = int.parse(rate.replaceAll('%', ''));
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(ageGroup),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Container(
                  height: 20,
                  width: (percentage / 100) * (MediaQuery.of(context).size.width - 150),
                  decoration: BoxDecoration(
                    color: Color(protocolData!['color']),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              rate,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonItem({required String title, required List<String> advantages, required List<String> disadvantages}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Advantages:',
          style: TextStyle(fontWeight: FontWeight.w500, color: const Color(0xFF7FB685)),
        ),
        ...advantages.map((item) => Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('+ '),
                  Expanded(child: Text(item)),
                ],
              ),
            )),
        const SizedBox(height: 8),
        Text(
          'Disadvantages:',
          style: TextStyle(fontWeight: FontWeight.w500, color: const Color(0xFFE89B8E)),
        ),
        ...disadvantages.map((item) => Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('- '),
                  Expanded(child: Text(item)),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildOutcomeItem({required String title, required String value}) {
    return Row(
      children: [
        Expanded(
          child: Text(title),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(protocolData!['color']),
          ),
        ),
      ],
    );
  }

  void _showCloneDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clone Protocol'),
          content: const Text('Would you like to create a copy of this protocol template that you can modify?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Clone protocol logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Protocol cloned successfully')),
                );
              },
              child: const Text('Clone'),
            ),
          ],
        );
      },
    );
  }

  void _showAssignDialog() {
    DateTime? startDate = DateTime.now();
    String? selectedPatient;
    final List<String> patients = ['Sarah Johnson', 'Emma Davis', 'Jessica White'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Assign Protocol to Patient'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Assign '${protocolData!['name']}' to:",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Select Patient',
                  border: OutlineInputBorder(),
                ),
                items: patients.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                onChanged: (val) => setDialogState(() => selectedPatient = val),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text("Cycle Start Date"),
                subtitle: Text(DateFormat.yMMMd().format(startDate!)),
                contentPadding: EdgeInsets.zero,
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: startDate!,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) setDialogState(() => startDate = picked);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: selectedPatient != null
                  ? () {
                      Navigator.pop(context);
                      // In a real app, this would trigger the backend sync to the patient's app
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.white),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text('Protocol assigned to $selectedPatient\nStarts: ${DateFormat('MMM d').format(startDate!)}'),
                              ),
                            ],
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: const Color(0xFF7FB685),
                        ),
                      );
                    }
                  : null,
              child: const Text('Assign Protocol'),
            ),
          ],
        ),
      ),
    );
  }
  void _showEditProtocolDialog() {
    final nameController = TextEditingController(text: protocolData!['name']);
    final descriptionController = TextEditingController(text: protocolData!['description']);
    final notesController = TextEditingController(text: protocolData!['notes']);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Protocol'),
        content: Container(
          width: double.maxFinite,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create a new version of this protocol with updated details.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Protocol Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.isEmpty ?? true ? 'Name is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: notesController,
                    decoration: const InputDecoration(
                      labelText: 'Clinical Notes',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.amber),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.info_outline, color: Colors.amber, size: 16),
                        SizedBox(width: 8),
                        Expanded(child: Text('Editing will create a new version of this protocol.', style: TextStyle(fontSize: 12))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                setState(() {
                  // Increment version
                  int currentVersion = protocolData!['version'] ?? 1;
                  int newVersion = currentVersion + 1;
                  
                  // Update data
                  protocolData!['name'] = nameController.text;
                  protocolData!['description'] = descriptionController.text;
                  protocolData!['notes'] = notesController.text;
                  protocolData!['version'] = newVersion;
                  protocolData!['lastModified'] = DateTime.now();
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Protocol updated to Version ${protocolData!['version']}'),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                );
              }
            },
            child: const Text('Save New Version'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../widgets/app_drawer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Sample data for dashboard
  final int _totalPatients = 128;
  final int _activePatients = 87;
  final int _todayAppointments = 12;
  final int _pendingResults = 8;
  final int _newMessages = 5;
  
  // Selected time period for charts
  String _selectedPeriod = 'Week';
  int _touchedIndex = -1;

  List<double> _getSuccessRates() {
    switch (_selectedPeriod) {
      case 'Month':
        return [70, 60, 48, 30];
      case 'Year':
        return [72, 65, 52, 35];
      default: // Week
        return [65, 55, 40, 25];
    }
  }

  List<double> _getTreatmentData() { // IVF, ICSI, IUI, Other
    switch (_selectedPeriod) {
      case 'Month':
        return [50, 30, 15, 5];
      case 'Year':
        return [55, 35, 8, 2];
      default: // Week
        return [45, 25, 20, 10];
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text('IVF Clinic Dashboard'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            tooltip: 'Dashboard',
            onPressed: () => Navigator.pushReplacementNamed(context, '/dashboard'),
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
      drawer: const AppDrawer(currentRoute: '/dashboard'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message and date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, Dr. Thompson',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    // Generate reports
                  },
                  icon: const Icon(Icons.download_outlined),
                  label: const Text('Export Reports'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Appointments and Notifications (First Row)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Today's Appointments
                  Expanded(
                    flex: 3,
                    child: _buildUpcomingAppointments(),
                  ),
                  const SizedBox(width: 16),
                  // Recent Activities/Notifications
                  Expanded(
                    flex: 2,
                    child: _buildRecentActivities(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Quick stats cards (smaller)
            _buildQuickStatsRow(),
            const SizedBox(height: 16),
            
            // Charts section (smaller)
            _buildChartsSection(),
          ],
        ),
      ),
    );
  }

 

  Widget _buildQuickStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Total Patients',
            value: _totalPatients.toString(),
            icon: Icons.people_outlined,
            color: Theme.of(context).primaryColor,
            trend: '12%',
            isTrendPositive: true,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'Active Treatments',
            value: _activePatients.toString(),
            icon: Icons.medical_services_outlined,
            color: Theme.of(context).colorScheme.secondary,
            trend: '5%',
            isTrendPositive: true,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'Today\'s Appointments',
            value: _todayAppointments.toString(),
            icon: Icons.calendar_today_outlined,
            color: Theme.of(context).colorScheme.onSurface,
            trend: 'On Track',
            isTrendPositive: true,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'Pending Results',
            value: _pendingResults.toString(),
            icon: Icons.science_outlined,
            color: Colors.orange,
            trend: '2%',
            isTrendPositive: false,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String trend,
    required bool isTrendPositive,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
          if (trend != 'On Track')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isTrendPositive
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isTrendPositive ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 12,
                    color: isTrendPositive ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    trend,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: isTrendPositive ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            )
          else
             Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'On Track',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.blue,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChartsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Treatment Analytics',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SegmentedButton<String>(
              showSelectedIcon: false,
              style: ButtonStyle(
                padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 8)),
                visualDensity: VisualDensity.compact,
                textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 12)),
              ),
              segments: const [
                ButtonSegment(value: 'Week', label: Text('Week')),
                ButtonSegment(value: 'Month', label: Text('Month')),
                ButtonSegment(value: 'Year', label: Text('Year')),
              ],
              selected: {_selectedPeriod},
              onSelectionChanged: (Set<String> selection) {
                setState(() {
                  _selectedPeriod = selection.first;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 420,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildSuccessRateChart(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTreatmentTypesChart(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessRateChart() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),  
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Success Rates by Age Group',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),  
            ),
            const SizedBox(height: 4),  
            const Text(
              'Percentage of successful treatments',
              style: TextStyle(fontSize: 12, color: Color(0xFF6B6B6B)),  
            ),
            const SizedBox(height: 16),  
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Theme.of(context).colorScheme.onSurface,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        String ageGroup;
                        switch (group.x) {
                          case 0:
                            ageGroup = '<30';
                            break;
                          case 1:
                            ageGroup = '30-34';
                            break;
                          case 2:
                            ageGroup = '35-39';
                            break;
                          case 3:
                            ageGroup = '40+';
                            break;
                          default:
                            ageGroup = '';
                        }
                        return BarTooltipItem(
                          '$ageGroup\n${rod.toY.toInt()}%',
                          const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          String text;
                          switch (value.toInt()) {
                            case 0:
                              text = '<30';
                              break;
                            case 1:
                              text = '30-34';
                              break;
                            case 2:
                              text = '35-39';
                              break;
                            case 3:
                              text = '40+';
                              break;
                            default:
                              text = '';
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              text,
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 20,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}%',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: const Color(0xFFE0E0E0),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: List.generate(4, (index) {
                    final rates = _getSuccessRates();
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: rates[index],
                          color: const Color(0xFF8BA888),
                          width: 20,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTreatmentTypesChart() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Treatment Types Distribution',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Percentage of treatment types',
              style: TextStyle(fontSize: 12, color: Color(0xFF6B6B6B)),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          _touchedIndex = -1;
                          return;
                        }
                        _touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: List.generate(4, (i) {
                    final isTouched = i == _touchedIndex;
                    final fontSize = isTouched ? 20.0 : 16.0;
                    final radius = isTouched ? 90.0 : 80.0;
                    const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
                    final data = _getTreatmentData();
                    final val = data[i];
                    
                    switch (i) {
                      case 0:
                        return PieChartSectionData(
                          color: const Color(0xFF8BA888),
                          value: val,
                          title: '${val.toInt()}%',
                          radius: radius,
                          titleStyle: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: shadows,
                          ),
                        );
                      case 1:
                        return PieChartSectionData(
                          color: const Color(0xFF6B9B9E),
                          value: val,
                          title: '${val.toInt()}%',
                          radius: radius,
                          titleStyle: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: shadows,
                          ),
                        );
                      case 2:
                        return PieChartSectionData(
                          color: const Color(0xFF575756),
                          value: val,
                          title: '${val.toInt()}%',
                          radius: radius,
                          titleStyle: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: shadows,
                          ),
                        );
                      case 3:
                        return PieChartSectionData(
                          color: const Color(0xFFE8C68E),
                          value: val,
                          title: '${val.toInt()}%',
                          radius: radius,
                          titleStyle: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: shadows,
                          ),
                        );
                      default:
                        throw Error();
                    }
                  }),
                ),
              ),
            ),
            const SizedBox(height: 6),  
            _buildChartLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildChartLegend() {
    return Column(
      children: [
        _buildLegendItem('IVF', const Color(0xFF8BA888)),
        const SizedBox(height: 6),  
        _buildLegendItem('ICSI', const Color(0xFF6B9B9E)),
        const SizedBox(height: 6),  
        _buildLegendItem('IUI', const Color(0xFF575756)),
        const SizedBox(height: 6),  
        _buildLegendItem('Other', const Color(0xFFE8C68E)),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }

  Widget _buildRecentActivities() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.notifications_active, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Notifications',
                          style: Theme.of(context).textTheme.titleLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$_newMessages new',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/messenger');
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildActivityItem(
                      icon: Icons.science,
                      color: Colors.blue,
                      title: 'Lab Results Available',
                      description: 'Hormone test results for Sarah Johnson',
                      time: '10:30 AM',
                      isUrgent: true,
                    ),
                    const Divider(),
                    _buildActivityItem(
                      icon: Icons.medical_services,
                      color: Colors.green,
                      title: 'Treatment Updated',
                      description: 'Protocol adjusted for Michael Roberts',
                      time: '9:15 AM',
                      isUrgent: false,
                    ),
                    const Divider(),
                    _buildActivityItem(
                      icon: Icons.message,
                      color: Colors.orange,
                      title: 'New Message',
                      description: 'Question from Jennifer Davis about medication',
                      time: 'Yesterday',
                      isUrgent: true,
                    ),
                    const Divider(),
                    _buildActivityItem(
                      icon: Icons.calendar_today,
                      color: const Color(0xFF8BA888),
                      title: 'Appointment Scheduled',
                      description: 'Follow-up with David Wilson',
                      time: 'Yesterday',
                      isUrgent: false,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/messenger');
                        },
                        icon: const Icon(Icons.message_outlined),
                        label: const Text('Open Messenger'),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
    required String time,
    required bool isUrgent,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              if (isUrgent)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isUrgent ? Colors.red : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
              if (isUrgent) ...[  
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Urgent',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingAppointments() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.3), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Color(0xFF8BA888), size: 20),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Today\'s Schedule',
                          style: Theme.of(context).textTheme.titleLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8BA888),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$_todayAppointments total',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/appointments');
                  },
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: const Text('All Appointments'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildAppointmentItem(
              time: '9:00 AM',
              patientName: 'Sarah Johnson',
              purpose: 'Egg Retrieval',
              isCompleted: false,
              isNext: true,
            ),
            const Divider(),
            _buildAppointmentItem(
              time: '10:30 AM',
              patientName: 'Michael Roberts',
              purpose: 'Consultation',
              isCompleted: false,
            ),
            const Divider(),
            _buildAppointmentItem(
              time: '11:45 AM',
              patientName: 'Jennifer Davis',
              purpose: 'Ultrasound',
              isCompleted: false,
            ),
            const Divider(),
            _buildAppointmentItem(
              time: '2:15 PM',
              patientName: 'David Wilson',
              purpose: 'Follow-up',
              isCompleted: false,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/appointments');
                },
                icon: const Icon(Icons.add_outlined),
                label: const Text('Schedule New Appointment'),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentItem({
    required String time,
    required String patientName,
    required String purpose,
    required bool isCompleted,
    bool isNext = false,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/appointments');
      },
      borderRadius: BorderRadius.circular(8),
      splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
      highlightColor: Theme.of(context).primaryColor.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: isCompleted
                    ? Colors.green
                    : isNext
                        ? const Color(0xFF8BA888)
                        : Colors.grey[400],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              time,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isNext ? const Color(0xFF8BA888) : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patientName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isNext ? const Color(0xFF8BA888) : null,
                    ),
                  ),
                  Text(
                    purpose,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                if (isCompleted)
                  const Icon(Icons.check_circle, color: Colors.green, size: 16)
                else if (isNext)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8BA888).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        color: Color(0xFF8BA888),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                  iconSize: 16,
                  color: Colors.grey[600],
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

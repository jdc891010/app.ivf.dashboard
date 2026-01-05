import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class ProtocolsScreen extends StatefulWidget {
  const ProtocolsScreen({Key? key}) : super(key: key);

  @override
  State<ProtocolsScreen> createState() => _ProtocolsScreenState();
}

class _ProtocolsScreenState extends State<ProtocolsScreen> {
  // Sample protocols data
  final List<Map<String, dynamic>> protocols = [
    {
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
    },
    {
      'id': 'P002',
      'name': 'Short Protocol with Agonist',
      'description': 'Shorter protocol with GnRH agonist, ideal for poor responders',
      'patientCount': 8,
      'startDate': DateTime(2025, 3, 1),
      'currentPhase': 'Egg Retrieval',
      'estimatedEggRetrieval': DateTime(2025, 3, 10),
      'estimatedEmbryoTransfer': DateTime(2025, 3, 15),
      'notes': 'Patient is responding well to stimulation. Egg retrieval scheduled soon.',
      'ageRange': '35-42',
      'successRate': '35%',
      'riskLevel': 'Medium-High',
      'duration': '3-4 weeks',
      'medications': [
        {
          'name': 'Lupron',
          'dosage': '20 units',
          'frequency': 'Daily',
          'duration': '7-10 days',
          'phase': 'Downregulation',
          'startDay': 1,
          'endDay': 7,
        },
        {
          'name': 'Menopur',
          'dosage': '150 IU',
          'frequency': 'Daily',
          'duration': '8-10 days',
          'phase': 'Stimulation',
          'startDay': 3,
          'endDay': 12,
        },
        {
          'name': 'Pregnyl',
          'dosage': '10,000 IU',
          'frequency': 'Once',
          'duration': '1 day',
          'phase': 'Trigger',
          'startDay': 12,
          'endDay': 12,
        },
      ],
      'procedures': [
        {
          'name': 'Baseline Ultrasound',
          'day': 1,
          'description': 'Initial scan to assess ovarian reserve',
        },
        {
          'name': 'Follicle Monitoring',
          'day': 7,
          'description': 'Ultrasound to monitor follicle growth',
        },
        {
          'name': 'Egg Retrieval',
          'day': 14,
          'description': 'Surgical procedure to collect mature eggs',
        },
        {
          'name': 'Embryo Transfer',
          'day': 19,
          'description': 'Transfer of embryos to uterus',
        },
      ],
      'color': 0xFF6B9B9E,
    },
    {
      'id': 'P003',
      'name': 'Natural Cycle',
      'description': 'Minimal medication approach using natural menstrual cycle',
      'patientCount': 5,
      'startDate': DateTime(2025, 3, 15),
      'currentPhase': 'Monitoring',
      'estimatedEggRetrieval': DateTime(2025, 3, 20),
      'estimatedEmbryoTransfer': DateTime(2025, 3, 25),
      'notes': 'Patient is responding well to natural cycle. Monitoring follicle growth.',
      'ageRange': '25-35',
      'successRate': '20%',
      'riskLevel': 'Low',
      'duration': '2-3 weeks',
      'medications': [
        {
          'name': 'None',
          'dosage': 'N/A',
          'frequency': 'N/A',
          'duration': 'N/A',
          'phase': 'Monitoring only',
          'startDay': 0,
          'endDay': 0,
        },
        {
          'name': 'Ovidrel',
          'dosage': '250 mcg',
          'frequency': 'Once',
          'duration': '1 day',
          'phase': 'Trigger (optional)',
          'startDay': 12,
          'endDay': 12,
        },
      ],
      'procedures': [
        {
          'name': 'Baseline Ultrasound',
          'day': 3,
          'description': 'Initial scan to assess ovarian reserve',
        },
        {
          'name': 'Follicle Monitoring',
          'day': 10,
          'description': 'Ultrasound to monitor follicle growth',
        },
        {
          'name': 'Egg Retrieval',
          'day': 14,
          'description': 'Surgical procedure to collect mature eggs',
        },
        {
          'name': 'Embryo Transfer',
          'day': 19,
          'description': 'Transfer of embryos to uterus',
        },
      ],
      'color': 0xFF575756,
    },
    {
      'id': 'P004',
      'name': 'Mild Stimulation Protocol',
      'description': 'Lower dose stimulation for reduced side effects and cost',
      'patientCount': 7,
      'startDate': DateTime(2025, 2, 10),
      'currentPhase': 'Completed',
      'estimatedEggRetrieval': DateTime(2025, 2, 25),
      'estimatedEmbryoTransfer': DateTime(2025, 3, 2),
      'notes': 'Good option for patients with concerns about medication side effects.',
      'ageRange': '30-40',
      'successRate': '30%',
      'riskLevel': 'Low-Medium',
      'duration': '3-4 weeks',
      'medications': [
        {
          'name': 'Clomid',
          'dosage': '50 mg',
          'frequency': 'Daily',
          'duration': '5 days',
          'phase': 'Stimulation',
          'startDay': 2,
          'endDay': 7,
        },
        {
          'name': 'Gonal-F',
          'dosage': '150 IU',
          'frequency': 'Daily',
          'duration': '7-8 days',
          'phase': 'Stimulation',
          'startDay': 5,
          'endDay': 12,
        },
        {
          'name': 'Ovidrel',
          'dosage': '250 mcg',
          'frequency': 'Once',
          'duration': '1 day',
          'phase': 'Trigger',
          'startDay': 12,
          'endDay': 12,
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
          'day': 14,
          'description': 'Surgical procedure to collect mature eggs',
        },
        {
          'name': 'Embryo Transfer',
          'day': 19,
          'description': 'Transfer of embryos to uterus',
        },
      ],
      'color': 0xFFE57373,
    },
    {
      'id': 'P005',
      'name': 'Freeze-All Protocol',
      'description': 'All embryos are frozen for later transfer to optimize implantation',
      'patientCount': 10,
      'startDate': DateTime(2025, 1, 5),
      'currentPhase': 'Completed',
      'estimatedEggRetrieval': DateTime(2025, 1, 20),
      'estimatedEmbryoTransfer': DateTime(2025, 2, 20),
      'notes': 'Allows for genetic testing and optimized timing of embryo transfer.',
      'ageRange': '30-42',
      'successRate': '42%',
      'riskLevel': 'Medium',
      'duration': '6-8 weeks',
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
          'name': 'Embryo Freezing',
          'day': 21,
          'description': 'Cryopreservation of embryos',
        },
        {
          'name': 'Embryo Transfer',
          'day': 45,
          'description': 'Transfer of thawed embryos to uterus',
        },
      ],
      'color': 0xFF4FC3F7,
    },
    {
      'id': 'P006',
      'name': 'Mini-IVF Protocol',
      'description': 'Minimal stimulation protocol with reduced medication',
      'patientCount': 4,
      'startDate': DateTime(2025, 3, 20),
      'currentPhase': 'Planning',
      'estimatedEggRetrieval': DateTime(2025, 4, 5),
      'estimatedEmbryoTransfer': DateTime(2025, 4, 10),
      'notes': 'Good for patients with concerns about medication side effects or costs.',
      'ageRange': '35-43',
      'successRate': '25%',
      'riskLevel': 'Low',
      'duration': '3-4 weeks',
      'medications': [
        {
          'name': 'Clomid',
          'dosage': '100 mg',
          'frequency': 'Daily',
          'duration': '5 days',
          'phase': 'Stimulation',
          'startDay': 3,
          'endDay': 7,
        },
        {
          'name': 'Gonal-F',
          'dosage': '75 IU',
          'frequency': 'Daily',
          'duration': '7-8 days',
          'phase': 'Stimulation',
          'startDay': 5,
          'endDay': 12,
        },
        {
          'name': 'Ovidrel',
          'dosage': '250 mcg',
          'frequency': 'Once',
          'duration': '1 day',
          'phase': 'Trigger',
          'startDay': 12,
          'endDay': 12,
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
          'day': 14,
          'description': 'Surgical procedure to collect mature eggs',
        },
        {
          'name': 'Embryo Transfer',
          'day': 19,
          'description': 'Transfer of embryos to uterus',
        },
      ],
      'color': 0xFF81C784,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Treatment Protocols'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Search protocols
            },
          ),
          IconButton(
            icon: const Icon(Icons.home_outlined),
            tooltip: 'Dashboard',
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Filter protocols
            },
          ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: '/protocols'),
      body: Column(
        children: [
          // Header with stats and actions
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Protocol Templates',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Select a protocol template to view details or create a new one',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Create new protocol
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Create Protocol'),
                ),
              ],
            ),
          ),
          
          // Protocols grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.75,
              ),
              itemCount: protocols.length,
              itemBuilder: (context, index) {
                final protocol = protocols[index];
                return _buildProtocolCard(protocol);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProtocolCard(Map<String, dynamic> protocol) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context, 
          '/protocol_detail',
          arguments: protocol,
        );
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(protocol['color']).withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(protocol['color']).withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(protocol['color']).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.medical_services_outlined,
                        color: Color(protocol['color']),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        protocol['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        protocol['description'],
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      _buildInfoRow('Age Range:', protocol['ageRange']),
                      _buildInfoRow('Success Rate:', protocol['successRate']),
                      _buildInfoRow('Duration:', protocol['duration']),
                      _buildInfoRow('Risk Level:', protocol['riskLevel']),
                    ],
                  ),
                ),
              ),
              
              // Footer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8F6F3),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${protocol['patientCount']} patients',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.visibility_outlined, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          'View',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MedicalNotesScreen extends StatefulWidget {
  const MedicalNotesScreen({Key? key}) : super(key: key);

  @override
  State<MedicalNotesScreen> createState() => _MedicalNotesScreenState();
}

class _MedicalNotesScreenState extends State<MedicalNotesScreen> {
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _treatmentController = TextEditingController();
  final TextEditingController _medicationController = TextEditingController();
  
  Map<String, dynamic>? appointmentData;
  Map<String, dynamic>? patientData;
  
  List<Map<String, dynamic>> attachments = [];
  bool _isRecording = false;
  String _selectedCategory = 'General';
  
  final List<String> categories = [
    'General',
    'Consultation',
    'Ultrasound',
    'Egg Retrieval',
    'Embryo Transfer',
    'Lab Results',
    'Medication Review',
    'Follow-up',
  ];

  @override
  void dispose() {
    _notesController.dispose();
    _diagnosisController.dispose();
    _treatmentController.dispose();
    _medicationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get appointment and patient data from route arguments
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      if (args.containsKey('appointment')) {
        appointmentData = args['appointment'];
      }
      if (args.containsKey('patient')) {
        patientData = args['patient'];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          patientData != null 
              ? 'Medical Notes: ${patientData!['name']}' 
              : 'New Medical Notes'
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_outlined),
            onPressed: _saveNotes,
            tooltip: 'Save Notes',
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined),
            onPressed: _scheduleFollowUp,
            tooltip: 'Schedule Follow-up',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient and appointment info
            if (patientData != null || appointmentData != null)
              _buildInfoCard(),
            
            const SizedBox(height: 16),
            
            // Quick input options
            _buildQuickInputOptions(),
            
            const SizedBox(height: 16),
            
            // Notes form
            _buildNotesForm(),
            
            const SizedBox(height: 16),
            
            // Attachments
            _buildAttachments(),
            
            const SizedBox(height: 24),
            
            // Action buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 1,
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
                      if (patientData != null) ...[  
                        Text(
                          'Patient: ${patientData!['name']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text('ID: ${patientData!['id']}'),
                        const SizedBox(height: 4),
                        Text('Age: ${patientData!['age']}'),
                      ],
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (appointmentData != null) ...[  
                        Text(
                          'Appointment: ${appointmentData!['purpose'] ?? 'Consultation'}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        if (appointmentData!.containsKey('date') && appointmentData!['date'] != null) 
                          Text('Date: ${DateFormat('MMM d, yyyy').format(appointmentData!['date'] as DateTime)}'),
                        const SizedBox(height: 4),
                        Text('Time: ${appointmentData!['time'] ?? 'N/A'}'),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    // View patient history
                    if (patientData != null) {
                      Navigator.pushNamed(
                        context, 
                        '/patient_detail',
                        arguments: patientData,
                      );
                    }
                  },
                  icon: const Icon(Icons.history),
                  label: const Text('View History'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    // View lab results
                    if (patientData != null) {
                      Navigator.pushNamed(
                        context, 
                        '/lab_results',
                        arguments: {'patient': patientData},
                      );
                    }
                  },
                  icon: const Icon(Icons.science_outlined),
                  label: const Text('Lab Results'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickInputOptions() {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Input Options',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildQuickInputButton(
                  icon: Icons.camera_alt,
                  label: 'Take Photo',
                  color: Colors.green,
                  onPressed: _takePhoto,
                ),
                _buildQuickInputButton(
                  icon: Icons.videocam,
                  label: 'Record Video',
                  color: Colors.orange,
                  onPressed: _recordVideo,
                ),
                _buildQuickInputButton(
                  icon: Icons.mic_none,
                  label: _isRecording ? 'Stop Recording' : 'Voice Note',
                  color: _isRecording ? Colors.red : Colors.purple,
                  onPressed: _toggleVoiceRecording,
                ),
                _buildQuickInputButton(
                  icon: Icons.attach_file,
                  label: 'Attach File',
                  color: Colors.teal,
                  onPressed: _attachFile,
                ),
                _buildQuickInputButton(
                  icon: Icons.text_snippet,
                  label: 'Use Template',
                  color: Colors.indigo,
                  onPressed: _useTemplate,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickInputButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildNotesForm() {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Medical Notes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                DropdownButton<String>(
                  value: _selectedCategory,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    }
                  },
                  items: categories.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Enter detailed notes here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _diagnosisController,
              decoration: const InputDecoration(
                labelText: 'Diagnosis',
                hintText: 'Enter diagnosis...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _treatmentController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Treatment Plan',
                hintText: 'Enter treatment plan...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _medicationController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Medications',
                hintText: 'Enter prescribed medications...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachments() {
    if (attachments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Attachments',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: attachments.map((attachment) {
                return _buildAttachmentItem(attachment);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentItem(Map<String, dynamic> attachment) {
    IconData icon;
    Color color;
    
    switch (attachment['type']) {
      case 'image':
        icon = Icons.image;
        color = Colors.blue;
        break;
      case 'video':
        icon = Icons.videocam;
        color = Colors.red;
        break;
      case 'audio':
        icon = Icons.mic;
        color = Colors.orange;
        break;
      case 'file':
        icon = Icons.insert_drive_file;
        color = Colors.green;
        break;
      default:
        icon = Icons.attach_file;
        color = Colors.grey;
    }
    
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: color),
                const SizedBox(height: 4),
                Text(
                  attachment['name'],
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: InkWell(
              onTap: () {
                setState(() {
                  attachments.remove(attachment);
                });
              },
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 16),
              ),
            ),
          ),
        ],
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
          onPressed: _saveNotes,
          icon: const Icon(Icons.save),
          label: const Text('Save Notes'),
        ),
      ],
    );
  }

  // Action methods
  void _saveNotes() {
    // Validate inputs
    if (_notesController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter notes before saving')),
      );
      return;
    }

    // Create notes object
    final notes = {
      'id': 'N${DateTime.now().millisecondsSinceEpoch}',
      'patientId': patientData?['id'] ?? 'Unknown',
      'patientName': patientData?['name'] ?? 'Unknown',
      'appointmentId': appointmentData?['id'] ?? 'Unknown',
      'category': _selectedCategory,
      'notes': _notesController.text,
      'diagnosis': _diagnosisController.text,
      'treatmentPlan': _treatmentController.text,
      'medications': _medicationController.text,
      'attachments': attachments,
      'createdAt': DateTime.now(),
      'createdBy': 'Dr. Emily Thompson',
    };

    // In a real app, save to database
    // For now, just show success message and navigate back
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notes saved successfully')),
    );
    
    Navigator.pop(context, notes);
  }

  void _scheduleFollowUp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Schedule Follow-up'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select a date and time for the follow-up appointment:'),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () async {
                  // Show date picker
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 7)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  
                  if (pickedDate != null) {
                    // Show time picker
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 9, minute: 0),
                    );
                    
                    if (pickedTime != null) {
                      // Get formatted date and time for display
                      final formattedDate = DateFormat('MMM d, yyyy').format(pickedDate);
                      final formattedTime = '${pickedTime.hour}:${pickedTime.minute.toString().padLeft(2, '0')}';
                      
                      // Create appointment
                      final appointment = {
                        'id': 'A${DateTime.now().millisecondsSinceEpoch}',
                        'patientId': patientData?['id'] ?? 'Unknown',
                        'patientName': patientData?['name'] ?? 'Unknown',
                        'date': pickedDate,
                        'time': formattedTime,
                        'purpose': 'Follow-up',
                        'notes': 'Follow-up appointment for ${_selectedCategory}',
                        'status': 'Scheduled',
                      };
                      
                      // In a real app, save to database
                      // For now, just show success message and navigate back
                      Navigator.pop(context); // Close dialog
                      
                      // Use the appointment data in the success message
                      final patientName = appointment['patientName'];
                      final purpose = appointment['purpose'];
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$purpose for $patientName scheduled for $formattedDate at $formattedTime')),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: const Text('Select Date & Time'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _takePhoto() {
    // In a real app, access camera
    // For now, just simulate adding a photo
    setState(() {
      attachments.add({
        'id': 'IMG${DateTime.now().millisecondsSinceEpoch}',
        'name': 'Photo ${attachments.length + 1}',
        'type': 'image',
        'createdAt': DateTime.now(),
      });
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Photo added')),
    );
  }

  void _recordVideo() {
    // In a real app, access camera for video recording
    // For now, just simulate adding a video
    setState(() {
      attachments.add({
        'id': 'VID${DateTime.now().millisecondsSinceEpoch}',
        'name': 'Video ${attachments.length + 1}',
        'type': 'video',
        'createdAt': DateTime.now(),
      });
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Video added')),
    );
  }

  void _toggleVoiceRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });
    
    if (_isRecording) {
      // In a real app, start audio recording
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Voice recording started...')),
      );
    } else {
      // In a real app, stop audio recording and save file
      setState(() {
        attachments.add({
          'id': 'AUD${DateTime.now().millisecondsSinceEpoch}',
          'name': 'Voice Note ${attachments.length + 1}',
          'type': 'audio',
          'createdAt': DateTime.now(),
        });
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Voice recording saved')),
      );
    }
  }

  void _attachFile() {
    // In a real app, open file picker
    // For now, just simulate adding a file
    setState(() {
      attachments.add({
        'id': 'FILE${DateTime.now().millisecondsSinceEpoch}',
        'name': 'File ${attachments.length + 1}.pdf',
        'type': 'file',
        'createdAt': DateTime.now(),
      });
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('File attached')),
    );
  }

  void _useTemplate() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Template'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Normal Ultrasound Results'),
                onTap: () {
                  _notesController.text = 'Ultrasound performed. All measurements within normal range. No abnormalities detected.';
                  _diagnosisController.text = 'Normal ultrasound findings';
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Medication Adjustment'),
                onTap: () {
                  _notesController.text = 'Patient responding to stimulation. Follicle growth progressing as expected. Medication adjustment recommended.';
                  _treatmentController.text = 'Continue current protocol with adjusted dosage.';
                  _medicationController.text = 'Increase Gonal-F to 225 IU daily. Continue Cetrotide 0.25mg daily.';
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Egg Retrieval Results'),
                onTap: () {
                  _notesController.text = 'Egg retrieval procedure performed. Procedure went smoothly without complications.';
                  _treatmentController.text = 'Rest for 24 hours. Avoid strenuous activity for 1 week. Return for embryo transfer as scheduled.';
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

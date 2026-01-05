import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/app_drawer.dart';

class MessengerScreen extends StatefulWidget {
  const MessengerScreen({Key? key}) : super(key: key);

  @override
  State<MessengerScreen> createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedIndex = 0;
  
  // Sample conversation data
  final List<Map<String, dynamic>> _conversations = [
    {
      'id': 'C001',
      'name': 'Sarah Johnson',
      'avatar': 'SJ',
      'isPatient': true,
      'patientId': 'P001',
      'lastMessage': 'Thank you for the information, doctor.',
      'lastMessageTime': DateTime.now().subtract(const Duration(minutes: 15)),
      'unread': 0,
      'online': true,
    },
    {
      'id': 'C002',
      'name': 'Dr. Robert Chen',
      'avatar': 'RC',
      'isPatient': false,
      'lastMessage': 'Can you review the lab results for Michael Roberts?',
      'lastMessageTime': DateTime.now().subtract(const Duration(hours: 1)),
      'unread': 2,
      'online': true,
    },
    {
      'id': 'C003',
      'name': 'Jennifer Davis',
      'avatar': 'JD',
      'isPatient': true,
      'patientId': 'P003',
      'lastMessage': 'I have a question about my medication schedule.',
      'lastMessageTime': DateTime.now().subtract(const Duration(hours: 3)),
      'unread': 1,
      'online': false,
    },
    {
      'id': 'C004',
      'name': 'Sarah Williams, NP',
      'avatar': 'SW',
      'isPatient': false,
      'lastMessage': 'The patient in room 3 is ready for you.',
      'lastMessageTime': DateTime.now().subtract(const Duration(hours: 5)),
      'unread': 0,
      'online': true,
    },
    {
      'id': 'C005',
      'name': 'Michael Roberts',
      'avatar': 'MR',
      'isPatient': true,
      'patientId': 'P002',
      'lastMessage': 'When should I start taking the new medication?',
      'lastMessageTime': DateTime.now().subtract(const Duration(days: 1)),
      'unread': 0,
      'online': false,
    },
    {
      'id': 'C006',
      'name': 'Dr. Lisa Wong',
      'avatar': 'LW',
      'isPatient': false,
      'lastMessage': 'Let\'s discuss the treatment plan for Jennifer Davis.',
      'lastMessageTime': DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      'unread': 0,
      'online': false,
    },
    {
      'id': 'C007',
      'name': 'David Wilson',
      'avatar': 'DW',
      'isPatient': true,
      'patientId': 'P004',
      'lastMessage': 'My wife and I are looking forward to our appointment tomorrow.',
      'lastMessageTime': DateTime.now().subtract(const Duration(days: 2)),
      'unread': 0,
      'online': false,
    },
  ];

  // Sample messages for the selected conversation
  final List<Map<String, dynamic>> _messages = [
    {
      'id': 'M001',
      'sender': 'Sarah Johnson',
      'senderId': 'P001',
      'content': 'Hello Dr. Thompson, I have a question about my medication.',
      'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      'isRead': true,
      'isSender': false,
    },
    {
      'id': 'M002',
      'sender': 'Dr. Emily Thompson',
      'senderId': 'D001',
      'content': 'Hi Sarah, what would you like to know?',
      'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 1, minutes: 45)),
      'isRead': true,
      'isSender': true,
    },
    {
      'id': 'M003',
      'sender': 'Sarah Johnson',
      'senderId': 'P001',
      'content': 'I\'m experiencing some side effects from the Gonal-F. I have a mild headache and some bloating. Is this normal?',
      'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 1, minutes: 30)),
      'isRead': true,
      'isSender': false,
    },
    {
      'id': 'M004',
      'sender': 'Dr. Emily Thompson',
      'senderId': 'D001',
      'content': 'Yes, those are common side effects of Gonal-F. Make sure you\'re drinking plenty of water and resting when needed. If the headache becomes severe or you experience significant abdominal pain, please let me know immediately.',
      'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 1)),
      'isRead': true,
      'isSender': true,
    },
    {
      'id': 'M005',
      'sender': 'Sarah Johnson',
      'senderId': 'P001',
      'content': 'Thank you, that\'s reassuring. I\'ll make sure to stay hydrated.',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'isRead': true,
      'isSender': false,
    },
    {
      'id': 'M006',
      'sender': 'Dr. Emily Thompson',
      'senderId': 'D001',
      'content': 'You\'re welcome. Don\'t hesitate to reach out if you have any other concerns. We\'ll be monitoring your progress closely at your next appointment.',
      'timestamp': DateTime.now().subtract(const Duration(hours: 23)),
      'isRead': true,
      'isSender': true,
    },
    {
      'id': 'M007',
      'sender': 'Sarah Johnson',
      'senderId': 'P001',
      'content': 'I\'ve been following the medication schedule as prescribed. Is there anything else I should be doing to prepare for the egg retrieval?',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'isRead': true,
      'isSender': false,
    },
    {
      'id': 'M008',
      'sender': 'Dr. Emily Thompson',
      'senderId': 'D001',
      'content': 'You\'re doing great, Sarah. Just continue with your medications as prescribed and make sure to get plenty of rest. Avoid strenuous exercise and alcohol. We\'ll go over all the details for the egg retrieval procedure at your next appointment on Wednesday.',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      'isRead': true,
      'isSender': true,
    },
    {
      'id': 'M009',
      'sender': 'Sarah Johnson',
      'senderId': 'P001',
      'content': 'Thank you for the information, doctor.',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
      'isRead': false,
      'isSender': false,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredConversations {
    if (_searchQuery.isEmpty) {
      return _conversations;
    }
    return _conversations.where((conversation) {
      return conversation['name']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messenger'),
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
      drawer: const AppDrawer(currentRoute: '/messenger'),
      body: Row(
        children: [
          // Conversations list (left panel)
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: Column(
                children: [
                  // Search and new message
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Search field
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search conversations',
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
                        const SizedBox(width: 8),
                        // New message button
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () {
                            // Create new conversation
                          },
                          tooltip: 'New Message',
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                  
                  // Conversations list
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredConversations.length,
                      itemBuilder: (context, index) {
                        final conversation = filteredConversations[index];
                        return _buildConversationTile(conversation, index);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Chat area (right panel)
          Expanded(
            flex: 2,
            child: _selectedIndex < filteredConversations.length
                ? _buildChatArea(filteredConversations[_selectedIndex])
                : const Center(child: Text('Select a conversation to start chatting')),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationTile(Map<String, dynamic> conversation, int index) {
    final isSelected = index == _selectedIndex;
    
    return ListTile(
      selected: isSelected,
      selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundColor: isSelected 
                ? Theme.of(context).primaryColor 
                : Colors.grey[300],
            child: Text(
              conversation['avatar'],
              style: TextStyle(
                color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (conversation['online'])
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFF7FB685),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        conversation['name'],
        style: TextStyle(
          fontWeight: conversation['unread'] > 0 ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        conversation['lastMessage'],
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: conversation['unread'] > 0 ? FontWeight.bold : FontWeight.normal,
          color: conversation['unread'] > 0 ? Theme.of(context).colorScheme.onSurface : Colors.grey[600],
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatTime(conversation['lastMessageTime']),
            style: TextStyle(
              fontSize: 12,
              color: conversation['unread'] > 0 
                  ? Theme.of(context).primaryColor
                  : const Color(0xFF9E9E9E),
            ),
          ),
          const SizedBox(height: 4),
          if (conversation['unread'] > 0)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: Text(
                conversation['unread'].toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }

  Widget _buildChatArea(Map<String, dynamic> conversation) {
    return Column(
      children: [
        // Chat header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                child: Text(
                  conversation['avatar'],
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      conversation['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      conversation['online'] ? 'Online' : 'Offline',
                      style: TextStyle(
                        color: conversation['online'] ? const Color(0xFF7FB685) : const Color(0xFF9E9E9E),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.phone_outlined),
                onPressed: () {
                  // Call
                },
                tooltip: 'Call',
              ),
              IconButton(
                icon: const Icon(Icons.videocam_outlined),
                onPressed: () {
                  // Video call
                },
                tooltip: 'Video Call',
              ),
              IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () {
                  // View info
                },
                tooltip: 'Info',
              ),
            ],
          ),
        ),
        
        // Messages area
        Expanded(
          child: Container(
            color: const Color(0xFFF5F5F5),
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return _buildMessageBubble(message);
              },
            ),
          ),
        ),
        
        // Message input area
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF9E9E9E).withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 1,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.attach_file_outlined),
                onPressed: () {
                  // Attach file
                },
                tooltip: 'Attach File',
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (value) {
                    // Send message
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send_rounded),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  // Send message
                },
                tooltip: 'Send',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isSender = message['isSender'];
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isSender) ...[  
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[300],
              child: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.onSurface,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSender ? Theme.of(context).primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isSender)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        message['sender'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  Text(
                    message['content'],
                    style: TextStyle(
                      color: isSender ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isSender) ...[  
            const SizedBox(width: 8),
            Column(
              children: [
                const SizedBox(height: 4),
                Icon(
                  message['isRead'] ? Icons.done_all : Icons.done,
                  size: 16,
                  color: message['isRead'] ? Colors.blue : Colors.grey,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inDays > 0) {
      return DateFormat('MMM d').format(time);
    } else {
      return DateFormat('h:mm a').format(time);
    }
  }

 
}

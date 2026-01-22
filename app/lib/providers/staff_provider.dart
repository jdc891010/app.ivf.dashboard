import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Staff {
  final String id;
  final String name;
  final String role;
  final String department;
  final String email;
  final String phone;
  final String avatar;
  final String status;
  final String notes;

  Staff({
    required this.id,
    required this.name,
    required this.role,
    required this.department,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.status,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'department': department,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'status': status,
      'notes': notes,
    };
  }

  factory Staff.fromMap(Map<String, dynamic> map) {
    return Staff(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? '',
      department: map['department'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      avatar: map['avatar'] ?? '',
      status: map['status'] ?? '',
      notes: map['notes'] ?? '',
    );
  }

  Staff copyWith({
    String? name,
    String? role,
    String? department,
    String? email,
    String? phone,
    String? avatar,
    String? status,
    String? notes,
  }) {
    return Staff(
      id: id,
      name: name ?? this.name,
      role: role ?? this.role,
      department: department ?? this.department,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }
}

class StaffProvider with ChangeNotifier {
  List<Staff> _staffMembers = [];
  bool _isLoading = true;

  List<Staff> get staffMembers => _staffMembers;
  bool get isLoading => _isLoading;

  StaffProvider() {
    loadStaff();
  }

  Future<void> loadStaff() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final staffString = prefs.getString('staff_members');

    if (staffString != null) {
      final List<dynamic> decoded = json.decode(staffString);
      _staffMembers = decoded.map((item) => Staff.fromMap(item)).toList();
    } else {
      // Initialize with default data if empty
      _staffMembers = [
        Staff(
          id: 'S001',
          name: 'Dr. Emily Thompson',
          role: 'Fertility Specialist',
          department: 'Doctors',
          email: 'emily.thompson@ivfclinic.com',
          phone: '+1 (555) 123-4567',
          avatar: 'ET',
          status: 'Active',
          notes: 'Available for consults',
        ),
        Staff(
          id: 'S002',
          name: 'Dr. Robert Chen',
          role: 'Reproductive Endocrinologist',
          department: 'Doctors',
          email: 'robert.chen@ivfclinic.com',
          phone: '+1 (555) 234-5678',
          avatar: 'RC',
          status: 'Active',
          notes: 'In surgery AM',
        ),
        Staff(
          id: 'S003',
          name: 'Sarah Williams',
          role: 'Nurse Practitioner',
          department: 'Nurses',
          email: 'sarah.williams@ivfclinic.com',
          phone: '+1 (555) 345-6789',
          avatar: 'SW',
          status: 'Active',
          notes: 'General shift',
        ),
      ];
      await saveStaff();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveStaff() async {
    final prefs = await SharedPreferences.getInstance();
    final staffString = json.encode(_staffMembers.map((s) => s.toMap()).toList());
    await prefs.setString('staff_members', staffString);
  }

  Future<void> addStaff(Staff staff) async {
    _staffMembers.add(staff);
    await saveStaff();
    notifyListeners();
  }

  Future<void> updateStaff(Staff updatedStaff) async {
    final index = _staffMembers.indexWhere((s) => s.id == updatedStaff.id);
    if (index != -1) {
      _staffMembers[index] = updatedStaff;
      await saveStaff();
      notifyListeners();
    }
  }

  Future<void> removeStaff(String id) async {
    _staffMembers.removeWhere((s) => s.id == id);
    await saveStaff();
    notifyListeners();
  }
}

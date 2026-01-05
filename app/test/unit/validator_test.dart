import 'package:flutter_test/flutter_test.dart';
import 'package:ivf_clinic_dashboard/utils/validators.dart';

void main() {
  group('Validators Test', () {
    test('Email Validator', () {
      expect(Validators.validateEmail(null), 'Please enter your email');
      expect(Validators.validateEmail(''), 'Please enter your email');
      expect(Validators.validateEmail('invalid'), 'Please enter a valid email');
      expect(Validators.validateEmail('user@'), 'Please enter a valid email');
      expect(Validators.validateEmail('user@domain'), 'Please enter a valid email');
      expect(Validators.validateEmail('user@domain.'), 'Please enter a valid email');
      expect(Validators.validateEmail('test@example.com'), null);
      expect(Validators.validateEmail('test.user@example.co.uk'), null);
      expect(Validators.validateEmail('user+tag@example.com'), null);
      expect(Validators.validateEmail('user@example.museum'), null);
      expect(Validators.validateEmail('  user@example.com  '), null);
    });

    test('Password Validator', () {
      expect(Validators.validatePassword(null), 'Please enter your password');
      expect(Validators.validatePassword(''), 'Please enter your password');
      expect(Validators.validatePassword('12345'), 'Password must be at least 6 characters');
      expect(Validators.validatePassword('123456'), null);
      expect(Validators.validatePassword('password123'), null);
    });
  });
}

import 'package:flutter/material.dart';
import '../../core/constants/kerala_districts.dart';
import '../../core/network/api_service.dart';
import '../../core/theme/app_theme.dart';
import 'main_shell.dart';

class AuthOtpScreen extends StatefulWidget {
  final ApiService apiService;
  const AuthOtpScreen({super.key, required this.apiService});

  @override
  State<AuthOtpScreen> createState() => _AuthOtpScreenState();
}

class _AuthOtpScreenState extends State<AuthOtpScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  DistrictInfo _selectedDistrict = KeralaDistricts.all.firstWhere((d) => d.code == 'KL-EKM');
  bool _otpSent = false;
  bool _isLoading = false;

  void _sendOtp() {
    if (_phoneController.text.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid mobile number')),
      );
      return;
    }
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _isLoading = false;
        _otpSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification code sent via WhatsApp & SMS! (Code: 482910)')),
      );
    });
  }

  void _verifyOtp() {
    if (_otpController.text.trim().length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter 6-digit verification code')),
      );
      return;
    }
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() => _isLoading = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Started (കൂടം)'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 20),
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryTeal.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.forum_rounded, size: 48, color: AppColors.primaryTeal),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              _otpSent ? 'Enter Verification Code' : 'Discover Your Local Malayali Circle',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              _otpSent
                  ? 'We sent a 6-digit code to ${_phoneController.text}'
                  : 'Connect with verified single-day gatherings and intentional dates across Kerala.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 32),

          if (!_otpSent) ...[
            // District Selector
            const Text('Your Native / Base District', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: DropdownButton<DistrictInfo>(
                value: _selectedDistrict,
                isExpanded: true,
                underline: const SizedBox(),
                items: KeralaDistricts.all.map((d) {
                  return DropdownMenuItem(value: d, child: Text('${d.nameEn} (${d.nameMl})'));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedDistrict = val);
                },
              ),
            ),
            const SizedBox(height: 16),

            // Phone Input
            const Text('Mobile Number', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                prefixIcon: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  child: Text('+91', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                hintText: '9876543210',
                filled: true,
                fillColor: AppColors.cardBg,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _isLoading ? null : _sendOtp,
              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Send WhatsApp OTP'),
            ),
          ] else ...[
            // OTP Input
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 6,
              style: const TextStyle(fontSize: 24, letterSpacing: 10, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: '••••••',
                filled: true,
                fillColor: AppColors.cardBg,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _isLoading ? null : _verifyOtp,
              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Verify & Enter Koodam'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => setState(() => _otpSent = false),
              child: const Text('Change Mobile Number', style: TextStyle(color: AppColors.primaryTeal)),
            ),
          ],
        ],
      ),
    );
  }
}

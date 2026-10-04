import 'package:flutter/material.dart';
import '../../theme.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  bool otpSent = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    tabController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  void handleEmailLogin() async {
    if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
      _showError('Enter your email and password');
      return;
    }
    setState(() => loading = true);
    await Future.delayed(Duration(seconds: 2));
    setState(() => loading = false);
    _goHome();
  }

  void sendOtp() async {
    if (phoneController.text.trim().length < 10) {
      _showError('Enter a valid mobile number');
      return;
    }
    setState(() => loading = true);
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      loading = false;
      otpSent = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('OTP sent to +91 ${phoneController.text.trim()}'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  void verifyOtp() async {
    if (otpController.text.trim().length < 4) {
      _showError('Enter the OTP sent to your phone');
      return;
    }
    setState(() => loading = true);
    await Future.delayed(Duration(seconds: 1));
    setState(() => loading = false);
    _goHome();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppTheme.error),
    );
  }

  void _goHome() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: AppTheme.shieldGradient,
                  shape: BoxShape.circle,
                  boxShadow: AppTheme.glow(AppTheme.primary, blur: 24, spread: 2),
                ),
                child: Icon(Icons.shield, color: Colors.white, size: 30),
              ),
              SizedBox(height: 20),
              Text('Welcome back', style: Theme.of(context).textTheme.displayMedium),
              SizedBox(height: 6),
              Text(
                'Log in to continue keeping yourself safe',
                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              ),
              SizedBox(height: 24),

              // Tab switcher
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.surfaceLight),
                ),
                child: Row(
                  children: [
                    _tabButton('Email', 0),
                    _tabButton('Mobile Number', 1),
                  ],
                ),
              ),

              SizedBox(height: 24),

              tabController.index == 0 ? _buildEmailForm() : _buildPhoneForm(),

              SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? ", style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                  Text('Sign Up', style: TextStyle(fontSize: 13, color: AppTheme.primary, fontWeight: FontWeight.w600)),
                ],
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabButton(String label, int index) {
    final isSelected = tabController.index == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => tabController.index = index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primary.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            border: isSelected ? Border.all(color: AppTheme.primary.withOpacity(0.5)) : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Email Address'),
        _textField(controller: emailController, hint: 'you@example.com', icon: Icons.email_outlined),
        SizedBox(height: 16),
        _label('Password'),
        _textField(controller: passwordController, hint: '••••••••', icon: Icons.lock_outline, obscure: true),
        SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: Text('Forgot Password?', style: TextStyle(fontSize: 12, color: AppTheme.primary)),
        ),
        SizedBox(height: 20),
        _submitButton(label: 'Sign In', onPressed: handleEmailLogin),
      ],
    );
  }

  Widget _buildPhoneForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Mobile Number'),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            border: Border.all(color: AppTheme.surfaceLight),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Text('🇮🇳 +91', style: TextStyle(fontSize: 14, color: AppTheme.textPrimary)),
              ),
              Container(width: 1, height: 24, color: AppTheme.surfaceLight),
              Expanded(
                child: TextField(
                  controller: phoneController,
                  enabled: !otpSent,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  style: TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: '98765 43210',
                    hintStyle: TextStyle(color: AppTheme.textSecondary),
                    border: InputBorder.none,
                    counterText: '',
                    contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (otpSent) ...[
          SizedBox(height: 16),
          _label('Enter OTP'),
          _textField(
            controller: otpController,
            hint: '4-digit code',
            icon: Icons.password_rounded,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: sendOtp,
            child: Text('Resend OTP', style: TextStyle(fontSize: 12, color: AppTheme.primary)),
          ),
        ],
        SizedBox(height: 20),
        loading
            ? Center(child: CircularProgressIndicator(color: AppTheme.primary))
            : _submitButton(
                label: otpSent ? 'Verify & Continue' : 'Send OTP',
                onPressed: otpSent ? verifyOtp : sendOtp,
              ),
      ],
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: AppTheme.surfaceLight),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        style: TextStyle(color: AppTheme.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppTheme.textSecondary),
          prefixIcon: Icon(icon, color: AppTheme.textSecondary, size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        ),
      ),
    );
  }

  Widget _submitButton({required String label, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: loading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
import 'package:flutter/cupertino.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_nameController.text.trim().isEmpty ||
        _emailController.text. trim().isEmpty ||
        _messageController.text.trim().isEmpty) {
      _showDialog(
        'Missing Information',
        'Please fill in all required fields.',
        isError: true,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isSubmitting = false);

    if (mounted) {
      _showDialog(
        'Message Sent! ',
        'Thank you for contacting us. We\'ll get back to you soon.',
        isError: false,
      );

      // Clear form
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _messageController.clear();
    }
  }

  void _showDialog(String title, String message, {required bool isError}) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(message),
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: const Color(0xFF2C3E50),
        border: null,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(
            CupertinoIcons.back,
            color: Color(0xFFF8F5F0),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        middle: const Text(
          'Contact Us',
          style: TextStyle(
            color: Color(0xFFF8F5F0),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              const Text(
                'Get in Touch',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'We\'d love to hear from you.  Send us a message and we\'ll respond as soon as possible.',
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF2C3E50).withValues(alpha: 0.7),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 32),

              // Contact Info Cards
              _buildContactInfoCard(
                icon: CupertinoIcons. mail_solid,
                title: 'Email',
                value: 'support@eclat.com',
                color: const Color(0xFF8A9A5B),
              ),

              const SizedBox(height: 16),

              _buildContactInfoCard(
                icon: CupertinoIcons.phone_fill,
                title: 'Phone',
                value: '+855 70 229 710',
                color: const Color(0xFF8A9A5B),
              ),

              const SizedBox(height: 16),

              _buildContactInfoCard(
                icon: CupertinoIcons.location_solid,
                title: 'Location',
                value: 'Phnom Penh, Cambodia',
                color: const Color(0xFF8A9A5B),
              ),

              const SizedBox(height: 40),

              // Contact Form
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius:  BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF000000).withValues(alpha: 0.05),
                      blurRadius:  20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Send us a Message',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C3E50),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Name Field
                    _buildTextField(
                      controller: _nameController,
                      placeholder: 'Your Name',
                      icon: CupertinoIcons. person,
                    ),

                    const SizedBox(height: 16),

                    // Email Field
                    _buildTextField(
                      controller:  _emailController,
                      placeholder: 'Your Email',
                      icon: CupertinoIcons.mail,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height:  16),

                    // Phone Field
                    _buildTextField(
                      controller: _phoneController,
                      placeholder: 'Phone Number (Optional)',
                      icon: CupertinoIcons.phone,
                      keyboardType: TextInputType. phone,
                    ),

                    const SizedBox(height:  16),

                    // Message Field
                    _buildTextField(
                      controller: _messageController,
                      placeholder: 'Your Message',
                      icon: CupertinoIcons.chat_bubble_text,
                      maxLines: 5,
                    ),

                    const SizedBox(height: 24),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        color: const Color(0xFF8A9A5B),
                        borderRadius: BorderRadius.circular(12),
                        onPressed: _isSubmitting ? null : _submitForm,
                        child: _isSubmitting
                            ? const CupertinoActivityIndicator(
                          color:  Color(0xFFFFFFFF),
                        )
                            : const Text(
                          'Send Message',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFFFFFF),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Business Hours
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C3E50).withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration:  BoxDecoration(
                            color: const Color(0xFF8A9A5B).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            CupertinoIcons.clock,
                            color: Color(0xFF8A9A5B),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width:  12),
                        const Text(
                          'Business Hours',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildBusinessHour('Monday - Friday', '9:00 AM - 6:00 PM'),
                    _buildBusinessHour('Saturday', '10:00 AM - 4:00 PM'),
                    _buildBusinessHour('Sunday', 'Closed'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color. withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color. withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFF2C3E50).withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize:  15,
                    color: Color(0xFF2C3E50),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String placeholder,
    required IconData icon,
    TextInputType?  keyboardType,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F5F0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: CupertinoTextField(
        controller: controller,
        placeholder: placeholder,
        keyboardType: keyboardType,
        maxLines: maxLines,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F5F0),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF2C3E50).withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        prefix:  Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Icon(
            icon,
            color: const Color(0xFF8A9A5B),
            size: 20,
          ),
        ),
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF2C3E50),
        ),
        placeholderStyle: TextStyle(
          fontSize: 15,
          color:  const Color(0xFF2C3E50).withValues(alpha: 0.4),
        ),
      ),
    );
  }

  Widget _buildBusinessHour(String day, String hours) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment:  MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF2C3E50).withValues(alpha: 0.7),
            ),
          ),
          Text(
            hours,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
        ],
      ),
    );
  }
}
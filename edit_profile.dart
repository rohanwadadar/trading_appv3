import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passportController = TextEditingController();

  // State variables for selections
  DateTime? _selectedDate;
  String? _selectedGender;
  String? _selectedIncomeRange;
  String? _selectedMaritalStatus;

  // Lists for dropdown options
  final List<String> _genderOptions = ['Male', 'Female', 'Other'];
  final List<String> _incomeRanges = [
    'Below \$30,000',
    '\$30,000 - \$50,000',
    '\$50,000 - \$75,000',
    '\$75,000 - \$100,000',
    'Above \$100,000'
  ];
  final List<String> _maritalStatusOptions = [
    'Single',
    'Married',
    'Divorced',
    'Widowed'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Personal Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Profile Photo Section
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/images/profile_picture.png'),
                        backgroundColor: Colors.grey[800],
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            // Handle photo change
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),

                // Form Fields
                _buildField(
                  controller: _nameController,
                  label: 'Name',
                  icon: Icons.person_outline,
                ),
                _buildField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                _buildField(
                  controller: _emailController,
                  label: 'Email ID',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                _buildDateField(),
                _buildDropdownField(
                  value: _selectedGender,
                  items: _genderOptions,
                  label: 'Gender',
                  icon: Icons.people_outline,
                  onChanged: (value) => setState(() => _selectedGender = value),
                ),
                _buildDropdownField(
                  value: _selectedIncomeRange,
                  items: _incomeRanges,
                  label: 'Income Range',
                  icon: Icons.attach_money,
                  onChanged: (value) => setState(() => _selectedIncomeRange = value),
                ),
                _buildField(
                  controller: _passportController,
                  label: 'Passport Number',
                  icon: Icons.card_membership,
                ),
                _buildDropdownField(
                  value: _selectedMaritalStatus,
                  items: _maritalStatusOptions,
                  label: 'Marital Status',
                  icon: Icons.favorite_border,
                  onChanged: (value) => setState(() => _selectedMaritalStatus = value),
                ),
                SizedBox(height: 32),

                // Save Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Save profile changes
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16),
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.grey, size: 20),
              SizedBox(width: 8),
              Text(label, style: TextStyle(color: Colors.grey)),
            ],
          ),
          border: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required List<String> items,
    required String label,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((String item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item, style: TextStyle(color: Colors.white)),
          );
        }).toList(),
        onChanged: onChanged,
        dropdownColor: Color(0xFF1C1C1E),
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16),
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.grey, size: 20),
              SizedBox(width: 8),
              Text(label, style: TextStyle(color: Colors.grey)),
            ],
          ),
          border: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDateField() {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: _selectedDate ?? DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            builder: (context, child) {
              return Theme(
                data: ThemeData.dark().copyWith(
                  colorScheme: ColorScheme.dark(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    surface: Color(0xFF1C1C1E),
                    onSurface: Colors.white,
                  ),
                ),
                child: child!,
              );
            },
          );
          if (picked != null) {
            setState(() => _selectedDate = picked);
          }
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.grey, size: 20),
              SizedBox(width: 8),
              Text(
                _selectedDate == null
                    ? 'Date of Birth'
                    : DateFormat('MMM dd, yyyy').format(_selectedDate!),
                style: TextStyle(
                  color: _selectedDate == null ? Colors.grey : Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passportController.dispose();
    super.dispose();
  }
}
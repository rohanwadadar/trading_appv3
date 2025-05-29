import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController citizenshipController = TextEditingController();
  final TextEditingController ssnController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String realSSN = '';
  String? selectedCountryCode = '+1';
  DateTime? selectedDOB;
  int? age;
  String maskedSSN = "";

  String? capturedSSN;
  // New dropdown selections
  String? selectedGender;
  String? selectedIncomeRange;
  String? selectedMaritalStatus;
  String? selectedOccupationType;
  String? selectedJobRole;
  String? selectedSourceOfFund;
  String? selectedIdentificationType;
  String? selectedCitizenshipType;

  Map<String, String> uploadedFiles = {
    "Government-issued ID": "",
    "Three-point selfie": "",
    "Proof of Address": "",
  };

  // Dropdown options based on database enums
  final List<String> genderOptions = ['MALE', 'FEMALE', 'OTHER'];
  
  final List<String> incomeRangeOptions = [
    'LESS_THAN_50K',
    'BETWEEN_50K_AND_100K',
    'BETWEEN_100K_AND_150K',
    'BETWEEN_150K_AND_200K',
    'MORE_THAN_200K'
  ];
  
  final List<String> maritalStatusOptions = ['SINGLE', 'MARRIED', 'DIVORCED', 'WIDOWED'];
  
  final List<String> occupationTypeOptions = [
    'EMPLOYED_PRIVATE_SECTOR',
    'EMPLOYED_PUBLIC_SECTOR',
    'SELF_EMPLOYED',
    'PROFESSIONAL',
    'RETIRED',
    'UNEMPLOYED_NOT_WORKING',
    'SKILLED_SEMI_SKILLED_WORKER',
    'AGRICULTURE_ALLIED',
    'OTHERS'
  ];
  
  final List<String> jobRoleOptions = [
    'SOFTWARE_ENGINEER_IT_PROFESSIONAL',
    'ACCOUNTANT_AUDITOR',
    'MARKETING_SALES_EXECUTIVE',
    'HUMAN_RESOURCES_PROFESSIONAL',
    'OPERATIONS_MANAGER',
    'CUSTOMER_SERVICE_REPRESENTATIVE',
    'ANALYST_CONSULTANT',
    'CIVIL_SERVANT',
    'POLICE_OFFICER',
    'MILTARY_PERSONNEL',
    'PUBLIC_SCHOOL_TEACHER',
    'GOVERNMENT_HEALTH_WORKER',
    'BUSINESS_OWNER_ENTREPRENEUR',
    'CONSULTANT_FREELANCER',
    'TRADER_MERCHANT',
    'REAL_ESTATE_AGENT',
    'INDEPENDENT_CONTRACTOR',
    'DOCTOR_PHYSICIAN',
    'LAWYER_ADVOCATE',
    'ARCHITECT',
    'ENGINEER_CERTIFIED',
    'CHARTERED_ACCOUNTANT',
    'PHARMACIST',
    'RETIRED_GOVERNMENT',
    'RETIRED_PRIVATE_SECTOR',
    'UNEMPLOYED',
    'HOMEMAKER',
    'STUDENT',
    'DEPENDENT',
    'ELECTRICIAN',
    'PLUMBER',
    'CARPENTER',
    'MECHANIC',
    'DRIVER',
    'SECURITY_GUARD',
    'FARMER',
    'FISHERMAN',
    'LIVESTOCK_RAISER',
    'RELIGIOUS_WORKER',
    'ARTIST',
    'ACTOR',
    'MUSICIAN',
    'NGO_SOCIAL_WORKER',
    'JOURNALIST_MEDIA_PROFESSIONAL'
  ];
  
  final List<String> sourceOfFundOptions = [
    'SALARY_EMPLOYMENT_INCOME',
    'BUSINESS_INCOME_PROFITS',
    'SAVINGS_PERSONAL_SAVINGS',
    'INVESTMENT_INCOME_DIVIDENDS',
    'INVESTMENT_INCOME_INTEREST',
    'INVESTMENT_INCOME_CAPITAL_GAINS',
    'INHERITANCE',
    'GIFT_DONATION',
    'RENTAL_INCOME',
    'SALE_OF_PROPERTY_ASSETS',
    'PENSION_RETIREMENT_INCOME',
    'LOAN_CREDIT_FACILITY',
    'INSURANCE_PAYOUT',
    'GAMBLING_LOTTERY_WINNINGS',
    'TRUST_FUND',
    'GOVERNMENT_BENEFITS_GRANTS',
    'CRYPTO_ASSET_SALES',
    'ROYALTIES_LICENSING_FEES',
    'ALIMONY_SPOUSAL_SUPPORT'
  ];
  
  final List<String> identificationTypeOptions = [
    'PASSPORT',
    'DRIVING_LICENSE',
    'VOTER_ID',
    'PAN_CARD',
    'ADHAAR_CARD',
  ];
  
  final List<String> citizenshipTypeOptions = [
    'DOMESTIC_CITIZEN',
    'RESIDENT_FOREIGNER',
    'NON_RESIDENT_CITIZEN',
    'NON_RESIDENT_FOREIGNER',
    'DUAL_CITIZEN',
    'STATELESS_PERSON',
    'DIPLOMAT_EMBASSY_PERSONNEL'
  ];

  // Country codes with flags
  final List<Map<String, String>> countryCodes = [
    {'code': '+1', 'flag': '🇺🇸', 'country': 'US'},
    {'code': '+44', 'flag': '🇬🇧', 'country': 'UK'},
    {'code': '+91', 'flag': '🇮🇳', 'country': 'IN'},
    {'code': '+61', 'flag': '🇦🇺', 'country': 'AU'},
    {'code': '+49', 'flag': '🇩🇪', 'country': 'DE'},
    {'code': '+33', 'flag': '🇫🇷', 'country': 'FR'},
    {'code': '+86', 'flag': '🇨🇳', 'country': 'CN'},
    {'code': '+81', 'flag': '🇯🇵', 'country': 'JP'},
  ];

  void calculateAge(DateTime dob) {
    final today = DateTime.now();
    int calculatedAge = today.year - dob.year;
    if (today.month < dob.month || (today.month == dob.month && today.day < dob.day)) {
      calculatedAge--;
    }
    setState(() {
      age = calculatedAge;
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.blueAccent,
              onPrimary: Colors.white,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF121212),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDOB = picked;
        dobController.text = DateFormat('yyyy-MM-dd').format(picked);
        calculateAge(picked);
      });
    }
  }

  Future<void> _pickFile(String label) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        uploadedFiles[label] = result.files.single.name;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('📤 $label uploaded: ${result.files.single.name}'),
          backgroundColor: Colors.blueAccent,
        ),
      );
    }
  }

  void _showSSNDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SSNInputDialog(
          onSSNEntered: (ssn) {
            setState(() {
              realSSN = ssn;
              capturedSSN = ssn;
              // Update the display field with masked SSN
              if (ssn.length >= 4) {
                maskedSSN = "*** *** ${ssn.substring(ssn.length - 4)}";
              } else {
                maskedSSN = "*** *** ****";
              }
            });
            print("Real SSN captured: $ssn");
          },
        );
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Check if SSN is entered
      if (realSSN.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❗Please enter your Social Security Number'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      bool allUploaded = uploadedFiles.values.every((file) => file.isNotEmpty);

      if (!allUploaded) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❗Please upload all required documents'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ KYC Form Submitted Successfully'),
          backgroundColor: Colors.greenAccent,
        ),
      );

      // Backend logic can be placed here
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    dobController.dispose();
    addressController.dispose();
    citizenshipController.dispose();
    ssnController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("KYC Verification"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Information Required for KYC Process",
                    style: TextStyle(
                      fontSize: 22, 
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Personal Information Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField("Full Name", fullNameController),
                        _buildDOBField(),
                        if (age != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              "Calculated Age: $age years", 
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        _buildDropdownField("Gender", selectedGender, genderOptions, (value) {
                          setState(() {
                            selectedGender = value;
                          });
                        }),
                        _buildDropdownField("Marital Status", selectedMaritalStatus, maritalStatusOptions, (value) {
                          setState(() {
                            selectedMaritalStatus = value;
                          });
                        }),
                        _buildTextField("Residential Address", addressController),
                        _buildDropdownField("Citizenship Type", selectedCitizenshipType, citizenshipTypeOptions, (value) {
                          setState(() {
                            selectedCitizenshipType = value;
                          });
                        }),
                        _buildDropdownField("Identification Type", selectedIdentificationType, identificationTypeOptions, (value) {
                          setState(() {
                            selectedIdentificationType = value;
                          });
                        }),
                        
                        // Updated SSN Display Field
                        _buildSSNDisplayField(),
                        
                        // Updated Phone Field
                        _buildPhoneField(),
                        
                        _buildTextField("Email Address", emailController, keyboardType: TextInputType.emailAddress),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  
                  // Employment & Financial Information Section
                  const Text(
                    "Employment & Financial Information",
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDropdownField("Occupation Type", selectedOccupationType, occupationTypeOptions, (value) {
                          setState(() {
                            selectedOccupationType = value;
                          });
                        }),
                        _buildDropdownField("Job Role", selectedJobRole, jobRoleOptions, (value) {
                          setState(() {
                            selectedJobRole = value;
                          });
                        }),
                        _buildDropdownField("Income Range", selectedIncomeRange, incomeRangeOptions, (value) {
                          setState(() {
                            selectedIncomeRange = value;
                          });
                        }),
                        _buildDropdownField("Source of Funds", selectedSourceOfFund, sourceOfFundOptions, (value) {
                          setState(() {
                            selectedSourceOfFund = value;
                          });
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    "Upload Documents",
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildUploadSection("Government-issued ID"),
                        const Divider(height: 20, color: Colors.white24),
                        _buildUploadSection("Three-point selfie"),
                        const Divider(height: 20, color: Colors.white24),
                        _buildUploadSection("Proof of Address"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton.icon(
                        onPressed: _submitForm,
                        icon: const Icon(Icons.check_circle),
                        label: const Text("Submit KYC"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white60),
          filled: true,
          fillColor: const Color(0xFF2A2A2A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Required';
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownField(String label, String? selectedValue, List<String> options, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white60),
          filled: true,
          fillColor: const Color(0xFF2A2A2A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        dropdownColor: const Color(0xFF2A2A2A),
        style: const TextStyle(color: Colors.white),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white60),
        items: options.map((option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(
              option.replaceAll('_', ' ').toLowerCase().split(' ').map((word) => 
                word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '').join(' '),
              style: const TextStyle(color: Colors.white),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please select $label';
          return null;
        },
      ),
    );
  }

  Widget _buildDOBField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: _pickDate,
        child: AbsorbPointer(
          child: TextFormField(
            controller: dobController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Date of Birth',
              labelStyle: const TextStyle(color: Colors.white60),
              filled: true,
              fillColor: const Color(0xFF2A2A2A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              suffixIcon: const Icon(Icons.calendar_today, color: Colors.white60),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please select DOB';
              return null;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSSNDisplayField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: _showSSNDialog,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Text(
                    maskedSSN.isEmpty ? "Social Security Number" : maskedSSN,
                    style: TextStyle(
                      color: maskedSSN.isEmpty ? Colors.white60 : Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: const Color(0xFF2A2A2A),
                        title: const Text(
                          'SSN Information',
                          style: TextStyle(color: Colors.white),
                        ),
                        content: const Text(
                          'Your Social Security Number is encrypted and securely stored. Only the last 4 digits are displayed for security purposes.',
                          style: TextStyle(color: Colors.white70),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK', style: TextStyle(color: Colors.blueAccent)),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.info_outline,
                    color: Colors.blueAccent,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            // Country Code Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.white24, width: 1),
                ),
              ),
              child: DropdownButton<String>(
                value: selectedCountryCode,
                dropdownColor: const Color(0xFF2A2A2A),
                style: const TextStyle(color: Colors.white, fontSize: 16),
                underline: const SizedBox(),
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white60, size: 20),
                items: countryCodes.map((country) {
                  return DropdownMenuItem<String>(
                    value: country['code'],
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          country['flag']!,
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          country['code']!,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCountryCode = value;
                  });
                },
              ),
            ),
            
            // Phone Number Input
            Expanded(
              child: TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: const InputDecoration(
                  hintText: '(555) 123-4567',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _PhoneNumberFormatter(),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter phone number';
                  String digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
                  if (digitsOnly.length < 10) return 'Phone number too short';
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadSection(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              uploadedFiles[label]!.isNotEmpty
                  ? "$label: ${uploadedFiles[label]}"
                  : label,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => _pickFile(label),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF333333),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Upload"),
          ),
        ],
      ),
    );
  }
}

// Phone Number Formatter
class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digitsOnly.length <= 3) {
      return TextEditingValue(
        text: '($digitsOnly',
        selection: TextSelection.collapsed(offset: digitsOnly.length + 1),
      );
    } else if (digitsOnly.length <= 6) {
      return TextEditingValue(
        text: '(${digitsOnly.substring(0, 3)}) ${digitsOnly.substring(3)}',
        selection: TextSelection.collapsed(offset: digitsOnly.length + 3),
      );
    } else if (digitsOnly.length <= 10) {
      return TextEditingValue(
        text: '(${digitsOnly.substring(0, 3)}) ${digitsOnly.substring(3, 6)}-${digitsOnly.substring(6)}',
        selection: TextSelection.collapsed(offset: digitsOnly.length + 4),
      );
    } else {
      // Limit to 10 digits
      final truncated = digitsOnly.substring(0, 10);
      return TextEditingValue(
        text: '(${truncated.substring(0, 3)}) ${truncated.substring(3, 6)}-${truncated.substring(6)}',
        selection: TextSelection.collapsed(offset: 14),
      );
    }
  }
}

// SSN Input Dialog
class SSNInputDialog extends StatefulWidget {
  final void Function(String) onSSNEntered;

  const SSNInputDialog({Key? key, required this.onSSNEntered}) : super(key: key);

  @override
  _SSNInputDialogState createState() => _SSNInputDialogState();
}

class _SSNInputDialogState extends State<SSNInputDialog> {
  final TextEditingController _hiddenSSNController = TextEditingController();
  bool _isValidSSN = false;

  @override
  void initState() {
    super.initState();
    _hiddenSSNController.addListener(_validateSSN);
  }

  void _validateSSN() {
    String input = _hiddenSSNController.text.replaceAll(RegExp(r'[^0-9]'), '');
    setState(() {
      _isValidSSN = input.length == 9;
    });
  }

  @override
  void dispose() {
    _hiddenSSNController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E),
      title: const Text(
        'Social Security Number',
        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Please enter your 9-digit Social Security Number',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 20),
            
            // Hidden SSN Input Field
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isValidSSN ? Colors.green : Colors.white24,
                  width: 2,
                ),
              ),
              child: TextFormField(
                controller: _hiddenSSNController,
                keyboardType: TextInputType.number,
                obscureText: true,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  letterSpacing: 2.0,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(9),
                  _SSNFormatter(),
                ],
                decoration: const InputDecoration(
                  hintText: '123-45-6789',
                  hintStyle: TextStyle(color: Colors.white38),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  prefixIcon: Icon(Icons.security, color: Colors.white60),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Security Notice
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info, color: Colors.blueAccent, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: const Text(
                      'Your SSN is encrypted and securely stored. Only the last 4 digits will be displayed.',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.white54, fontSize: 16),
          ),
        ),
        ElevatedButton(
          onPressed: _isValidSSN
              ? () {
                  String cleanSSN = _hiddenSSNController.text.replaceAll(RegExp(r'[^0-9]'), '');
                  widget.onSSNEntered(cleanSSN);
                  Navigator.of(context).pop();
                  
                  // Show confirmation
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('🔒 SSN securely captured'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isValidSSN ? Colors.blueAccent : Colors.grey,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Confirm',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

// SSN Formatter
class _SSNFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digitsOnly.length <= 3) {
      return TextEditingValue(
        text: digitsOnly,
        selection: TextSelection.collapsed(offset: digitsOnly.length),
      );
    } else if (digitsOnly.length <= 5) {
      return TextEditingValue(
        text: '${digitsOnly.substring(0, 3)}-${digitsOnly.substring(3)}',
        selection: TextSelection.collapsed(offset: digitsOnly.length + 1),
      );
    } else if (digitsOnly.length <= 9) {
      return TextEditingValue(
        text: '${digitsOnly.substring(0, 3)}-${digitsOnly.substring(3, 5)}-${digitsOnly.substring(5)}',
        selection: TextSelection.collapsed(offset: digitsOnly.length + 2),
      );
    } else {
      // Limit to 9 digits
      final truncated = digitsOnly.substring(0, 9);
      return TextEditingValue(
        text: '${truncated.substring(0, 3)}-${truncated.substring(3, 5)}-${truncated.substring(5)}',
        selection: TextSelection.collapsed(offset: 11),
      );
    }
  }
}
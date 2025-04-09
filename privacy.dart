import 'package:flutter/material.dart';

class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({Key? key}) : super(key: key);

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  bool _locationServices = true;
  bool _dataCollection = true;
  bool _accountVisible = true;
  bool _marketingEmails = false;
  bool _dataSharing = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Privacy Settings', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manage Your Privacy',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Control how your data is used and who can see your information.',
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
            const SizedBox(height: 24),
            
            // Manage Your Data Section
            _buildSection(
              'Manage Your Data',
              [
                ListTile(
                  title: const Text('Download personal data', style: TextStyle(color: Colors.white)),
                  subtitle: Text('Request a copy of your information', style: TextStyle(color: Colors.grey[400])),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                  onTap: () {
                    _showDownloadDataDialog();
                  },
                ),
                const Divider(color: Colors.grey),
                ListTile(
                  title: const Text('Request data deletion', style: TextStyle(color: Colors.white)),
                  subtitle: Text('Delete non-essential data we have collected', style: TextStyle(color: Colors.grey[400])),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                  onTap: () {
                    _showDeleteDataDialog();
                  },
                ),
                const Divider(color: Colors.grey),
                ListTile(
                  title: const Text('Data sharing permissions', style: TextStyle(color: Colors.white)),
                  subtitle: Text('Control how your data is shared with partners', style: TextStyle(color: Colors.grey[400])),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                  onTap: () {
                    _showDataSharingDialog();
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              'Account Privacy',
              [
                _buildSwitchTile(
                  'Account Visibility',
                  'Allow other users to find your account',
                  _accountVisible,
                  (value) {
                    setState(() {
                      _accountVisible = value;
                    });
                  },
                ),
                const Divider(color: Colors.grey),
                ListTile(
                  title: const Text('Blocked Accounts', style: TextStyle(color: Colors.white)),
                  subtitle: Text('Manage accounts you\'ve blocked', style: TextStyle(color: Colors.grey[400])),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                  onTap: () {
                    // Navigate to blocked accounts screen
                  },
                ),
                const Divider(color: Colors.grey),
                ListTile(
                  title: const Text('Activity Status', style: TextStyle(color: Colors.white)),
                  subtitle: Text('Control who can see when you\'re active', style: TextStyle(color: Colors.grey[400])),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                  onTap: () {
                    // Navigate to activity status screen
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            _buildSection(
              'Data & Permissions',
              [
                _buildSwitchTile(
                  'Location Services',
                  'Allow app to access your location',
                  _locationServices,
                  (value) {
                    setState(() {
                      _locationServices = value;
                    });
                  },
                ),
                const Divider(color: Colors.grey),
                _buildSwitchTile(
                  'Data Collection',
                  'Allow analytics to improve app experience',
                  _dataCollection,
                  (value) {
                    setState(() {
                      _dataCollection = value;
                    });
                  },
                ),
                const Divider(color: Colors.grey),
                _buildSwitchTile(
                  'Data Sharing',
                  'Allow sharing data with marketing partners',
                  _dataSharing,
                  (value) {
                    setState(() {
                      _dataSharing = value;
                    });
                  },
                ),
                const Divider(color: Colors.grey),
                ListTile(
                  title: const Text('App Permissions', style: TextStyle(color: Colors.white)),
                  subtitle: Text('Manage camera, microphone, and other permissions', style: TextStyle(color: Colors.grey[400])),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                  onTap: () {
                    // Navigate to app permissions screen
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            _buildSection(
              'Communication Preferences',
              [
                _buildSwitchTile(
                  'Marketing Emails',
                  'Receive product updates and offers',
                  _marketingEmails,
                  (value) {
                    setState(() {
                      _marketingEmails = value;
                    });
                  },
                ),
                const Divider(color: Colors.grey),
                ListTile(
                  title: const Text('Email Preferences', style: TextStyle(color: Colors.white)),
                  subtitle: Text('Customize the types of emails you receive', style: TextStyle(color: Colors.grey[400])),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                  onTap: () {
                    // Navigate to email preferences screen
                  },
                ),
                const Divider(color: Colors.grey),
                ListTile(
                  title: const Text('Push Notifications', style: TextStyle(color: Colors.white)),
                  subtitle: Text('Manage app notifications', style: TextStyle(color: Colors.grey[400])),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                  onTap: () {
                    // Navigate to push notifications screen
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Privacy Policy Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'To learn more about how we handle your data, please read our',
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      // Navigate to privacy policy
                    },
                    child: const Text(
                      'Privacy Policy',
                      style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method to build sections with a title and child widgets.
  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  /// Helper method to build a switch tile.
  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[400])),
      value: value,
      activeColor: Colors.greenAccent,
      onChanged: onChanged,
    );
  }
  
  // Dialogs for data management
  void _showDownloadDataDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Download personal data',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'It may take a few weeks to prepare your download. Once it\'s ready, your data will be available to download for 30 days.',
              style: TextStyle(color: Colors.grey[400]),
            ),
            const SizedBox(height: 24),
            const Text(
              'Why we collect data',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'We collect data so we can deliver financial services, provide content that\'s more relevant to you, and to comply with applicable laws and regulations. We don\'t sell your personal information.',
              style: TextStyle(color: Colors.grey[400]),
            ),
            const SizedBox(height: 24),
            const Text(
              'Data in your download',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildExpandableItem('Data you provide to us'),
            _buildExpandableItem('Data we collect automatically'),
            _buildExpandableItem('Data from other sources'),
            const SizedBox(height: 24),
            Text(
              'Your data will be available for 30 days after it\'s ready.',
              style: TextStyle(color: Colors.grey[400]),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data download requested')),
                  );
                },
                child: const Text('Request personal data', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showDeleteDataDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Data deletion request',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'We\'ll delete data collected for reasons other than providing a financial product/service, such as for marketing. We won\'t delete data that\'s essential to operating your account, or that we\'re required or permitted to keep under federal laws governing financial institutions. Requesting to delete data won\'t delete or deactivate your account.',
              style: TextStyle(color: Colors.grey[400]),
            ),
            const SizedBox(height: 24),
            const Text(
              'Why we collect data',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'We collect personal information as described in our Privacy Policy, including so that we can deliver financial services, provide content that\'s more relevant to you, and to comply with applicable laws and regulations. We don\'t sell your personal information.',
              style: TextStyle(color: Colors.grey[400]),
            ),
            const SizedBox(height: 24),
            const Text(
              'Data we\'ll delete',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildExpandableItem('Data we collect automatically'),
            _buildExpandableItem('Data from other sources'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Non-essential data deletion requested')),
                  );
                },
                child: const Text('Delete non-essential data', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showDataSharingDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Data sharing permissions',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              const Text(
                'Configure',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Data sharing enabled',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Switch(
                    value: _dataSharing,
                    activeColor: Colors.green,
                    onChanged: (value) {
                      setModalState(() {
                        _dataSharing = value;
                      });
                      setState(() {
                        _dataSharing = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Our app works with marketing partners to more effectively market our services to you across other websites. This makes the advertisements you see on other platforms more relevant to your interests and provides us advertising-related services.',
                style: TextStyle(color: Colors.grey[400]),
              ),
              const SizedBox(height: 16),
              Text(
                'By disabling data sharing, we will no longer share personal information with these partners for the purposes mentioned above.',
                style: TextStyle(color: Colors.grey[400]),
              ),
              const SizedBox(height: 16),
              Text(
                'Please note that this feature does not relate to data shared with market makers. We only sends market makers anonymized order data, not personal information, to help get you the best possible execution price.',
                style: TextStyle(color: Colors.grey[400]),
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () {
                    // Navigate to privacy policy
                  },
                  child: const Text(
                    'Privacy Policy',
                    style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () {
                    // Show more information
                  },
                  child: const Text(
                    'Learn more about data sharing',
                    style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildExpandableItem(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[800]!)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        onTap: () {
          // Toggle expansion logic would go here
        },
      ),
    );
  }
}
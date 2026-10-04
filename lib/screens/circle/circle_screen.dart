import 'package:flutter/material.dart';
import '../../theme.dart';

class CircleScreen extends StatefulWidget {
  @override
  State<CircleScreen> createState() => _CircleScreenState();
}

class _CircleScreenState extends State<CircleScreen> {
  final List<Map<String, dynamic>> contacts = [
    {
      'name': 'Mom',
      'phone': '+91 98765 43210',
      'relation': 'Mother',
      'locationSharing': true,
    },
    {
      'name': 'Best Friend',
      'phone': '+91 87654 32109',
      'relation': 'Friend',
      'locationSharing': true,
    },
    {
      'name': 'Roommate',
      'phone': '+91 76543 21098',
      'relation': 'Roommate',
      'locationSharing': false,
    },
  ];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController relationController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    relationController.dispose();
    super.dispose();
  }

  void showAddContactSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Trusted Contact',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 20),
              _buildTextField(nameController, 'Full Name'),
              SizedBox(height: 12),
              _buildTextField(phoneController, 'Phone Number'),
              SizedBox(height: 12),
              _buildTextField(relationController, 'Relationship'),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (nameController.text.trim().isEmpty ||
                        phoneController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Name and phone are required'),
                          backgroundColor: AppTheme.error,
                        ),
                      );
                      return;
                    }

                    setState(() {
                      contacts.add({
                        'name': nameController.text.trim(),
                        'phone': phoneController.text.trim(),
                        'relation': relationController.text.trim().isEmpty
                            ? 'Contact'
                            : relationController.text.trim(),
                        'locationSharing': false,
                      });
                    });

                    nameController.clear();
                    phoneController.clear();
                    relationController.clear();

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Contact added to your circle'),
                        backgroundColor: AppTheme.success,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                  ),
                  child: Text(
                    'Add Contact',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.background,
        border: Border.all(color: AppTheme.surfaceLight),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: AppTheme.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppTheme.textSecondary),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    );
  }

  void removeContact(int index) {
    final removedName = contacts[index]['name'];
    setState(() {
      contacts.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$removedName removed from circle')),
    );
  }

  void toggleLocationSharing(int index) {
    setState(() {
      contacts[index]['locationSharing'] = !contacts[index]['locationSharing'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('Trusted Circle'),
        centerTitle: true,
      ),
      body: contacts.isEmpty ? _buildEmptyState() : _buildContactsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddContactSheet,
        backgroundColor: AppTheme.primary,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: AppTheme.textSecondary),
            SizedBox(height: 16),
            Text(
              'No trusted contacts yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8),
            Text(
              'Add people you trust to notify them during an emergency',
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactsList() {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppTheme.primary, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'These contacts are notified when you trigger an SOS alert',
                    style: TextStyle(fontSize: 12, color: AppTheme.textPrimary),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${contacts.length} Trusted ${contacts.length == 1 ? 'Contact' : 'Contacts'}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 12),
          ...contacts.asMap().entries.map((entry) {
            final index = entry.key;
            final contact = entry.value;
            return Container(
              padding: EdgeInsets.all(14),
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                border: Border.all(color: AppTheme.surfaceLight),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: AppTheme.primary.withOpacity(0.2),
                        child: Text(
                          (contact['name'] as String)[0].toUpperCase(),
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              contact['name'] as String,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '${contact['relation']} • ${contact['phone']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline, color: AppTheme.error, size: 20),
                        onPressed: () => removeContact(index),
                      ),
                    ],
                  ),
                  Divider(color: AppTheme.surfaceLight, height: 20),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 18, color: AppTheme.textSecondary),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Share real-time location during SOS',
                          style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                        ),
                      ),
                      Switch(
                        value: contact['locationSharing'] as bool,
                        activeColor: AppTheme.primary,
                        onChanged: (value) => toggleLocationSharing(index),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
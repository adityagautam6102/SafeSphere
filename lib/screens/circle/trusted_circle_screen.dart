import 'package:flutter/material.dart';
import '../../theme.dart';

class TrustedContact {
  String id;
  String name;
  String phone;
  String relation;

  TrustedContact({required this.id, required this.name, required this.phone, required this.relation});
}

class TrustedCircleScreen extends StatefulWidget {
  @override
  State<TrustedCircleScreen> createState() => _TrustedCircleScreenState();
}

class _TrustedCircleScreenState extends State<TrustedCircleScreen> {
  // Mocked for now — will load/save via Supabase `trusted_contacts` table in the backend pass
  final List<TrustedContact> contacts = [
    TrustedContact(id: '1', name: 'Mom', phone: '+91 98765 43210', relation: 'Mother'),
    TrustedContact(id: '2', name: 'Best Friend', phone: '+91 87654 32109', relation: 'Friend'),
    TrustedContact(id: '3', name: 'Roommate', phone: '+91 76543 21098', relation: 'Roommate'),
  ];

  void _openAddContactSheet({TrustedContact? existing}) {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final phoneController = TextEditingController(text: existing?.phone ?? '');
    final relationController = TextEditingController(text: existing?.relation ?? '');

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: AppTheme.surfaceLight, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              SizedBox(height: 20),
              Text(
                existing == null ? 'Add Trusted Contact' : 'Edit Contact',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 20),
              _buildTextField(nameController, 'Full Name', Icons.person_outline),
              SizedBox(height: 12),
              _buildTextField(phoneController, 'Phone Number', Icons.phone_outlined, keyboardType: TextInputType.phone),
              SizedBox(height: 12),
              _buildTextField(relationController, 'Relationship (e.g. Mother, Friend)', Icons.favorite_outline),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (nameController.text.trim().isEmpty || phoneController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(sheetContext).showSnackBar(
                        SnackBar(content: Text('Name and phone number are required')),
                      );
                      return;
                    }

                    setState(() {
                      if (existing != null) {
                        existing.name = nameController.text.trim();
                        existing.phone = phoneController.text.trim();
                        existing.relation = relationController.text.trim();
                      } else {
                        contacts.add(TrustedContact(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: nameController.text.trim(),
                          phone: phoneController.text.trim(),
                          relation: relationController.text.trim().isEmpty ? 'Contact' : relationController.text.trim(),
                        ));
                      }
                    });

                    Navigator.pop(sheetContext);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    existing == null ? 'Add Contact' : 'Save Changes',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {TextInputType? keyboardType}) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.background,
        border: Border.all(color: AppTheme.surfaceLight),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: AppTheme.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
          prefixIcon: Icon(icon, color: AppTheme.textSecondary, size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  void _removeContact(String id) {
    setState(() {
      contacts.removeWhere((c) => c.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Contact removed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('Trusted Circle'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primary,
        onPressed: () => _openAddContactSheet(),
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: contacts.isEmpty ? _buildEmptyState() : _buildContactsList(),
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
              'Add people you trust — they\'ll be notified instantly when you activate SOS.',
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _openAddContactSheet(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Text('Add Your First Contact', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactsList() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Container(
          padding: EdgeInsets.all(14),
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.1),
            border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: AppTheme.primary, size: 18),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'These contacts are notified with your live location when you trigger SOS.',
                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
              ),
            ],
          ),
        ),
        ...contacts.map((contact) => _buildContactCard(contact)).toList(),
        SizedBox(height: 80), // room above FAB
      ],
    );
  }

  Widget _buildContactCard(TrustedContact contact) {
    return Dismissible(
      key: Key(contact.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppTheme.error.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.delete_outline, color: AppTheme.error),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
              context: context,
              builder: (dialogContext) => AlertDialog(
                backgroundColor: AppTheme.surface,
                title: Text('Remove Contact?', style: TextStyle(color: AppTheme.textPrimary)),
                content: Text('${contact.name} will no longer be notified during SOS.', style: TextStyle(color: AppTheme.textSecondary)),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext, false),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext, true),
                    child: Text('Remove', style: TextStyle(color: AppTheme.error)),
                  ),
                ],
              ),
            ) ??
            false;
      },
      onDismissed: (direction) => _removeContact(contact.id),
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: Border.all(color: AppTheme.surfaceLight),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppTheme.primary.withOpacity(0.2),
              child: Text(
                contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
                style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(contact.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                  SizedBox(height: 2),
                  Text(contact.relation, style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                  SizedBox(height: 2),
                  Text(contact.phone, style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit_outlined, color: AppTheme.textSecondary, size: 20),
              onPressed: () => _openAddContactSheet(existing: contact),
            ),
          ],
        ),
      ),
    );
  }
}
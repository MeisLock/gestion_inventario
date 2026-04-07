import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user!.uid)
        .get();

    if (doc.exists) {
      setState(() {
        _userData = doc.data();
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  String _formatDate(dynamic value) {
    if (value == null) return 'Sin fecha';
    if (value is Timestamp) {
      final date = value.toDate();
      return '${date.day}/${date.month}/${date.year}';
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.navigate_before_outlined),
        ),
        title: Text('Mi perfil', style: TextStyle(color: colorScheme.onSurface)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  // Foto de perfil
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: colorScheme.primaryContainer,
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : null,
                    child: user?.photoURL == null
                        ? Icon(Icons.person, size: 60, color: colorScheme.primary)
                        : null,
                  ),

                  const SizedBox(height: 24),

                  // Nombre
                  _InfoTile(
                    icon: Icons.person_outline,
                    label: _userData?['nombre'] ?? 'Sin nombre',
                    colorScheme: colorScheme,
                  ),

                  const SizedBox(height: 12),

                  // Email
                  _InfoTile(
                    icon: Icons.email_outlined,
                    label: user?.email ?? 'Sin email',
                    colorScheme: colorScheme,
                  ),

                  const SizedBox(height: 12),

                  // Fecha de nacimiento
                  _InfoTile(
                    icon: Icons.cake_outlined,
                    label: _formatDate(_userData?['fechaNacimiento']),
                    colorScheme: colorScheme,
                  ),
                ],
              ),
            ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme colorScheme;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
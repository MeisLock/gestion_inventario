import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gestion_inventario/theme/theme_controller.dart';
import 'package:gestion_inventario/widgets/dialog_cerrar_sesion.dart';

class MenuScreenWidget extends StatefulWidget {
  const MenuScreenWidget({super.key});

  @override
  State<MenuScreenWidget> createState() => _MenuScreenStateWidget();
}

class _MenuScreenStateWidget extends State<MenuScreenWidget> {

  // 🔹 Método para poder crear las diferentes opciones del menu
  Widget _buildMenuTile(BuildContext context, IconData icon, String title, VoidCallback onTap, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: colorScheme.onSurface),
        title: Text(title, style: TextStyle(color: colorScheme.onSurface)),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
  
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = ThemeController.themeMode.value == ThemeMode.dark;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withValues(alpha: 0.02),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 70,
                    width: double.infinity,
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.white,
                          Colors.white,
                          Colors.transparent,
                        ],
                        stops: [0.0, 0.08, 0.92, 1.0],
                      ).createShader(bounds),
                      blendMode: BlendMode.dstIn,
                      child: Container(
                        color: colorScheme.surface.withValues(alpha: 0.2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 40),
                            Text(
                              'Opciones',
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              isDark
                                  ? Icons.nightlight_round
                                  : Icons.wb_sunny_outlined,
                              color: colorScheme.onSurface,
                            ),
                            Switch(
                              value: isDark,
                              onChanged: (value) {
                                setState(() {
                                  ThemeController.toggleTheme();
                                });
                              },
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // 🔹 ListView previamente creado + añadir el widget buildList
                   ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: [
                      _buildMenuTile(
                        context,
                        Icons.home,
                        'Inicio',
                        () => Navigator.pop(context),
                        colorScheme,
                      ),
                      _buildMenuTile(
                        context,
                        Icons.inventory,
                        'Productos',
                        () => Navigator.pop(context),
                        colorScheme,
                      ),
                      _buildMenuTile(
                        context,
                        Icons.logout,
                        'Cerrar sesión',
                        () async => mostrarDialogoCerrarSesion(context),
                        colorScheme,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gestion_inventario/theme/theme_controller.dart';

class MenuScreenWidget extends StatefulWidget {
  const MenuScreenWidget({super.key});

  @override
  State<MenuScreenWidget> createState() => _MenuScreenStateWidget();
}

class _MenuScreenStateWidget extends State<MenuScreenWidget> {
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
                    height: 150,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        // Fondo con degradado
                        ShaderMask(
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
                            color: colorScheme.surface.withValues(alpha: 0.85),
                            width: double.infinity,
                            height: 150,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                      ],
                    ),
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

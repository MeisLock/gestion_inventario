\# AGENTS.md - Contexto del Proyecto



\## Stack Tecnológico

\- Flutter + Dart

\- Firebase (Firestore, Authentication, etc.)

\- Arquitectura: Feature-first



\## Estructura Importante

\- `lib/features/` → Módulos de la aplicación (Inventario, Productos, Ventas, etc.)

\- `lib/functions/` → Lógica compartida y utilidades

\- `lib/core/` → Configuración global, temas, rutas (si existe)



\## Comandos Principales



\*\*Flutter\*\*

```bash

flutter pub get

flutter run

flutter analyze --fatal-infos

dart format .

flutter test

flutter build apk --release


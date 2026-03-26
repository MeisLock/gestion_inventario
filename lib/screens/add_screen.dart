import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gestion_inventario/screens/home_screen.dart';
import 'package:gestion_inventario/widgets/build_label.dart';
import 'package:gestion_inventario/widgets/custom_text_field.dart';

class AddScreen extends StatefulWidget{
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen>{
  String? _sistemaOperativo;
  int _stock = 0;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20,),
          child: IconButton(
            onPressed: () { 
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen()) 
                );
            }, 
            icon: Icon(Icons.navigate_before),
          ),
        ),
        title: Text('Añadir un producto', style: TextStyle(
          color: colorScheme.onSurface,
          ),
        
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed:() {
              
            }, 
            icon:   Icon(Icons.account_circle_outlined)
          ),
          const SizedBox(width: 14,)
        ],  
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.check, color: colorScheme.onPrimary),
          label: Text(
            'Añadir',
            style: TextStyle(color: colorScheme.onPrimary),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Center(
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              dashPattern: const [8, 5],
              color: Colors.grey,
              strokeWidth: 1.5,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: 
                Column(
                  children: [
                    buildLabel('Nombre del producto', colorScheme),
                    const SizedBox(height: 8),
                    CustomTextField(hintText: 'Nombre del producto'),
                    const SectionDivider(),
                    buildLabel('Descripción del producto', colorScheme),
                    const SizedBox(height: 8),
                    CustomTextField(hintText: 'Descripción', maxLines: 4,),
                    const SectionDivider(),
                    buildLabel('Sistema Operativo', colorScheme),
                    const SizedBox(height: 8),
                    RadioGroup<String>(
                      groupValue: _sistemaOperativo,
                      onChanged: (value) {
                        setState(() {
                          _sistemaOperativo = value;
                        });
                      },
                      child: Column(
                        children: [
                          RadioListTile<String>(
                            title: const Text('IOS'),
                            value: 'IOS',
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            tileColor: _sistemaOperativo == 'IOS'
                            ? colorScheme.primaryContainer
                            : colorScheme.surfaceContainerHighest,
                          ),
                          const SizedBox(height: 8),
                          RadioListTile<String>(
                            title: const Text('Android'),
                            value: 'Android',
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            tileColor: _sistemaOperativo == 'Android'
                            ? colorScheme.primaryContainer
                            : colorScheme.surfaceContainerHighest,
                          ),
                        ],
                      ),
                    ),
                    const SectionDivider(),
                    Row(
                      children: [
                        buildLabel('Cantidad de Stock', colorScheme),
                        Spacer(),
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 16,
                            onPressed: () {
                              setState(() {
                                if (_stock > 0) _stock--;
                              });
                            },
                            icon: Icon(Icons.remove, color: colorScheme.primary),
                            style: IconButton.styleFrom(
                              backgroundColor: colorScheme.primaryContainer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            '$_stock',
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 16,
                            onPressed: () {
                              setState(() {
                                _stock++;
                              });
                            },
                            icon: Icon(Icons.add, color: colorScheme.primary),
                            style: IconButton.styleFrom(
                              backgroundColor: colorScheme.primaryContainer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SectionDivider(),
                    buildLabel('Precio del producto', colorScheme),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: '', 
                      suffixIcon: Icon(Icons.euro_symbol),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 150, // 🔹 Altura fija en vez de Expanded
                      width: double.infinity,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(12),
                        dashPattern: const [8, 2],
                        color: colorScheme.onSurface,
                        strokeWidth: 1.5,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton.icon(
                                onPressed:() {}, 
                                label: Text('Imagen'),
                                icon: Icon(Icons.add_a_photo_outlined),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide.none
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ) 
            )
          ),
        ),
      )
    );
  }
}
// 🔹 Widget perosnalizado para los separadores
class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 14),
        Divider(color: Colors.grey.withValues(alpha: .5)),
        const SizedBox(height: 12),
      ],
    );
  }
}
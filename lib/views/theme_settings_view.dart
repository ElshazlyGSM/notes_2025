import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_2025/cubits/theme_cubit/theme_cubit.dart';
import 'package:notes_2025/widgets/theme_option_tile.dart';

class ThemeSettingsView extends StatelessWidget {
  const ThemeSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('المظهر')),
      body: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          final themeCubit = context.read<ThemeCubit>();
          final currentOption = themeCubit.currentOption;

          return ListView(
            children: [
              SizedBox(height: 16),

              // خيار الوضع الفاتح
              ThemeOptionTile(
                title: 'الوضع النهاري',
                subtitle: 'فاتح دائماً',
                icon: Icons.light_mode,
                iconColor: Colors.orange,
                isSelected: currentOption == ThemeOption.light,
                onTap: () => themeCubit.setTheme(ThemeOption.light),
              ),

              Divider(height: 1),

              // خيار الوضع الداكن
              ThemeOptionTile(
                title: 'الوضع الليلي',
                subtitle: 'داكن دائماً',
                icon: Icons.dark_mode,
                iconColor: Colors.indigo,
                isSelected: currentOption == ThemeOption.dark,
                onTap: () => themeCubit.setTheme(ThemeOption.dark),
              ),

              Divider(height: 1),

              // خيار وضع الجهاز
              ThemeOptionTile(
                title: 'وضع الجهاز',
                subtitle: 'يتبع إعدادات النظام',
                icon: Icons.settings_suggest,
                iconColor: Colors.blue,
                isSelected: currentOption == ThemeOption.system,
                onTap: () => themeCubit.setTheme(ThemeOption.system),
              ),

              SizedBox(height: 24),

              // معاينة
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.palette,
                          size: 48,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'معاينة المظهر',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'هذا مثال على شكل النصوص والعناصر',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Widget للخيار الواحد

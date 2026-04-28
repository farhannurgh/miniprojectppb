import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../widgets/custom_button.dart';
import 'report_form_screen.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key, required this.imagePath});

  final String imagePath;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  static const List<String> _availableCategories = <String>[
    'Tidak Memakai Helm',
    'Melanggar Lampu Merah',
    'Dilarang Parkir',
    'Menggunakan Handphone',
    'Tidak Memakai Sabuk Pengaman',
    'Melawan Arus',
    'Berkendara Melebihi Marka',
  ];

  final Set<String> _selectedCategories = <String>{};

  void _toggleCategory(String category, bool selected) {
    setState(() {
      if (selected) {
        _selectedCategories.add(category);
      } else {
        _selectedCategories.remove(category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> selectedCategories = _selectedCategories.toList()
      ..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Kategori'),
        backgroundColor: AppColors.blue,
        foregroundColor: AppColors.white,
      ),
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      height: 220,
                      child: Image.file(
                        File(widget.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Pilih kategori pelanggaran yang sesuai dengan foto.',
                    style: TextStyle(
                      color: AppColors.gray,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableCategories.map((category) {
                      final bool selected = _selectedCategories.contains(category);
                      return FilterChip(
                        label: Text(category),
                        selected: selected,
                        onSelected: (value) => _toggleCategory(category, value),
                        selectedColor: AppColors.green.withValues(alpha: 0.45),
                        backgroundColor: AppColors.white,
                        side: BorderSide.none,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: CustomButton(
                text: 'Lanjut',
                onPressed: selectedCategories.isEmpty
                    ? null
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => ReportFormScreen(
                              violationCategories: selectedCategories,
                              imagePath: widget.imagePath,
                            ),
                          ),
                        );
                      },
                backgroundColor: AppColors.blue,
                foregroundColor: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

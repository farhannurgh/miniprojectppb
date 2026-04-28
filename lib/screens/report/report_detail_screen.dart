import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../models/report_model.dart';

class ReportDetailScreen extends StatelessWidget {
  const ReportDetailScreen({
    super.key,
    required this.report,
  });

  final ReportModel report;

  Color _statusColor(String status) {
    switch (status) {
      case 'Selesai':
        return AppColors.success;
      case 'Diproses':
        return AppColors.warning;
      default:
        return AppColors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final File imageFile = File(report.localImagePath);
    final bool imageExists = imageFile.existsSync();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Laporan'),
        backgroundColor: AppColors.blue,
        foregroundColor: AppColors.white,
      ),
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Container(
                height: 280,
                width: double.infinity,
                color: AppColors.surfaceSoft,
                child: imageExists
                    ? Image.file(
                        imageFile,
                        fit: BoxFit.cover,
                      )
                    : const Center(
                        child: Text(
                          'Foto lokal tidak ditemukan.',
                          style: TextStyle(color: AppColors.gray),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _InfoPill(
                  label: report.status,
                  color: _statusColor(report.status),
                ),
                _InfoPill(
                  label: report.reportDate,
                  color: AppColors.gray,
                ),
                _InfoPill(
                  label: report.city,
                  color: AppColors.black,
                ),
              ],
            ),
            const SizedBox(height: 20),
            _DetailSection(
              title: 'Bentuk Pelanggaran',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: report.violationCategories
                    .map(
                      (category) => Chip(
                        backgroundColor: AppColors.green.withValues(alpha: 0.28),
                        side: BorderSide.none,
                        label: Text(category),
                      ),
                    )
                    .toList(),
              ),
            ),
            _DetailSection(
              title: 'Data Pelapor',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailRow(label: 'Nama', value: report.name),
                  _DetailRow(label: 'Telepon', value: report.phone),
                  _DetailRow(label: 'Alamat', value: report.address),
                  _DetailRow(label: 'Kota', value: report.city),
                ],
              ),
            ),
            _DetailSection(
              title: 'Penyimpanan Foto',
              child: Text(
                report.localImagePath,
                style: const TextStyle(color: AppColors.gray),
              ),
            ),
            _DetailSection(
              title: 'Lokasi GPS',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailRow(
                    label: 'Latitude',
                    value: report.latitude.toStringAsFixed(6),
                  ),
                  _DetailRow(
                    label: 'Longitude',
                    value: report.longitude.toStringAsFixed(6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 78,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.gray,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: AppColors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

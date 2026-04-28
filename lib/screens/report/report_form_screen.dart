import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../models/report_model.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../services/location_service.dart';
import '../../services/notification_service.dart';
import '../../services/storage_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/loading_overlay.dart';
import 'success_screen.dart';

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({
    super.key,
    required this.violationCategories,
    required this.imagePath,
  });

  final List<String> violationCategories;
  final String imagePath;

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  late final TextEditingController _dateController;

  bool _isConfirmed = false;
  bool _isSubmitting = false;
  bool _isLoadingLocation = false;
  Position? _currentPosition;
  String? _locationError;

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    _dateController = TextEditingController(
      text:
          '${now.day.toString().padLeft(2, '0')}/'
          '${now.month.toString().padLeft(2, '0')}/${now.year}',
    );
    _loadCurrentLocation();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _locationError = null;
    });

    try {
      final Position position = await LocationService.determinePosition();
      if (!mounted) {
        return;
      }

      setState(() {
        _currentPosition = position;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _locationError = error.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_isConfirmed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap centang pernyataan di atas'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    final String? userId = AuthService.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User belum login'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _locationError == null
                ? 'Lokasi GPS belum tersedia. Ambil lokasi terlebih dahulu.'
                : 'Lokasi GPS belum siap: $_locationError',
          ),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final String localImagePath = await StorageService.saveReportImage(
        userId: userId,
        sourceImagePath: widget.imagePath,
      );

      final String reportId = FirebaseFirestore.instance
          .collection('reports')
          .doc()
          .id;

      final ReportModel report = ReportModel(
        id: reportId,
        userId: userId,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        reportDate: _dateController.text.trim(),
        violationCategories: widget.violationCategories,
        localImagePath: localImagePath,
        status: 'Tersimpan',
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        createdAt: DateTime.now(),
      );

      await FirestoreService.saveReport(report);
      await NotificationService.showReportSavedNotification(
        categories: report.violationCategories,
        status: report.status,
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const SuccessScreen()),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengirim laporan: $error'),
          backgroundColor: AppColors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulir Pelapor'),
        backgroundColor: AppColors.blue,
        foregroundColor: AppColors.white,
      ),
      body: LoadingOverlay(
        isLoading: _isSubmitting,
        message: 'Mengirim laporan...',
        child: Container(
          color: AppColors.surface,
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _nameController,
                      label: 'Nama',
                      hintText: 'Masukkan nama Anda',
                      validator: (value) =>
                          Validators.requiredField(value, 'Nama'),
                    ),
                    CustomTextField(
                      controller: _phoneController,
                      label: 'Nomor Telepon',
                      hintText: 'Masukkan nomor telepon Anda',
                      keyboardType: TextInputType.phone,
                      validator: (value) =>
                          Validators.requiredField(value, 'Nomor telepon'),
                    ),
                    CustomTextField(
                      controller: _addressController,
                      label: 'Alamat',
                      hintText: 'Masukkan alamat Anda',
                      validator: (value) =>
                          Validators.requiredField(value, 'Alamat'),
                    ),
                    CustomTextField(
                      controller: _cityController,
                      label: 'Kota',
                      hintText: 'Masukkan kota Anda',
                      validator: (value) =>
                          Validators.requiredField(value, 'Kota'),
                    ),
                    CustomTextField(
                      controller: _dateController,
                      label: 'Tanggal Pelaporan',
                      hintText: 'Masukkan tanggal laporan',
                      readOnly: true,
                      validator: (value) =>
                          Validators.requiredField(value, 'Tanggal pelaporan'),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Kategori: ${widget.violationCategories.join(', ')}',
                        style: const TextStyle(
                          color: AppColors.gray,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Lokasi GPS'),
                      subtitle: _isLoadingLocation
                          ? const Text('Mengambil lokasi saat ini...')
                          : _currentPosition != null
                          ? Text(
                              'Lat: ${_currentPosition!.latitude.toStringAsFixed(6)}\nLng: ${_currentPosition!.longitude.toStringAsFixed(6)}',
                            )
                          : Text(
                              _locationError ??
                                  'Lokasi belum tersedia. Coba muat ulang.',
                            ),
                      trailing: IconButton(
                        onPressed: _isLoadingLocation ? null : _loadCurrentLocation,
                        icon: const Icon(Icons.refresh),
                        color: AppColors.blue,
                      ),
                    ),
                    CheckboxListTile(
                      value: _isConfirmed,
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppColors.blue,
                      title: const Text(
                        'Saya sudah mengisikan formulir dengan benar',
                        style: TextStyle(color: AppColors.black),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _isConfirmed = value ?? false;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    CustomButton(
                      text: 'Simpan Laporan',
                      onPressed: _submit,
                      backgroundColor: AppColors.blue,
                      foregroundColor: AppColors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

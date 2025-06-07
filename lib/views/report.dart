import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'dashboard.dart';

class CreateReportScreen extends StatefulWidget {
  const CreateReportScreen({Key? key}) : super(key: key);

  @override
  State<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends State<CreateReportScreen> {
  // Form controllers
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  // Form values
  String? _selectedType; // 'Lost' atau 'Found'
  String? _selectedCategory;
  DateTime? _selectedDate;

  // Loading state
  bool _isLoading = false;

  // Image file
  File? _imageFile;
  XFile? _webImageFile; // Tambahkan untuk web
  Uint8List? _webImageBytes; // Untuk preview di web

  @override
  void dispose() {
    _itemNameController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // Method untuk mengambil gambar dari galeri
  Future<void> _getImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        if (kIsWeb) {
          // Web: Baca file sebagai bytes
          final bytes = await image.readAsBytes();
          setState(() {
            _webImageFile = image;
            _webImageBytes = bytes;
            // Debug info
            print(
              'Web image selected: ${image.name}, size: ${bytes.length} bytes',
            );
          });
        } else {
          // Mobile
          setState(() {
            _imageFile = File(image.path);
            // Debug info
            print('Mobile image selected: ${image.path}');
          });
        }

        // Feedback
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gambar berhasil dipilih')),
        );
      }
    } catch (e) {
      print('Error saat memilih gambar: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memilih gambar: $e')));
    }
  }

  // Method untuk submit report ke API
  Future<void> _submitReport() async {
    if (!_validateForm()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Dapatkan token dari AuthViewModel (jika menggunakan auth)
      // Jika tidak menggunakan auth, hapus atau sesuaikan bagian ini
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final token = await authViewModel.getToken(); // Perhatikan await

      // Persiapkan data untuk dikirim
      final uri = Uri.parse('http://127.0.0.1:8000/api/v1/items');

      // Untuk multipart request (dengan file gambar)
      var request = http.MultipartRequest('POST', uri);

      // Headers
      if (token != null) {
        request.headers.addAll({
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        });
      } else {
        request.headers.addAll({'Accept': 'application/json'});
      }

      // Form fields
      request.fields['type'] = _selectedType == 'Lost' ? 'hilang' : 'ditemukan';
      request.fields['item_name'] = _itemNameController.text;
      request.fields['category'] = _selectedCategory!;
      request.fields['date_of_event'] = _formatDate(_selectedDate!);
      request.fields['description'] = _descriptionController.text;
      request.fields['email'] = _emailController.text;
      request.fields['phone_number'] = _phoneController.text;
      request.fields['location'] = _locationController.text;

      // Tambahkan file jika ada
      if (kIsWeb && _webImageFile != null) {
        final bytes = await _webImageFile!.readAsBytes();
        final multipartFile = http.MultipartFile.fromBytes(
          'photo',
          bytes,
          filename: _webImageFile!.name,
        );
        request.files.add(multipartFile);
        print(
          'Uploading web image: ${_webImageFile!.name}, size: ${bytes.length} bytes',
        );
      } else if (!kIsWeb && _imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('photo', _imageFile!.path),
        );
        print('Uploading mobile image: ${_imageFile!.path}');
      }

      // Kirim request
      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonData = json.decode(responseData);

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Sukses
        _showSuccessDialog();
      } else {
        // Error
        _showErrorDialog(jsonData['message'] ?? 'Terjadi kesalahan');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Error: ${e.toString()}');
    }
  }

  // Helper method untuk format tanggal
  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  // Validasi form
  bool _validateForm() {
    if (_selectedType == null) {
      _showErrorDialog('Pilih jenis laporan');
      return false;
    }
    if (_itemNameController.text.isEmpty) {
      _showErrorDialog('Nama barang tidak boleh kosong');
      return false;
    }
    if (_selectedCategory == null) {
      _showErrorDialog('Pilih kategori barang');
      return false;
    }
    if (_selectedDate == null) {
      _showErrorDialog('Pilih tanggal kejadian');
      return false;
    }
    if (_descriptionController.text.isEmpty) {
      _showErrorDialog('Deskripsi tidak boleh kosong');
      return false;
    }
    if (_phoneController.text.isEmpty) {
      _showErrorDialog('Nomor WhatsApp tidak boleh kosong');
      return false;
    }
    if (_emailController.text.isEmpty) {
      _showErrorDialog('Email tidak boleh kosong');
      return false;
    }
    if (_locationController.text.isEmpty) {
      _showErrorDialog('Lokasi tidak boleh kosong');
      return false;
    }
    return true;
  }

  // Dialog success
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Sukses'),
            content: const Text('Laporan berhasil dikirim'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const Dashboard()),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  // Dialog error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Create a report',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Builder(
                            builder: (context) {
                              if (kIsWeb && _webImageBytes != null) {
                                // Preview untuk Web
                                return Image.memory(
                                  _webImageBytes!,
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                );
                              } else if (!kIsWeb && _imageFile != null) {
                                // Preview untuk Mobile
                                return Image.file(
                                  _imageFile!,
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                );
                              } else {
                                // Default image
                                return Image.asset(
                                  'assets/images/gambar.png',
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                );
                              }
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: const Icon(
                                Icons.upload,
                                color: Colors.black,
                              ),
                              onPressed: _getImage,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text('Want to Report?'),
                    const SizedBox(height: 5),
                    DropdownButtonFormField<String>(
                      decoration: dropdownDecoration().copyWith(
                        hintText: "Choose Report Condition",
                      ),
                      value: _selectedType,
                      items:
                          ['Lost', 'Found'].map((val) {
                            return DropdownMenuItem(
                              value: val,
                              child: Text(val),
                            );
                          }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedType = val;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Item Name'),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _itemNameController,
                      decoration: inputDecoration(),
                    ),
                    const SizedBox(height: 16),
                    const Text('Item Category'),
                    const SizedBox(height: 5),
                    DropdownButtonFormField<String>(
                      decoration: dropdownDecoration().copyWith(
                        hintText: "Please Select Category",
                      ),
                      value: _selectedCategory,
                      items:
                          [
                            'Perhiasan Khusus',
                            'Elektronik',
                            'Buku & Dokumen',
                            'Tas & Dompet',
                            'Perlengkapan Pribadi',
                            'Peralatan Praktikum',
                            'Aksesori',
                            'Lainnya',
                          ].map((val) {
                            return DropdownMenuItem(
                              value: val,
                              child: Text(val),
                            );
                          }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedCategory = val;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Date'),
                    const SizedBox(height: 5),
                    TextField(
                      decoration: inputDecoration().copyWith(
                        hintText:
                            _selectedDate != null
                                ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                : 'dd/mm/yy',
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Description'),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: inputDecoration(),
                    ),
                    const SizedBox(height: 16),
                    const Text('Contact'),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _phoneController,
                      decoration: inputDecoration().copyWith(
                        prefixIcon: const Icon(Icons.phone),
                        hintText: 'WhatsApp number',
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _emailController,
                      decoration: inputDecoration().copyWith(
                        prefixIcon: const Icon(Icons.email),
                        hintText: 'Email address',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    const Text('Pin Location'),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _locationController,
                      maxLines: 3,
                      decoration: inputDecoration(),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _submitReport,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF004274),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
    );
  }

  InputDecoration inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: '',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }

  InputDecoration dropdownDecoration() => inputDecoration();
}

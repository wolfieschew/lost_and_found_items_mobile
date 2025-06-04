import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyActivityPage extends StatefulWidget {
  const MyActivityPage({super.key});
  @override
  State<MyActivityPage> createState() => _MyActivityPageState();
}

class _MyActivityPageState extends State<MyActivityPage> {
  String selectedCategory = "Category";
  String selectedReportType = "Report";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 75,
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 16.0,
        title: Text(
          'My Activity',
          style: GoogleFonts.lato(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 16.0),
        //     child: Container(
        //       decoration: BoxDecoration(
        //         color: Colors.white,
        //         borderRadius: BorderRadius.circular(5.0),
        //         boxShadow: [
        //           BoxShadow(
        //             color: Colors.grey.withOpacity(0.2),
        //             spreadRadius: 1,
        //             blurRadius: 2,
        //             offset: const Offset(0, 1),
        //           ),
        //         ],
        //       ),
        //       child: IconButton(
        //         // Ganti Icons.menu dengan Icons.sort
        //         icon: const Icon(Icons.sort, color: Color(0xFF004274)),
        //         onPressed: () {
        //           // Handle sort function
        //         },
        //         constraints: const BoxConstraints.tightFor(
        //           width: 40,
        //           height: 40,
        //         ),
        //       ),
        //     ),
        //   ),
        //   Padding(
        //     padding: const EdgeInsets.only(right: 16.0),
        //     child: Container(
        //       decoration: BoxDecoration(
        //         color: Colors.white,
        //         borderRadius: BorderRadius.circular(5.0),
        //         boxShadow: [
        //           BoxShadow(
        //             color: Colors.grey.withOpacity(0.2),
        //             spreadRadius: 1,
        //             blurRadius: 2,
        //             offset: const Offset(0, 1),
        //           ),
        //         ],
        //       ),
        //       child: IconButton(
        //         icon: const Icon(Icons.menu, color: Color(0xFF004274)),
        //         onPressed: () {
        //           // Handle menu
        //         },
        //         constraints: const BoxConstraints.tightFor(
        //           width: 40,
        //           height: 40,
        //         ),
        //       ),
        //     ),
        //   ),
        // ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey[300], height: 1.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                _buildDropdown(
                  "Category",
                  selectedCategory,
                  (value) {
                    setState(() => selectedCategory = value!);
                  },
                  const ["Category", "Electronic", "Accesories", "Wallet"],
                ),
                const SizedBox(width: 8),
                _buildDropdown("Report", selectedReportType, (value) {
                  setState(() => selectedReportType = value!);
                }, const ["Report", "Lost", "Found"]),

                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Color(0xFF004274),
                        ),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 40,
                          minHeight: 40,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  laporanCard(
                    context,
                    'assets/images/wallet.png',
                    'Dompet Cokelat',
                    '4/4/2025',
                    'Hilang',
                    'Aksesoris',
                    'Jam tangan merek Casio warna hitam hilang di taman.',
                    '08123456789',
                    'user@example.com',
                  ),
                  laporanCard(
                    context,
                    'assets/images/wallet.png',
                    'Dompet',
                    '3/3/2025',
                    'Hilang',
                    'Dompet',
                    'Dompet cokelat berisi KTP dan SIM hilang di kantin.',
                    '08234567890',
                    'user2@example.com',
                  ),
                  laporanCard(
                    context,
                    'assets/images/key.png',
                    'Kunci Motor',
                    '2/2/2025',
                    'Ditemukan',
                    'Barang Penting',
                    'Ditemukan Kunci Di GKU.',
                    '08345678901',
                    'user3@example.com',
                  ),
                  laporanCard(
                    context,
                    'assets/images/ktm.png',
                    'KTM Bagas',
                    '1/1/2025',
                    'Ditemukan',
                    'Dokumen Penting',
                    'KTM Ditemukan di parkiran.',
                    '08456789012',
                    'user4@example.com',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    Function(String?) onChanged,
    List<String> items,
  ) {
    const double borderRadius = 28.0;

    return SizedBox(
      width: 155,
      child: StatefulBuilder(
        builder: (context, setStateLocal) {
          return Material(
            color: Colors.transparent,
            child: DropdownButtonFormField<String>(
              value: value,
              alignment: AlignmentDirectional.centerStart,
              isExpanded: true,
              decoration: InputDecoration(
                filled: value != items[0],
                fillColor:
                    value != items[0]
                        ? const Color(0xFF0D47A1).withOpacity(0.1)
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: const BorderSide(color: Color(0xFF004274)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              items:
                  items
                      .map(
                        (val) => DropdownMenuItem(
                          alignment: Alignment.centerLeft,
                          value: val,
                          child: Text(val),
                        ),
                      )
                      .toList(),
              onChanged: (newValue) {
                onChanged(newValue);
              },
              icon:
                  value != items[0]
                      ? _buildCloseButton(() {
                        onChanged(items[0]);
                      })
                      : const Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFF004274),
                      ),
              iconSize: 24,
              iconEnabledColor: const Color(0xFF004274),
              dropdownColor: Colors.white,
            ),
          );
        },
      ),
    );
  }

  Widget _buildCloseButton(VoidCallback onPressed) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: const Padding(
          padding: EdgeInsets.all(0),
          child: Icon(Icons.close, color: Color(0xFF004274)),
        ),
      ),
    );
  }

  Widget laporanCard(
    BuildContext context,
    String imageAsset,
    String judul,
    String tanggalKejadian,
    String jenisLaporan,
    String kategori,
    String deskripsi,
    String whatsapp,
    String email,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            jenisLaporan == 'Hilang'
                ? Colors.red.withOpacity(0.1)
                : jenisLaporan == 'Ditemukan'
                ? Colors.green.withOpacity(0.1)
                : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.translate(
                offset: Offset(0, -8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    imageAsset,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 60),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 4), // margin top
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start, // rata kiri
                          children: [
                            Text(
                              judul,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text("$tanggalKejadian"),
                            Text(
                              deskripsi.length > 50
                                  ? "${deskripsi.substring(0, 20)}..."
                                  : deskripsi,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => EditReportPage(
                                        imageAsset: imageAsset,
                                        judul: judul,
                                        jenisLaporan: jenisLaporan,
                                        kategori: kategori,
                                        tanggalKejadian: tanggalKejadian,
                                        deskripsi: deskripsi,
                                        whatsapp: whatsapp,
                                        email: email,
                                      ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(
                                0xFF004274,
                              ).withOpacity(0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text(
                              "Edit",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------- EditReportPage ----------------------
class EditReportPage extends StatefulWidget {
  final String imageAsset,
      judul,
      jenisLaporan,
      kategori,
      tanggalKejadian,
      deskripsi,
      whatsapp,
      email;

  const EditReportPage({
    super.key,
    required this.imageAsset,
    required this.judul,
    required this.jenisLaporan,
    required this.kategori,
    required this.tanggalKejadian,
    required this.deskripsi,
    required this.whatsapp,
    required this.email,
  });

  @override
  State<EditReportPage> createState() => _EditReportPageState();
}

class _EditReportPageState extends State<EditReportPage> {
  late TextEditingController itemNameController,
      descriptionController,
      whatsappController,
      emailController;
  String? selectedCondition, selectedCategory;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    itemNameController = TextEditingController(text: widget.judul);
    descriptionController = TextEditingController(text: widget.deskripsi);
    whatsappController = TextEditingController(text: widget.whatsapp);
    emailController = TextEditingController(text: widget.email);
    selectedCondition = widget.jenisLaporan;
    selectedCategory = widget.kategori;
    selectedDate = _parseDate(widget.tanggalKejadian);
  }

  DateTime _parseDate(String text) {
    final parts = text.split('/');
    return DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),

      appBar: AppBar(
        title: const Text("Edit Report", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          children: [
            const SizedBox(height: 30),
            _buildImageSection(),
            const SizedBox(height: 16),
            _buildDropdown(
              "Choose Report Condition",
              selectedCondition,
              (val) => setState(() => selectedCondition = val),
              const ["Hilang", "Ditemukan"],
            ),
            const SizedBox(height: 16),
            _buildTextField(itemNameController, "Item Name"),
            const SizedBox(height: 16),
            _buildDropdown(
              "Select Category",
              selectedCategory,
              (val) => setState(() => selectedCategory = val),
              const [
                "Elektronik",
                "Aksesoris",
                "Dompet",
                "Barang Penting",
                "Dokumen Penting",
                "Lainnya",
              ],
            ),
            const SizedBox(height: 16),
            _buildDatePicker(),
            const SizedBox(height: 16),
            _buildTextField(descriptionController, "Description", maxLines: 3),
            const SizedBox(height: 16),
            _buildTextField(whatsappController, "WhatsApp", icon: Icons.phone),
            const SizedBox(height: 12),
            _buildTextField(emailController, "Email", icon: Icons.email),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004274),
                  minimumSize: const Size.fromHeight(50),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String hint,
    String? value,
    void Function(String?) onChanged,
    List<String> items,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(28)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF004274)),
        ),
      ),
      dropdownColor: Colors.white,
      hint: Text(hint),
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
    IconData? icon,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDatePicker() {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText:
            selectedDate == null
                ? "dd/mm/yyyy"
                : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                dialogBackgroundColor: Colors.white,
                colorScheme: ColorScheme.light(
                  primary: Color(0xFF004274),
                  onPrimary: Colors.white,
                  onSurface: Colors.black,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) setState(() => selectedDate = picked);
      },
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: AssetImage(widget.imageAsset),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.edit, color: Colors.black),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }
}

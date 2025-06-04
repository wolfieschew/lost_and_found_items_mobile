import 'package:flutter/material.dart';
import 'package:lost_and_found_items_mobile/views/dashboard.dart';
// import 'dashboard.dart';

class CreateReportScreen extends StatelessWidget {
  const CreateReportScreen({Key? key}) : super(key: key);

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/Gelang_emas.png',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.upload, color: Colors.black),
                      onPressed: () {},
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
              items:
                  ['Lost', 'Found'].map((val) {
                    return DropdownMenuItem(value: val, child: Text(val));
                  }).toList(),
              onChanged: (val) {},
            ),
            const SizedBox(height: 16),
            const Text('Item Name'),
            const SizedBox(height: 5),
            TextField(decoration: inputDecoration()),
            const SizedBox(height: 16),
            const Text('Item Category'),
            const SizedBox(height: 5),
            DropdownButtonFormField<String>(
              decoration: dropdownDecoration().copyWith(
                hintText: "Please Select Category",
              ),
              items:
                  [
                    'Electronics',
                    'Accessories',
                    'Documents',
                    'Key',
                    'Books',
                    'Bag',
                  ].map((val) {
                    return DropdownMenuItem(value: val, child: Text(val));
                  }).toList(),
              onChanged: (val) {},
            ),
            const SizedBox(height: 16),
            const Text('Date'),
            const SizedBox(height: 5),
            TextField(
              decoration: inputDecoration().copyWith(
                hintText: 'dd/mm/yy',
                suffixIcon: const Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () {},
            ),
            const SizedBox(height: 16),
            const Text('Description'),
            const SizedBox(height: 5),
            TextField(maxLines: 4, decoration: inputDecoration()),
            const SizedBox(height: 16),
            const Text('Contact'),
            const SizedBox(height: 5),
            TextField(
              decoration: inputDecoration().copyWith(
                prefixIcon: const Icon(Icons.phone),
                hintText: 'WhatsApp number',
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: inputDecoration().copyWith(
                prefixIcon: const Icon(Icons.email),
                hintText: 'Email address',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            const Text('Pin Location'),
            const SizedBox(height: 5),
            TextField(maxLines: 3, decoration: inputDecoration()),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const Dashboard()),
                  );
                },
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

// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, use_build_context_synchronously, prefer_final_fields
import 'package:buang_bijak/screens/user_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme.dart';
import '../widgets/bottom_button.dart';
import '../widgets/date_picker.dart';
import '../widgets/dropdown.dart';

class UpdatePickupPage extends StatefulWidget {
  final String orderId;

  const UpdatePickupPage({super.key, required this.orderId});

  @override
  _UpdatePickupPageState createState() => _UpdatePickupPageState();
}

class _UpdatePickupPageState extends State<UpdatePickupPage> {
  String? selectedTimeSlot;
  String? selectedWasteType;
  TextEditingController locationController = TextEditingController();
  DateTime? selectedDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPickupData();
  }

  Future<void> updatePickupData(String orderId) async {
    if (selectedDate == null ||
        selectedTimeSlot == null ||
        selectedWasteType == null ||
        locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mohon lengkapi semua field',
              style: regular14.copyWith(color: white)),
          backgroundColor: red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pengguna belum login',
                style: regular14.copyWith(color: white)),
            backgroundColor: red,
          ),
        );
        return;
      }

      String userId = user.uid;

      // Query dokumen berdasarkan order_id dan user_id
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('ajukan_pickup')
          .where('order_id', isEqualTo: orderId)
          .where('user_id', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data tidak ditemukan',
                style: regular14.copyWith(color: white)),
            backgroundColor: red,
          ),
        );
        return;
      }

      // Update data dokumen
      DocumentSnapshot document = querySnapshot.docs.first;
      await FirebaseFirestore.instance
          .collection('ajukan_pickup')
          .doc(document.id)
          .update({
        'lokasi_pickup': locationController.text,
        'tanggal_pickup': selectedDate,
        'waktu_pickup': selectedTimeSlot,
        'jenis_sampah': selectedWasteType,
        'isRevised': true,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data berhasil diperbarui',
              style: regular14.copyWith(color: black)),
          backgroundColor: green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui data: $e',
              style: regular14.copyWith(color: black)),
          backgroundColor: green,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadPickupData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pengguna belum login',
                style: regular14.copyWith(color: white)),
            backgroundColor: red,
          ),
        );
        return;
      }

      String userId = user.uid;

      // Query dokumen berdasarkan order_id dan user_id
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('ajukan_pickup')
          .where('order_id', isEqualTo: widget.orderId)
          .where('user_id', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data tidak ditemukan',
                style: regular14.copyWith(color: white)),
            backgroundColor: red,
          ),
        );
        return;
      }

      // Ambil data dokumen pertama
      DocumentSnapshot document = querySnapshot.docs.first;

      setState(() {
        locationController.text = document['lokasi_pickup'] ?? '';
        selectedDate = (document['tanggal_pickup'] as Timestamp).toDate();
        selectedTimeSlot = document['waktu_pickup'];
        selectedWasteType = document['jenis_sampah'];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat data: $e',
              style: regular14.copyWith(color: white)),
          backgroundColor: red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: white,
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Text(
              'Revisi Ajukan Pickup',
              style: bold20.copyWith(color: black),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/banner.png',
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                            const SizedBox(height: 12.0),

                            // Lokasi Pickup
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Lokasi Pickup', style: bold16),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: locationController,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: grey3, width: 2),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: grey3, width: 2),
                                      ),
                                      hintText: locationController.text.isEmpty
                                          ? 'Masukkan alamat disini..' // Default hint text
                                          : locationController.text, // Use fetched value as hint
                                      filled: true,
                                      fillColor: white,
                                      hintStyle: regular14,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Tanggal Pickup
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tanggal Pickup', style: bold16),
                                  const SizedBox(height: 8),
                                  DatePickerWidget(
                                    decoration: InputDecoration(
                                      hintText: selectedDate == null
                                          ? 'Pilih tanggal...' // Default hint text
                                          : '${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}', // Fetched date as hint
                                      hintStyle: regular14,
                                    ),
                                    initialDate: selectedDate,
                                    onDateSelected: (DateTime date) {
                                      setState(() {
                                        selectedDate = date;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),

                            // Waktu Pickup Dropdown
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomDropdown(
                                    title: 'Waktu Pickup',
                                    items: const [
                                      'Pagi (07.00 - 08.00)',
                                      'Siang (12.00 - 13.00)',
                                      'Sore (16.00 - 17.00)',
                                      'Malam (19.00 - 20.00)',
                                    ],
                                    selectedValue: selectedTimeSlot, // Use the selected value here
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedTimeSlot = newValue;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),

                            // Jenis Sampah Dropdown
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomDropdown(
                                    title: 'Jenis Sampah',
                                    items: const [
                                      'Sampah Kertas',
                                      'Sampah Botol & Kaca',
                                      'Sampah Plastik',
                                      'Sampah Logam'
                                    ],
                                    selectedValue: selectedWasteType,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedWasteType = newValue;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Button Ajukan Pickup
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.white,
                      child: BottomButton(
                        text:
                            _isLoading ? 'loading...' : 'Revisi Ajukan Pickup',
                        color: green,
                        onPressed: () async {
                          _showConfirmDialog(context);
                        },
                        child: _isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> _showConfirmDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Ajukan Pickup", style: bold20),
          backgroundColor: white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Text(
              "Apakah data yang Anda masukkan sudah benar? Pastikan semua data sudah benar dan sesuai dengan kebutuhan Anda.",
              style: regular14,
              textAlign: TextAlign.start,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Batal", style: regular14.copyWith(color: black)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                updatePickupData(widget.orderId);
              },
              child:
                  Text("Konfirmasi", style: regular14.copyWith(color: black)),
            ),
          ],
        );
      },
    );
  }
}

// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, use_build_context_synchronously
import 'package:buang_bijak/screens/user_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme.dart';
import '../widgets/bottom_button.dart';
import '../widgets/date_picker.dart';
import '../widgets/dropdown.dart';
import 'package:uuid/uuid.dart';

class PickupPage extends StatefulWidget {
  const PickupPage({super.key});

  @override
  _PickupPageState createState() => _PickupPageState();
}

class _PickupPageState extends State<PickupPage> {
  String? selectedTimeSlot;
  String? selectedWasteType;
  TextEditingController locationController = TextEditingController();
  DateTime? selectedDate;
  bool _isLoading = false;

  // Mengajukan Pickup ke Firestore
  Future<void> submitPickupRequest() async {
    if (locationController.text.isEmpty ||
        selectedDate == null ||
        selectedTimeSlot == null ||
        selectedWasteType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Harap isi semua field',
              style: regular14.copyWith(color: white)),
          backgroundColor: red,
        ),
      );
      return;
    }

    try {
      setState(() {
        _isLoading = true; // Aktifkan state loading dan disable button
      });

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

      DateTime now = DateTime.now();
      String dateStr =
          "${now.day.toString().padLeft(2, '0')}${now.month.toString().padLeft(2, '0')}${now.year}";

      String wasteInitial;
      switch (selectedWasteType) {
        case 'Sampah Kertas':
          wasteInitial = 'SK';
          break;
        case 'Sampah Botol & Kaca':
          wasteInitial = 'SBK';
          break;
        case 'Sampah Plastik':
          wasteInitial = 'SP';
          break;
        case 'Sampah Logam':
          wasteInitial = 'SL';
          break;
        default:
          wasteInitial = '';
      }

      String timeSlotInitial;
      switch (selectedTimeSlot) {
        case 'Pagi (07.00 - 08.00)':
          timeSlotInitial = 'PI';
          break;
        case 'Siang (12.00 - 13.00)':
          timeSlotInitial = 'SG';
          break;
        case 'Sore (16.00 - 17.00)':
          timeSlotInitial = 'SE';
          break;
        case 'Malam (19.00 - 20.00)':
          timeSlotInitial = 'MM';
          break;
        default:
          timeSlotInitial = '';
      }

      var uuid = Uuid();
      String uniqueId = uuid.v4();

      String orderId = '$dateStr-$wasteInitial-$timeSlotInitial-$uniqueId';

      await FirebaseFirestore.instance.collection('ajukan_pickup').add({
        'lokasi_pickup': locationController.text,
        'tanggal_pickup': selectedDate,
        'waktu_pickup': selectedTimeSlot,
        'jenis_sampah': selectedWasteType,
        'createdAt': now,
        'order_id': orderId,
        'user_id': userId,
        'isRevised': false,
        'status': 'Pending',
        'rejectedReason': '',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pickup berhasil diajukan dengan Order ID $orderId',
              style: regular14.copyWith(color: black)),
          backgroundColor: green,
        ),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => UserScreen()),
        (route) => false,
      );

      locationController.clear();
      setState(() {
        selectedDate = null;
        selectedTimeSlot = null;
        selectedWasteType = null;
        _isLoading = false; // Nonaktifkan loading setelah submit selesai
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Pastikan loading dinonaktifkan saat error
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan saat submit pickup',
              style: regular14.copyWith(color: white)),
          backgroundColor: red,
        ),
      );

      Navigator.pop(context);
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
              Navigator.pop(context); // Goes back to the previous screen
            },
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Text(
              'Ajukan Pickup',
              style: bold20.copyWith(color: black),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        body: ConstrainedBox(
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
                                  borderSide:
                                      BorderSide(color: grey3, width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: grey3, width: 2),
                                ),
                                hintText: 'Masukkan alamat disini..',
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
                              decoration: InputDecoration(hintStyle: regular14),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomDropdown(
                              title: 'Waktu Pickup',
                              items: const [
                                'Pagi (07.00 - 08.00)',
                                'Siang (12.00 - 13.00)',
                                'Sore (16.00 - 17.00)',
                                'Malam (19.00 - 20.00)'
                              ],
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
                  text: _isLoading ? '' : 'Ajukan Pickup',
                  color: Color(0xFFCCE400),
                  onPressed:
                      _isLoading ? null : () => _showConfirmDialog(context),
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
              child: Text("Batal", style: bold14.copyWith(color: black)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                submitPickupRequest();
              },
              child: Text("Konfirmasi", style: bold14.copyWith(color: black)),
            ),
          ],
        );
      },
    );
  }
}

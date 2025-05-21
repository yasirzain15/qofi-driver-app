import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qufi_driver_app/Core/Constants/app_colors.dart';
import 'package:qufi_driver_app/Model/order_details_model.dart';

class CustomerInfo extends StatelessWidget {
  final DriverOrderDetails orderDetails;

  const CustomerInfo({super.key, required this.orderDetails});

  Future<void> _launchPhoneDialer(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchWhatsApp(String phoneNumber) async {
    final url = 'https://wa.me/$phoneNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  // Future<void> _addToContacts(
  //   BuildContext context,
  //   String name,
  //   String phone,
  // ) async {
  //   final status = await Permission.contacts.request();
  //   if (!status.isGranted) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Contacts permission denied')),
  //     );
  //     return;
  //   }

  //   try {
  //     final contact = Contact(displayName: name, phones: [Phone(phone)]);

  //     await FlutterContactsService.addContact(contact);

  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('$name added to contacts')));
  //   } catch (e) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('Failed to add contact: $e')));
  //   }
  // }

  void _showContactOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          title: const Text('Contact Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Dial Number'),
                onTap: () {
                  Navigator.pop(context);
                  _launchPhoneDialer(orderDetails.customerPhone);
                },
              ),
              // ListTile(
              //   leading: const Icon(Icons.contacts),
              //   title: const Text('Add to Contacts'),
              //   onTap: () {
              //     Navigator.pop(context);
              //     _addToContacts(
              //       context,
              //       orderDetails.customerName,
              //       orderDetails.customerPhone,
              //     );
              //   },
              // ),
              ListTile(
                leading: const Icon(Icons.message),
                title: const Text('Invite to WhatsApp'),
                onTap: () {
                  Navigator.pop(context);
                  _launchWhatsApp(orderDetails.customerPhone);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.background,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Customer Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              orderDetails.customerName,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone, size: 16),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _showContactOptions(context),
                  child: Text(
                    orderDetails.customerPhone,
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.content_copy, size: 16),
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: orderDetails.customerPhone),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Phone number copied')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

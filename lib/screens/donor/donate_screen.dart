import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../../widgets/delivery_button.dart';

class DonateScreen extends StatefulWidget {
  @override
  _DonateScreenState createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  String selectedCategory = 'Food';
  String selectedAmount = '';
  final TextEditingController _customAmountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _packagingController = TextEditingController();
  final TextEditingController _prescriptionController = TextEditingController();
  final TextEditingController _genderAgeController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  bool isAnonymous = false;
  File? _donationImage;
  final _formKey = GlobalKey<FormState>();

  // Monetization constants
  final double platformFeePercentage =
      0.05; // 5% platform fee for monetary donations
  final double deliveryFee = 2.99; // Delivery fee for in-kind donations
  String? _selectedDeliveryOption;

  final List<String> deliveryOptions = [
    'Self Pickup',
    'Volunteer Delivery',
    'Paid Delivery',
  ];

  final List<String> categories = ['Food', 'Medicine', 'Clothes', 'Money'];
  final List<IconData> categoryIcons = [
    Icons.restaurant,
    Icons.medical_services,
    Icons.checkroom,
    Icons.attach_money,
  ];
  final List<String> presetAmounts = ['\$10', '\$25', '\$50', '\$100', '\$250'];

  @override
  Widget build(BuildContext context) {
    final Color bgColor = const Color(0xFFF4F4F4);
    final Color cardColor = const Color(0xFFD6B6A4);
    final Color accentColor = Colors.brown;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF4F4F4), Color(0xFFE8F5E9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 16,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Banner
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: cardColor,
                          image: DecorationImage(
                            image: AssetImage('images/donations2.png'),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              cardColor.withOpacity(0.25),
                              BlendMode.darken,
                            ),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              left: 20,
                              bottom: 18,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Support a Cause",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 8,
                                          color: Colors.black26,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.emoji_events,
                                        color: Colors.yellow[700],
                                        size: 20,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        "Over \$10,000 donated this month!",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 6,
                                              color: Colors.black26,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Donation Category Selection
                    _sectionTitle("Donation Category"),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 8,
                        ),
                        child: _buildCategorySelector(accentColor),
                      ),
                    ),

                    const SizedBox(height: 10),
                    Divider(height: 24, thickness: 1, color: Colors.grey[200]),

                    // Show amount selection only for Money
                    if (selectedCategory == 'Money') ...[
                      _sectionTitle("Donation Amount"),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                          child: _buildAmountSelector(accentColor),
                        ),
                      ),
                      if (selectedAmount == 'Custom') ...[
                        const SizedBox(height: 10),
                        _sectionTitle("Custom Amount"),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 8,
                            ),
                            child: _buildCustomAmountInput(accentColor),
                          ),
                        ),
                      ],
                    ] else ...[
                      // Image upload for in-kind donations
                      _sectionTitle("Add a Photo (optional)"),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              _donationImage != null
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      _donationImage!,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  : Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.image,
                                      color: Colors.grey[400],
                                      size: 36,
                                    ),
                                  ),
                              const SizedBox(width: 16),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  final picker = ImagePicker();
                                  final picked = await picker.pickImage(
                                    source: ImageSource.gallery,
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      _donationImage = File(picked.path);
                                    });
                                  }
                                },
                                icon: Icon(Icons.upload),
                                label: Text('Upload'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _sectionTitle("Donation Details"),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 8,
                          ),
                          child: Column(
                            children: [
                              _buildDonationDetails(accentColor),
                              if (selectedCategory == 'Food') ...[
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: _expiryController,
                                  decoration: InputDecoration(
                                    labelText: 'Expiry Date',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator:
                                      (value) =>
                                          value == null || value.isEmpty
                                              ? 'Enter expiry date'
                                              : null,
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: _packagingController,
                                  decoration: InputDecoration(
                                    labelText: 'Packaging Type',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator:
                                      (value) =>
                                          value == null || value.isEmpty
                                              ? 'Enter packaging type'
                                              : null,
                                ),
                              ] else if (selectedCategory == 'Medicine') ...[
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: _expiryController,
                                  decoration: InputDecoration(
                                    labelText: 'Expiry Date',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator:
                                      (value) =>
                                          value == null || value.isEmpty
                                              ? 'Enter expiry date'
                                              : null,
                                ),
                                const SizedBox(height: 10),
                                DropdownButtonFormField<String>(
                                  value:
                                      _prescriptionController.text.isNotEmpty
                                          ? _prescriptionController.text
                                          : null,
                                  items:
                                      ['Yes', 'No']
                                          .map(
                                            (e) => DropdownMenuItem(
                                              value: e,
                                              child: Text(e),
                                            ),
                                          )
                                          .toList(),
                                  onChanged:
                                      (val) => setState(
                                        () =>
                                            _prescriptionController.text =
                                                val ?? '',
                                      ),
                                  decoration: InputDecoration(
                                    labelText: 'Prescription Required?',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator:
                                      (value) =>
                                          value == null || value.isEmpty
                                              ? 'Select prescription requirement'
                                              : null,
                                ),
                              ] else if (selectedCategory == 'Clothes') ...[
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: _genderAgeController,
                                  decoration: InputDecoration(
                                    labelText: 'Gender/Age Group',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator:
                                      (value) =>
                                          value == null || value.isEmpty
                                              ? 'Enter gender/age group'
                                              : null,
                                ),
                                const SizedBox(height: 10),
                                DropdownButtonFormField<String>(
                                  value:
                                      _conditionController.text.isNotEmpty
                                          ? _conditionController.text
                                          : null,
                                  items:
                                      ['New', 'Gently Used', 'Used']
                                          .map(
                                            (e) => DropdownMenuItem(
                                              value: e,
                                              child: Text(e),
                                            ),
                                          )
                                          .toList(),
                                  onChanged:
                                      (val) => setState(
                                        () =>
                                            _conditionController.text =
                                                val ?? '',
                                      ),
                                  decoration: InputDecoration(
                                    labelText: 'Condition',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator:
                                      (value) =>
                                          value == null || value.isEmpty
                                              ? 'Select condition'
                                              : null,
                                ),
                              ],
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _contactController,
                                decoration: InputDecoration(
                                  labelText: 'Contact Number',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                                validator:
                                    (value) =>
                                        value == null || value.isEmpty
                                            ? 'Enter contact number'
                                            : null,
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _locationController,
                                decoration: InputDecoration(
                                  labelText: 'Pickup Location',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator:
                                    (value) =>
                                        value == null || value.isEmpty
                                            ? 'Enter pickup location'
                                            : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 10),
                    Divider(height: 24, thickness: 1, color: Colors.grey[200]),

                    // Anonymous Donation Toggle
                    _sectionTitle("Privacy"),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 8,
                        ),
                        child: _buildPrivacyToggle(accentColor),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Delivery Option Selection (for in-kind donations)
                    if (selectedCategory != 'Money') ...[
                      const SizedBox(height: 10),
                      Divider(
                        height: 24,
                        thickness: 1,
                        color: Colors.grey[200],
                      ),

                      _sectionTitle("Delivery Option"),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                          child: Column(
                            children:
                                deliveryOptions.map((option) {
                                  return RadioListTile<String>(
                                    title: Text(option),
                                    subtitle:
                                        option == 'Paid Delivery'
                                            ? Text(
                                              'Small fee applies for logistics support',
                                            )
                                            : null,
                                    value: option,
                                    groupValue: _selectedDeliveryOption,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedDeliveryOption = value;
                                      });
                                    },
                                    activeColor: accentColor,
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                      if (_selectedDeliveryOption == null)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            bottom: 8.0,
                          ),
                          child: Text(
                            "Please select a delivery option",
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                    ],

                    const SizedBox(height: 20),

                    // Donate Button
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate() ||
                                    selectedCategory == 'Money') {
                                  // Check delivery option for in-kind donations
                                  if (selectedCategory != 'Money' &&
                                      _selectedDeliveryOption == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Please select a delivery option',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }
                                  _showDonationConfirmation(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 22,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                elevation: 10,
                                shadowColor: accentColor.withOpacity(0.25),
                                textStyle: const TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.favorite, size: 28),
                                  const SizedBox(width: 16),
                                  Text(
                                    "Donate Now",
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.verified_user,
                                color: accentColor,
                                size: 18,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Secure Payment',
                                style: TextStyle(
                                  color: accentColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 2, top: 2),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildCategorySelector(Color accentColor) {
    return Container(
      height: 56,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;
          final icon = categoryIcons[index];
          return AnimatedContainer(
            duration: Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            margin: EdgeInsets.only(right: 14),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedCategory = category;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? accentColor : Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: isSelected ? accentColor : Colors.grey.shade300,
                    width: 2,
                  ),
                  boxShadow:
                      isSelected
                          ? [
                            BoxShadow(
                              color: accentColor.withOpacity(0.18),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ]
                          : [],
                ),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: isSelected ? Colors.white : accentColor,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAmountSelector(Color accentColor) {
    return Column(
      children: [
        // Preset amounts
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.5,
          ),
          itemCount: presetAmounts.length + 1, // +1 for Custom option
          itemBuilder: (context, index) {
            if (index == presetAmounts.length) {
              // Custom amount option
              final isSelected = selectedAmount == 'Custom';
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedAmount = 'Custom';
                    _customAmountController.clear();
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? accentColor : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? accentColor : Colors.grey.shade300,
                      width: 2,
                    ),
                    boxShadow:
                        isSelected
                            ? [
                              BoxShadow(
                                color: accentColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                            : [],
                  ),
                  child: Center(
                    child: Text(
                      'Custom',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            }

            final amount = presetAmounts[index];
            final isSelected = selectedAmount == amount;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedAmount = amount;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? accentColor : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? accentColor : Colors.grey.shade300,
                    width: 2,
                  ),
                  boxShadow:
                      isSelected
                          ? [
                            BoxShadow(
                              color: accentColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                          : [],
                ),
                child: Center(
                  child: Text(
                    amount,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCustomAmountInput(Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.attach_money, color: accentColor, size: 22),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _customAmountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                prefixText: '\$',
                hintText: 'Enter amount',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey[500]),
              ),
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationDetails(Color accentColor) {
    // Choose icon and hint based on selectedCategory
    IconData icon;
    Color iconColor;
    String hint;
    switch (selectedCategory) {
      case 'Food':
        icon = Icons.restaurant;
        iconColor = Colors.orange[700]!;
        hint = 'Describe the food you want to donate (type, quantity, etc.)';
        break;
      case 'Medicine':
        icon = Icons.medical_services;
        iconColor = Colors.red[700]!;
        hint = 'Describe the medicine you want to donate (name, expiry, etc.)';
        break;
      case 'Clothes':
        icon = Icons.checkroom;
        iconColor = Colors.blue[700]!;
        hint = 'Describe the clothes you want to donate (type, size, etc.)';
        break;
      default:
        icon = Icons.info_outline;
        iconColor = accentColor;
        hint = 'Tell us about your donation (optional)';
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: hint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: accentColor, width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
              ),
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyToggle(Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.visibility_off, color: Colors.grey[600], size: 25),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      'Make this donation anonymous',
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2, // allow up to 2 lines
                      softWrap: true,
                    ),
                  ),
                  SizedBox(width: 5),
                  Tooltip(
                    message: 'Your name will not be shown to the recipient.',
                    child: Icon(
                      Icons.info_outline,
                      color: Colors.grey[400],
                      size: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Switch(
            value: isAnonymous,
            onChanged: (value) {
              setState(() {
                isAnonymous = value;
              });
            },
            activeColor: accentColor,
          ),
        ],
      ),
    );
  }

  void _showDonationConfirmation(BuildContext context) {
    final amount =
        selectedAmount == 'Custom'
            ? _customAmountController.text
            : selectedAmount;

    if (amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select or enter an amount'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Confirm Donation'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Category: $selectedCategory'),
                if (selectedCategory == 'Money') ...[
                  Text('Amount: $amount'),
                  Text(
                    'Platform Fee: \$${(double.tryParse(amount.replaceAll('\$', '')) ?? 0.0 * platformFeePercentage).toStringAsFixed(2)}',
                  ),
                ] else ...[
                  if (_descriptionController.text.isNotEmpty)
                    Text('Description: ${_descriptionController.text}'),
                  Text('Delivery: $_selectedDeliveryOption'),
                  if (_selectedDeliveryOption == 'Paid Delivery')
                    Text('Delivery Fee: \$${deliveryFee.toStringAsFixed(2)}'),
                ],
                Text('Anonymous: ${isAnonymous ? "Yes" : "No"}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _processDonation();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                ),
                child: Text('Confirm'),
              ),
            ],
          ),
    );
  }

  Future<bool> _showMonetaryPaymentDialog(String amount) async {
    double donationAmount = double.tryParse(amount.replaceAll('\$', '')) ?? 0.0;
    double platformFee = donationAmount * platformFeePercentage;
    double totalAmount = donationAmount + platformFee;

    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text('Donation Payment'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Donation Amount: \$${donationAmount.toStringAsFixed(2)}',
                    ),
                    Text(
                      'Platform Fee (5%): \$${platformFee.toStringAsFixed(2)}',
                    ),
                    Divider(),
                    Text(
                      'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'The platform fee helps us maintain the service and support more people in need.',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Here, integrate real payment logic
                      Navigator.pop(context, true); // Simulate payment success
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Pay & Donate'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  Future<bool> _showDeliveryPaymentDialog() async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text('Delivery Fee'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'A delivery fee of \$${deliveryFee.toStringAsFixed(2)} will be charged for handling logistics.',
                    ),
                    SizedBox(height: 8),
                    Text(
                      'This fee helps cover delivery costs and supports our volunteer network.',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Here, integrate real payment logic
                      Navigator.pop(context, true); // Simulate payment success
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Pay & Continue'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  void _processDonation() async {
    final amount =
        selectedAmount == 'Custom'
            ? _customAmountController.text
            : selectedAmount;

    bool paymentSuccess = true;

    // Handle monetary donations
    if (selectedCategory == 'Money') {
      if (amount.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select or enter an amount'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      paymentSuccess = await _showMonetaryPaymentDialog(amount);
      if (!paymentSuccess) return;
    }
    // Handle in-kind donations with delivery option
    else if (_selectedDeliveryOption == 'Paid Delivery') {
      paymentSuccess = await _showDeliveryPaymentDialog();
      if (!paymentSuccess) return;
    }

    // Process the donation after successful payment
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Thank you for your donation!'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate back to home screen
    Navigator.pop(context);
  }
}

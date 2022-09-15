// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:crypto_funding_app/models/funding_item.dart';
import 'package:crypto_funding_app/services/authentication_service.dart';
import 'package:crypto_funding_app/providers/database_provider.dart';
import 'package:crypto_funding_app/services/cloud_storage_service.dart';
import 'package:crypto_funding_app/themes/text_styles.dart';

import 'package:crypto_funding_app/widgets/custom_form_field.dart';
import 'package:crypto_funding_app/widgets/custom_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class AddingItemPage extends StatefulWidget {
  const AddingItemPage({Key? key}) : super(key: key);

  @override
  State<AddingItemPage> createState() => _AddingItemPageState();
}

class _AddingItemPageState extends State<AddingItemPage> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController ethController = TextEditingController();
  final TextEditingController bscController = TextEditingController();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final CloudStorageService cloudStorage = CloudStorageService();
  final AuthenticationService auth = AuthenticationService();

  File? image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void getClipboardText(TextEditingController controller) async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);

    if (clipboardData == null ||
        clipboardData.text!.trim().isEmpty ||
        clipboardData.text == null) {
      controller.text = 'Your clipboard is empty 🙂';
    } else {
      controller.text = clipboardData.text!;
    }
  }

  @override
  Widget build(BuildContext context) {
    var db = context.watch<DatabaseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adding Item'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff1e2c37),
      body: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              const SizedBox(
                height: 30,
              ),
              ZoomTapAnimation(
                onTap: () async {
                  pickImage();
                },
                child: image == null
                    ? const CircleAvatar(
                        backgroundColor: Color(0xff263742),
                        radius: 64,
                        child: Icon(
                          Icons.add,
                          size: 48,
                          color: Color(0xFF59b7b9),
                        ),
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: FileImage(
                          File(image!.path),
                        ),
                        radius: 64,
                      ),
              ),
              const SizedBox(
                height: 50,
              ),
              CustomFormField(
                controller: titleController,
                hintText: 'Title',
                validator: (value) {
                  if (value == null || value.trim().length <= 2) {
                    return 'Title length should be at least 3 characters';
                  } else if (value.length >= 20) {
                    return 'Title length should be less than 20 characters';
                  }
                  return null;
                },
                prefixIcon: Icons.abc,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomFormField(
                controller: priceController,
                textInputType: TextInputType.number,
                hintText: 'Price',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Price field should not be empty';
                  } else if (double.parse(value) < 10) {
                    return 'Price should be at least 10\$';
                  } else if (double.parse(value) > 10000000) {
                    return 'Price should be 10000000\$ or lower';
                  }
                  return null;
                },
                prefixIcon: Icons.attach_money,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomFormField(
                controller: descriptionController,
                hintText: 'Description (optional)',
                maxLines: 4,
                validator: (value) {
                  if (value!.length > 1000) {
                    return 'Max length is 1000 characters  ';
                  }
                  return null;
                },
                prefixIcon: Icons.description,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomFormField(
                controller: ethController,
                hintText: 'ETH Address',
                readOnly: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Address field should not be empty';
                  } else if (!isAddressValid(value)) {
                    return 'Address is not valid';
                  }
                  return null;
                },
                prefixIcon: Icons.currency_bitcoin,
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.paste,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    getClipboardText(ethController);
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomFormField(
                controller: bscController,
                hintText: 'BSC Address',
                readOnly: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Address field should not be empty';
                  } else if (!isAddressValid(value)) {
                    return 'Address is not valid';
                  }
                  return null;
                },
                prefixIcon: Icons.currency_bitcoin,
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.paste,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    getClipboardText(bscController);
                  },
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              ArgonButton(
                height: 50,
                width: 350,
                borderRadius: 5.0,
                color: const Color(0xFF59b7b9),
                loader: Container(
                  padding: const EdgeInsets.all(10),
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
                onTap: (startLoading, stopLoading, btnState) async {
                  if (btnState == ButtonState.Idle) {
                    startLoading();

                    if (!formKey.currentState!.validate()) {
                      stopLoading();
                      return;
                    }

                    if (image == null) {
                      stopLoading();
                      CustomSnackBar(
                        text: 'Image field should not be empty',
                      ).showSnackbar(context);
                      return;
                    }

                    String id =
                        DateTime.now().millisecondsSinceEpoch.toString();

                    String? imageURL = await cloudStorage
                        .saveUserImageToStorage(auth.uid, image!, id);

                    final fundingItem = FundingItem(
                      id: id,
                      name: titleController.text,
                      description: descriptionController.text,
                      creator: firebaseAuth.currentUser!.email!,
                      image: imageURL!,
                      price: doubleWithoutDecimalToInt(
                        double.parse(
                          double.parse(priceController.text).toStringAsFixed(2),
                        ),
                      ),
                      bscAddress: bscController.text,
                      ethAddress: ethController.text,
                      whenAdded: DateTime.now(),
                    );

                    db.addItem(
                      fundingItem.toMap(),
                    );

                    db.getItems();

                    Navigator.of(context).pop();

                    stopLoading();
                  }
                },
                child: const Text(
                  'Add',
                  style: TextStyles.buttonTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  num doubleWithoutDecimalToInt(double val) {
    return val % 1 == 0 ? val.toInt() : val;
  }

  bool isAddressValid(String address) {
    RegExp regExp = RegExp(r'^(0x){1}[0-9a-fA-F]{40}$');

    return regExp.hasMatch(address);
  }
}

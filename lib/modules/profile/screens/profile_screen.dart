import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:x_prompt/utils/constants.dart';
import 'package:x_prompt/utils/fonts.dart';
import 'package:x_prompt/widgets/primary_button.dart';
import 'package:x_prompt/flow_chain/mint_on_flow_repo.dart';
import 'package:x_prompt/utils/session_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/services.dart';
import '../../../widgets/inspired_image_box.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String longString = SessionManager.walletAddress ??
      "4xBk2ns8BnPwj6SiyrJR4ubzGfWvAefP738bV25jZ65L";
  bool gridOff = true;
  final picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  File? _image, _pickedImage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _nameController.text = prefs.getString('name') ?? 'User';
    final String? imagePath = prefs.getString('imagePath');
    _image = imagePath != null ? File(imagePath) : null;

    final ipfsImageData = await getImagesFromStorage();
    await fetchImages(ipfsImageData);
    setState(() {});
  }

  Future<void> fetchImages(List<Map<String, dynamic>> list) async {
    for (var item in list) {
      var cid = item["cid"];
      var name = item["name"];

      var url = "https://ipfs.io/ipfs/$cid/$name";
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        var prompt = jsonData["description"];
        prompt = prompt.split(',')[0];
        var image = jsonData["image"];
        image =
            "https://ipfs.io/ipfs/${image.split('/')[2]}/${image.split('/')[3]}";
        var address = jsonData["walletAddress"];
        if (address == SessionManager.walletAddress) {
          images[image] = prompt;
        }
        log(images.toString());
        setState(() {
          _isLoading = false;
        });
      } else {
        debugPrint("Request failed with status: ${response.statusCode}.");
      }
    }

    debugPrint(images.toString());
  }

  Future<void> _saveData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    if (_pickedImage != null) {
      _image = _pickedImage;
      await prefs.setString('imagePath', _image!.path);
    }
    setState(() {});
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    // ignore: deprecated_member_use
    final PickedFile? pickedFile = await picker.getImage(source: source);
    _pickedImage = pickedFile != null ? File(pickedFile.path) : _image;
    setState(() {});
  }

  //png
  Map<String, String> images = {};

  //jpeg
  Map<String, String> jpegImages = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 6.h,
              ),
              userCard(),
              SizedBox(
                height: 4.h,
              ),
              Text(
                "Creation history",
                style: appFont(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              _isLoading == true
                  ? Center(
                      child: Container(
                        height: 40.h,
                        width: 80.w,
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        margin: EdgeInsets.symmetric(vertical: 1.5.h),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff26384f).withOpacity(0.05),
                              offset: const Offset(0, 4),
                              blurRadius: 4,
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Center(
                          child: SpinKitWanderingCubes(
                            color: const Color(0xff26384f),
                            size: 35.sp,
                          ),
                        ),
                      ),
                    )
                  : DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Container(
                        height: 6.h,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade200,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Spacer(
                              flex: 2,
                            ),
                            InkWell(
                              child: Icon(
                                Icons.grid_off,
                                color: gridOff
                                    ? const Color(0xff26384f)
                                    : const Color(0XFF707EAE),
                                size: 3.5.h,
                              ),
                              onTap: () {
                                gridOff = true;
                                setState(() {});
                              },
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                gridOff = false;
                                setState(() {});
                              },
                              child: Icon(
                                Icons.grid_on,
                                color: gridOff == false
                                    ? const Color(0xff26384f)
                                    : const Color(0XFF707EAE),
                                size: 3.5.h,
                              ),
                            ),
                            const Spacer(
                              flex: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
              if (gridOff)
                Column(
                  children: images.entries.map((MapEntry mapEntry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 1),
                      child: InspiredImageBox(
                          isGeneratedScreen: true,
                          isProfileInspireBox: true,
                          imageURL: mapEntry.key,
                          imgName: mapEntry.key,
                          text: mapEntry.value),
                    );
                  }).toList(),
                ),
              if (gridOff == false)
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 1),
                  height: 35.h,
                  child: GridView(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    children: images.entries.map((MapEntry mapEntry) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(imageUrl: mapEntry.key),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              // if (gridOff == false)
              //   Container(
              //     color: Colors.white,
              //     width: double.infinity,
              //     padding: EdgeInsets.only(top: 1),
              //     height: 30.h,
              //     child: GridView(
              //       physics: NeverScrollableScrollPhysics(),
              //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //           crossAxisCount: 3),
              //       children: jpegImages.entries.map((MapEntry mapEntry) {
              //         return Padding(
              //           padding: const EdgeInsets.all(4.0),
              //           child: ClipRRect(
              //             borderRadius: BorderRadius.circular(10),
              //             child: CachedNetworkImage(imageUrl: mapEntry.key),
              //           ),
              //         );
              //       }).toList(),
              //     ),
              //   ),
              if (_isLoading == false)
                const InspiredImageBox(
                  imgName: '',
                  text: '',
                ),
            ],
          ),
        ),
      )),
    );
  }

  callSetstate() {
    if (_pickedImage != null) _image = _pickedImage;
    setState(() {});
  }

  userCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(2.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 18),
            blurRadius: 40,
            spreadRadius: 0,
            color: const Color(0XFF7090B0).withOpacity(0.12),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(
                flex: 3,
              ),
              CircleAvatar(
                radius: 50,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  clipBehavior: Clip.hardEdge,
                  child: _image == null
                      ? Image.asset(
                          "assets/playstore.png",
                          fit: BoxFit.fitHeight,
                          alignment: Alignment.center,
                        )
                      : null,
                ),
              ),
              const Spacer(flex: 2),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.blue,
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (BuildContext context,
                                        StateSetter setState) =>
                                    Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    height: 50.h,
                                    width: double.infinity,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 4.w),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Icon(
                                            Icons.edit_outlined,
                                            color: const Color(0XFF485585),
                                            size: 4.h,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _pickImage(ImageSource.gallery)
                                                  .then((value) {
                                                setState(() {});
                                              });
                                            },
                                            child: _image == null &&
                                                    _pickedImage == null
                                                ? Stack(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 50,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          clipBehavior:
                                                              Clip.hardEdge,
                                                          child: Image.asset(
                                                            "assets/playstore.png",
                                                            fit: BoxFit
                                                                .fitHeight,
                                                            alignment: Alignment
                                                                .center,
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        bottom: 0,
                                                        right: 0,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(1),
                                                          decoration:
                                                              const BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  shape: BoxShape
                                                                      .circle),
                                                          child: CircleAvatar(
                                                            radius: 15,
                                                            foregroundColor:
                                                                Colors.white,
                                                            backgroundColor:
                                                                const Color(
                                                                        0XFF4318FF)
                                                                    .withOpacity(
                                                                        0.7),
                                                            child: const Icon(
                                                              Icons
                                                                  .camera_alt_outlined,
                                                              size: 20,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                : CircleAvatar(
                                                    radius: 50,
                                                    backgroundImage:
                                                        _pickedImage != null
                                                            ? FileImage(
                                                                _pickedImage!)
                                                            : _image != null
                                                                ? FileImage(
                                                                    _image!)
                                                                : null,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      clipBehavior:
                                                          Clip.hardEdge,
                                                      child: _pickedImage ==
                                                                  null &&
                                                              _image == null
                                                          ? Image.asset(
                                                              "assets/playstore.png",
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                            )
                                                          : null,
                                                    ),
                                                  ),
                                          ),
                                          TextField(
                                            controller: _nameController,
                                            style: const TextStyle(
                                                color: Colors.black),
                                            decoration: const InputDecoration(
                                              labelText: 'Display Name',
                                              labelStyle: TextStyle(
                                                  color: Colors.black),
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                          PrimaryButton(
                                              onPressed: () {
                                                _saveData();
                                                callSetstate();
                                                Navigator.of(context).pop();
                                              },
                                              text: "Apply Changes")
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.edit_outlined,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            _nameController.text.isEmpty ? "User" : _nameController.text,
            style: appFont(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0XFF1B2559),
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            "Wallet address",
            style: appFont(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0XFF47548C),
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${longString.substring(0, 10)}...${longString.substring(longString.length - 2, longString.length)}",
                overflow: TextOverflow.ellipsis,
                style: appFont(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0XFF8F9BBA),
                ),
              ),
              SizedBox(
                width: 2.w,
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: longString));
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.copy,
                      color: Color(0XFF8F9BBA),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

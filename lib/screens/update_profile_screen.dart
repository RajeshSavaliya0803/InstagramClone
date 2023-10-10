import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instragram_app/utils/colors.dart';
import 'package:instragram_app/utils/utils.dart';
import 'package:instragram_app/widgets/text_field_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateProfileScreen extends StatefulWidget {
  final String? userimage;
  final String? username;
  final String? email;
  final String? password;
  final String? bio;

  const UpdateProfileScreen(
      {Key? key,
      this.userimage,
      this.username,
      this.email,
      this.password,
      this.bio})
      : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;

  @override
  void initState() {
    _usernameController.text = widget.username ?? '';
    _emailController.text = widget.email ?? '';
    _passwordController.text = widget.password ?? '';
    _bioController.text = widget.bio ?? '';
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);

    setState(() {
      _image = im;
    });
  }

  Future<String?> uploadImageToFirebaseStorage() async {
    try {
      if (_image == null) return null;

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      final storage = FirebaseStorage.instance;
      final Reference storageReference =
          storage.ref().child('profile_images/${user.uid}.jpg');

      final UploadTask uploadTask = storageReference.putData(_image!);
      final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});

      final imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 64,
                ),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                            backgroundColor: Colors.red,
                          )
                        : CachedNetworkImage(
                            imageUrl: widget.userimage ?? '',
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              backgroundImage: imageProvider,
                              radius: 64,
                            ),
                            placeholder: (context, url) => const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/2.png'),
                              radius: 64,
                            ),
                            errorWidget: (context, url, error) =>
                                const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/2.png'),
                              radius: 64,
                            ),
                          ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFieldInput(
                  hintText: 'Enter your username',
                  textInputType: TextInputType.text,
                  textEditingController: _usernameController,
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFieldInput(
                  hintText: 'Enter your email',
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _emailController,
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFieldInput(
                  hintText: 'Enter your bio',
                  textInputType: TextInputType.text,
                  textEditingController: _bioController,
                ),
                const SizedBox(
                  height: 24,
                ),
                InkWell(
                  onTap: updateProfile,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      color: blueColor,
                    ),
                    child: !_isLoading
                        ? const Text(
                            'Update Profile',
                          )
                        : const CircularProgressIndicator(
                            color: primaryColor,
                          ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final imageUrl = await uploadImageToFirebaseStorage();
        final CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('users');

        final userData = {
          'username': _usernameController.text,
          'email': _emailController.text,
          'bio': _bioController.text,
          'photoUrl': imageUrl ?? widget.userimage,
        };

        await usersCollection.doc(user.uid).update(userData);

        setState(() {
          _isLoading = false;
        });
        if (!mounted) return;
        showSnackBar(context, "Profile Update SuccessFully..");

        Navigator.pop(context);
      }
    } catch (e) {
      print('Error updating profile: $e');
      showSnackBar(context, e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }
}

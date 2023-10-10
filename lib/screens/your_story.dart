import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_storage_path/flutter_storage_path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instragram_app/providers/user_provider.dart';
import 'package:instragram_app/resources/firestore_methods.dart';
import 'package:instragram_app/utils/colors.dart';
import 'package:instragram_app/utils/utils.dart';
import 'package:instragram_app/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class FileModel {
  List<String>? files;
  String? folder;

  FileModel({this.files, this.folder});

  FileModel.fromJson(Map<String, dynamic> json) {
    files = json['files'].cast<String>();
    folder = json['folderName'];
  }
}

class RecentModel {
  List<String>? files;
  String? folder;

  RecentModel({this.files, this.folder});

  RecentModel.fromJson(Map<String, dynamic> json) {
    files = json['files'].cast<String>();
    folder = json['folderName'];
  }
}

class YourStoryScreen extends StatefulWidget {
  const YourStoryScreen({
    Key? key,
  }) : super(key: key);

  @override
  _YourStoryScreenState createState() => _YourStoryScreenState();
}

class _YourStoryScreenState extends State<YourStoryScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  List<FileModel>? files;
  List<RecentModel>? filess;
  RecentModel? recentModel;
  FileModel? selectedModel;
  Uint8List? _file;
  String? image;
  final ImagePicker _picker = ImagePicker();
  bool isExpanded = true;

  @override
  void initState() {
    super.initState();
    getImagesPath();
  }

  getImagesPath() async {
    var imagePath = await StoragePath.imagesPath;
    var images = jsonDecode(imagePath!) as List;
    files = images.map<FileModel>((e) => FileModel.fromJson(e)).toList();
    if (files!.isNotEmpty) {
      setState(() {
        selectedModel = files?[0];
        image = files?[0].files?[0];
      });
    }
  }

  Future<void> pickGalleryFolder() async {
    final XFile? folder = await _picker.pickImage(source: ImageSource.gallery);
    if (folder != null) {
      setState(() {
        recentModel = RecentModel(
          folder: folder.path,
          files: [folder.path],
        );
        image = folder.path;
      });
    }
  }

  Future<void> pickcameraFolder() async {
    final XFile? folder = await _picker.pickImage(source: ImageSource.camera);
    if (folder != null) {
      setState(() {
        recentModel = RecentModel(
          folder: folder.path,
          files: [folder.path],
        );
        image = folder.path;
      });
    }
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return _file != null
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        postImage(
                          context,
                          userProvider.getUser.uid,
                          userProvider.getUser.username,
                          userProvider.getUser.photoUrl,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: const Padding(
                          padding: EdgeInsets.all(13),
                          child: Text(
                            "Your Story",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: const Padding(
                        padding: EdgeInsets.all(13),
                        child: Text(
                          "Close Friendds",
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // POST FORM
            body: Column(
              children: <Widget>[
                isLoading
                    ? customLoader(context)
                    // const LinearProgressIndicator(
                    //     color: Colors.blue, minHeight: 5)
                    : const Padding(padding: EdgeInsets.only(top: 0.0)),
                SizedBox(
                  height: 300.0,
                  width: double.infinity,
                  child: AspectRatio(
                    aspectRatio: 487 / 451,
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter,
                        image: MemoryImage(_file!),
                      )),
                    ),
                  ),
                ),

                // SizedBox(
                //   height: 45.0,
                //   width: 45.0,
                //   child: AspectRatio(
                //     aspectRatio: 487 / 451,
                //     child: Container(
                //       decoration: BoxDecoration(
                //           image: DecorationImage(
                //         fit: BoxFit.fill,
                //         alignment: FractionalOffset.topCenter,
                //         image: MemoryImage(_file!),
                //       )),
                //     ),
                //   ),
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: <Widget>[
                //     CircleAvatar(
                //       backgroundImage: NetworkImage(
                //         userProvider.getUser.photoUrl,
                //       ),
                //     ),
                //     SizedBox(
                //       width: MediaQuery.of(context).size.width * 0.3,
                //       child: TextFieldInput(
                //         hintText: 'Write a caption...',
                //         textInputType: TextInputType.text,
                //         textEditingController: _descriptionController,
                //         isPass: false,
                //       ),
                //       // TextField(
                //       //   controller: _descriptionController,
                //       //   decoration: const InputDecoration(
                //       //       hintText: "Write a caption...",
                //       //       border: InputBorder.none),
                //       //   maxLines: 8,
                //       // ),
                //     ),
                //   ],
                // ),
                // const Divider(),
              ],
            ),
          )
        : Scaffold(
            body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.45,
                      child: image != null
                          ? Image.file(
                              File(image ?? ''),
                              fit: BoxFit.fill,
                              height: MediaQuery.of(context).size.height * 0.45,
                              width: MediaQuery.of(context).size.width,
                            )
                          : Container(),
                    ),
                    Positioned(
                        top: 15,
                        right: 15,
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              backgroundColor: primaryColor,
                              context: context,
                              builder: (BuildContext context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      leading: const Icon(Icons.camera,
                                          color: mobileBackgroundColor),
                                      title: const AppText(
                                        text: 'Camera',
                                        color: mobileBackgroundColor,
                                        fontWeight: FontWeight.w500,
                                        size: 15,
                                      ),
                                      onTap: () async {
                                        Navigator.pop(context);
                                        Uint8List file =
                                            await pickImage(ImageSource.camera);
                                        setState(() {
                                          _file = file;
                                        });
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.photo_library,
                                        color: mobileBackgroundColor,
                                      ),
                                      title: const AppText(
                                        text: 'Gallery',
                                        color: mobileBackgroundColor,
                                        fontWeight: FontWeight.w500,
                                        size: 15,
                                      ),
                                      onTap: () async {
                                        Navigator.of(context).pop();
                                        Uint8List file = await pickImage(
                                            ImageSource.gallery);
                                        setState(() {
                                          _file = file;
                                        });
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: const BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.upload_rounded,
                              color: mobileBackgroundColor,
                              size: 25,
                            ),
                          ),
                        )),
                  ],
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: GestureDetector(
                    onTap: () {
                      if (isExpanded == false) {
                        setState(() {
                          isExpanded = true;
                        });
                      } else {
                        setState(() {
                          isExpanded = false;
                        });
                      }
                    },
                    child: Row(
                      children: [
                        const AppText(
                          text: 'Recents',
                          fontWeight: FontWeight.w500,
                          color: primaryColor,
                          size: 15,
                        ),
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up_sharp
                              : Icons.keyboard_arrow_down_sharp,
                          size: 25,
                          color: primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 05),
                selectedModel == null
                    ? Container()
                    : isExpanded
                        ? Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.38,
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 4,
                                ),
                                itemBuilder: (_, i) {
                                  var file = selectedModel?.files?[i];
                                  return GestureDetector(
                                    child: Image.file(
                                      File(file ?? ''),
                                      fit: BoxFit.fill,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        image = file;
                                      });
                                    },
                                  );
                                },
                                itemCount: selectedModel?.files?.length,
                              ),
                            ),
                          )
                        : const SizedBox.shrink()
              ],
            ),
          ));
  }

  void postImage(BuildContext context, String uid, String username,
      String profImage) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadstory(
        _descriptionController.text,
        _file!,
        uid,
        username,
        profImage,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        if (context.mounted) {
          showSnackBar(
            context,
            'Posted!',
          );
        }
        clearImage();
        if (!mounted) return;
        Navigator.pop(context);
      } else {
        if (context.mounted) {
          showSnackBar(context, res);
        }
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }
}

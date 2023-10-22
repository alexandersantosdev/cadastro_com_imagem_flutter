import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cadastro_hive/model/person_model.dart';
import 'package:cadastro_hive/repositories/people_repository.dart';
import 'package:cadastro_hive/shared/text_field.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({super.key});

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  late PeopleRepository peopleRepository;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  List<PersonModel> people = [];
  XFile? photo;

  @override
  void initState() {
    isLoading = true;
    super.initState();
    loadData();
  }

  void loadData() async {
    peopleRepository = await PeopleRepository.load();
    setState(() => people = peopleRepository.getPeople());
    isLoading = false;
  }

  getPersonTile() {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: people.length,
            itemBuilder: (context, index) {
              return Dismissible(
                background: Container(color: Colors.red),
                key: Key(index.toString()),
                confirmDismiss: (direction) {
                  return showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Remover cadastro?'),
                          actions: [
                            TextButton(
                              child: const Text('Cancelar'),
                              onPressed: () => Navigator.pop(context),
                            ),
                            TextButton(
                                child: const Text('Deletar'),
                                onPressed: () {
                                  isLoading = true;
                                  peopleRepository.delete(index);
                                  setState(() =>
                                      people = peopleRepository.getPeople());
                                  Navigator.pop(context);
                                  isLoading = false;
                                })
                          ],
                        );
                      });
                },
                child: ListTile(
                  leading: Image.file(
                    File(people[index].image),
                    width: 50,
                  ),
                  title: Text(people[index].name),
                  subtitle: Text(people[index].email),
                ),
              );
            });
  }

  getPhoto(context, type) async {
    final ImagePicker picker = ImagePicker();

    ImageSource src =
        type == "camera" ? ImageSource.camera : ImageSource.gallery;
    photo = await picker.pickImage(source: src);
    if (photo != null) {
      XFile cropped = await cropImage(photo!);
      await GallerySaver.saveImage(cropped.path);
    }
    setState(() {});
    Navigator.pop(context);
  }

  Future<void> dialogBuilder(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Nova pessoa"),
            content: Wrap(children: [
              getTextField(nameController, "Nome", false, null, null, null),
              getTextField(emailController, "email", false, null, null, null),
              TextButton(
                onPressed: () async {
                  showModalBottomSheet(
                      context: context,
                      builder: (_) {
                        return Wrap(
                          children: [
                            ListTile(
                              title: const Text("Camera"),
                              onTap: () => getPhoto(context, "camera"),
                              leading: const Icon(Icons.camera_alt),
                            ),
                            ListTile(
                              title: const Text("Galeria"),
                              onTap: () => getPhoto(context, "gallery"),
                              leading: const Icon(Icons.photo),
                            ),
                          ],
                        );
                      });
                },
                child: Row(children: [
                  photo != null
                      ? Image.file(
                          File(photo!.path),
                          width: 100,
                        )
                      : const Text("Escolher foto"),
                ]),
              ),
            ]),
            actions: <Widget>[
              !isLoading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: Theme.of(context).textTheme.labelLarge,
                          ),
                          child: const Text('Fechar'),
                          onPressed: () =>
                              Navigator.of(context, rootNavigator: true).pop(),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(
                              const Size(double.infinity, 60),
                            ),
                            textStyle:
                                MaterialStateProperty.all(const TextStyle(
                              fontSize: 20,
                            )),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          onPressed: () {
                            isLoading = true;
                            PersonModel model = PersonModel(nameController.text,
                                emailController.text, photo!.path);
                            peopleRepository.save(model);
                            nameController.text = "";
                            emailController.text = "";
                            photo = null;

                            setState(
                                () => people = peopleRepository.getPeople());
                            isLoading = false;
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: const Text("Salvar"),
                        ),
                      ],
                    )
                  : const Center(child: CircularProgressIndicator()),
            ],
          );
        });
  }

  Future cropImage(XFile imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        )
      ],
    );
    return croppedFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastro de pessoas"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  await dialogBuilder(context);
                },
                child: const Text("Novo Cadastro"),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: getPersonTile(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

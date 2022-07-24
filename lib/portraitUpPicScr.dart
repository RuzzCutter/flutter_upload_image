import 'dart:io';
import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class UploadPictureScreenPortrait extends StatefulWidget {

  const UploadPictureScreenPortrait({
    Key? key,
  }) : super(key: key);

  @override
  _UploadPictureScreenPortrait createState() => _UploadPictureScreenPortrait();
}

class _UploadPictureScreenPortrait extends State<UploadPictureScreenPortrait> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  File fileImage = File("zz"); //изображение в мобильной версии
  Uint8List webImage = Uint8List(10); //изображение в веб версии
  bool imageAvailable = false; //флаг успешной загрузки
  late String imageName = (""); //хранит имя загруженного изображения

  uploadImage() async {
    var permissionStatus = requestPermissions();
    if (!kIsWeb && await permissionStatus.isGranted) {
      final ImagePicker pickedfile = ImagePicker();
      XFile? image = await pickedfile.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          fileImage = selected;
          imageName = image.name;
          imageAvailable = true;
        });
      } else {
        showToast("Файл не выбран");
      }
    }
    else if (kIsWeb) {
      final ImagePicker pickedfile = ImagePicker();
      XFile? image = await pickedfile.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var tempImg = await image.readAsBytes();
        setState(() {
          fileImage = File("a");
          webImage = tempImg;
          imageName = image.name;
          imageAvailable = true;
        });
      } else {
        showToast("Файл не выбран");
      }
    } else {
      showToast("Нет доступа");
    }
  }

  Future<PermissionStatus> requestPermissions() async {
    await Permission.photos.request();
    return Permission.photos.status;
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //лого в левом верхнем углу
                        const Image(
                          width: 148, height: 42,
                          image: AssetImage('resources/images/logo.jpg'),
                        ),
                        //кнопка скачать в правом верхнем углу
                        TextButton(
                          style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all<Size>(const Size(138, 42)),
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                              shape:MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
                          child: RichText(
                              text: const TextSpan(
                                  children: [
                                    WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Icon(Icons.file_download_outlined, color: Colors.white)),
                                    TextSpan(text: "Скачать", style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Lato', fontWeight: FontWeight.w400))])
                          ),
                          onPressed: (){},
                        ),
                      ]),
                ),
                //кнопка загрузки, загруженное изображение
                Expanded(
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Container(
                        color: Colors.white,
                        //если изображение загружено, то вставляется в виджет, иначе создаётся пустой контейнер
                        child: imageAvailable ? ClipRRect(borderRadius: BorderRadius.circular(6),
                            child: (kIsWeb) ? Image.memory(webImage) : Image.file(fileImage)) : Container(),
                      ),
                      //детектор нажатия
                      GestureDetector(
                        onTap: () async {
                          uploadImage();//загрузка данных
                        },
                        //кнопка загрузки рисуется если флаг видимости true, иначе пустой контейнер
                        child: !imageAvailable ? DottedBorder(color: Colors.blue, borderType: BorderType.RRect,
                            radius: const Radius.circular(10), strokeWidth: 4, dashPattern: const [6, 6], padding: const EdgeInsets.all(6), child: Container(
                              height: 100,
                              width: 100,
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Icon(size: 50, color: Colors.blue, Icons.cloud_upload_rounded),
                                  Text(style: TextStyle(color: Colors.blue, fontSize: 20, fontFamily: 'Lato', fontWeight: FontWeight.w500), 'Выберите\n    файл'),
                                ],
                              ),
                            )) : Container(),
                      )
                    ],
                  ),
                ),
                //название загруженного файла
                Container(padding: const EdgeInsets.fromLTRB(0, 10, 0, 22), child: imageAvailable ? Text(imageName, style: const TextStyle(color: Color(0xFF484848), fontSize: 14, fontFamily: 'Lato', fontWeight: FontWeight.w500)) : Container(height: 16)),
                //виджеты "присоединяйтесь к нам"
                Container(
                  height: 191,
                  width: double.infinity,
                  color: const Color(0xFFF7F9FB),
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text("Присоединяйтесь к нам! Скачайте мобильную\nверсию или версию для компьютера.", style: TextStyle(color: Color(0xFF484848), fontSize: 14, fontFamily: 'Lato', fontWeight: FontWeight.w400)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(borderRadius: BorderRadius.circular(6), child: GestureDetector(onTap: () => (){}, child: Image.asset(width: 150, 'resources/images/playmarket.png'))),
                          const SizedBox(width: 15),
                          ClipRRect(borderRadius: BorderRadius.circular(6), child: GestureDetector(onTap: () => (){}, child: Image.asset(width: 150, 'resources/images/appstore.png'))),
                        ],
                      ),
                      ClipRRect(borderRadius: BorderRadius.circular(10), child: GestureDetector(onTap: () => (){}, child: Container(alignment: Alignment.center, height: 46, width: double.infinity, color: const Color(0xFF233C51), child: Text(style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Lato', fontWeight: FontWeight.w400),'Перейти на сайт')))),
                    ],),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'dart:io';
import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';

class UploadPictureScreen extends StatefulWidget {

  const UploadPictureScreen({
    Key? key,
  }) : super(key: key);

  @override
  _UploadPictureScreen createState() => _UploadPictureScreen();
}

class _UploadPictureScreen extends State<UploadPictureScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  File fileImage = File("zz"); //изображение
  Uint8List webImage = Uint8List(10); //изображение в веб версии
  bool imageAvailable = false; //флаг успешной загрузки
  late String imageName = (""); //хранит имя загруженного изображения

  uploadImage() async {
    if (kIsWeb) {
      final ImagePicker pickedfile = ImagePicker();
      XFile? image = await pickedfile.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var tempImg = await image.readAsBytes();
        setState(() {
          //fileImage = File("a");
          webImage = tempImg;
          imageName = image.name;
          imageAvailable = true;
        });
      } else {
        showToast("Файл не выбран");
      }
    } else {
      FilePickerResult? pickedfile = await FilePicker.platform.pickFiles(type: FileType.image);
      if (pickedfile != null) {
        setState(() {
          fileImage = File(pickedfile.files.single.path!);
          imageName = fileImage.path.split('\\').last;
          imageAvailable = true;
        });
      } else {
        showToast("Файл не выбран");
      }
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
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFD1D6DA),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          width: 1280,
          height: 867,
          margin: (_size.height > 600) ? const EdgeInsets.fromLTRB(80, 30, 80, 22) : const EdgeInsets.fromLTRB(40, 20, 40, 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(30),
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
                                  TextSpan(text: "Скачать", style: TextStyle(color: Colors.white, fontSize: 17, fontFamily: 'Lato', fontWeight: FontWeight.w600))])
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
                            height: 200,
                            width: 200,
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Icon(size: 100, color: Colors.blue, Icons.cloud_upload_rounded),
                                Text(style: TextStyle(color: Colors.blue, fontSize: 20, fontFamily: 'Lato', fontWeight: FontWeight.w500), 'Выберите файл'),
                              ],
                            ),
                          )) : Container(),
                    )
                  ],
                ),
              ),
              //название загруженного файла
              Container(padding: (_size.height > 600) ? const EdgeInsets.fromLTRB(0, 20, 0, 30) : const EdgeInsets.fromLTRB(0, 10, 0, 10), child: imageAvailable ? Text(imageName, style: const TextStyle(color: Color(0xFF484848), fontSize: 14, fontFamily: 'Lato', fontWeight: FontWeight.w500)) : Container(height: 16)),
              //виджеты "присоединяйтесь к нам"
              Container(
                width: 1280,
                height: 162,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.zero, topRight: Radius.zero,bottomLeft: Radius.circular(20.0),bottomRight: Radius.circular(20.0)),
                  color: Color(0xFFF7F9FB),
                ),
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(style: TextStyle(color: Color(0xFF484848), fontSize: 17, fontFamily: 'Lato', fontWeight: FontWeight.w400), "Присоединяйтесь к нам!\nСкачайте мобильную или десктоп версию приложения."),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ClipRRect(borderRadius: BorderRadius.circular(6), child: GestureDetector(onTap: () => (){}, child: Image.asset(height: 42, 'resources/images/playmarket.png'))),
                              const SizedBox(width: 20),
                              ClipRRect(borderRadius: BorderRadius.circular(6), child: GestureDetector(onTap: () => (){}, child: Image.asset(height: 42, 'resources/images/appstore.png'))),
                            ],
                          ),
                          ClipRRect(borderRadius: BorderRadius.circular(10), child: GestureDetector(onTap: () => (){}, child: Container(alignment: Alignment.center, height: 42, width: 181, color: const Color(0xFF233C51), child: Text(style: TextStyle(color: Colors.white, fontSize: 17, fontFamily: 'Lato', fontWeight: FontWeight.w600),'Перейти на сайт')))),
                        ]),],),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
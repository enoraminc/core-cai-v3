# Core CAI V3

**Requirement**

1. Flutter >=3.3.0
2. Dart >=2.18.0
3. Flutter Bloc >=8.0.0
4. Firebase
5. Easy Dynamic Theme

## How to use this package:
### add core_cai_v3 library in pubspec.yaml
> https://github.com/enoraminc/core-cai-v3/tree/master/core_cai_v3

```dart
dependencies:
  flutter:
    sdk: flutter

  core_cai_v3:
    path: ../core-cai-v3/core_cai_v3
```

### Create Themes Style
> Example : https://github.com/enoraminc/core-cai-v3/blob/master/core_cai_v3/example/lib/core/utils/themes.dart

### Create Chat Message Api Implementation
> Example : https://github.com/enoraminc/core-cai-v3/blob/master/core_cai_v3/example/lib/core/blocs/api_impl/chat_message_api_impl.dart

```dart
import 'package:core_cai_v3/api/chat_message_api.dart';
import 'package:core_cai_v3/model/chat_message.dart';


class ChatMessageApiImpl extends ChatMessageApi {
   final grainCollection = FirebaseFirestore.instance.collection("grains")

  @override
  Stream<List<ChatMessage>> getChatMessages(String id) {
     final collection = grainCollection
         .doc(id)
         .collection("message")
         .orderBy('createdAt', descending: true)
     return collection.snapshots().map((event) =>
         event.docs.map((e) => ChatMessage.fromMap(e.data())).toList());
  }

  @override
  Future<bool> createMesage(String contentId, ChatMessage message) async {
    try {
       final collection = grainCollection.doc(contentId).collection("message");
       await collection.doc(message.createdAt.toString()).set(message.toMap());
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }
}

```

### Create Upload Media Api Implementation
> Example : https://github.com/enoraminc/core-cai-v3/blob/master/core_cai_v3/example/lib/core/blocs/api_impl/upload_media_api_impl.dart

```dart
import 'dart:convert';
import 'dart:typed_data';

// import 'package:firebase/firebase.dart' as fb;
import 'package:core_cai_v3/api/upload_media_api.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:http/http.dart' as http;

class UploadMediaApiImpl extends UploadMediaApi {
  @override
  Future<String> uploadFile(Uint8List bytes, String fileType, String extension,
      {String? fileName}) async {
    String dateTime = DateTime.now().microsecondsSinceEpoch.toString();
    String newFileName = dateTime + "." + extension;
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('taskFiles/$dateTime/$fileName');
    firebase_storage.UploadTask task = ref.putData(bytes);
    String downloadUrl =
        await (await task.whenComplete(() => null)).ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  Future<String> uploadImage(
      Uint8List bytes, String fileType, String extension) async {
    String dateTime = DateTime.now().microsecondsSinceEpoch.toString();
    String newFileName = dateTime + "." + extension;
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('taskImages/$newFileName');
    firebase_storage.UploadTask task = ref.putData(bytes);
    String downloadUrl =
        await (await task.whenComplete(() => null)).ref.getDownloadURL();

    print('downloadUrl $downloadUrl');
    return downloadUrl;
  }

  @override
  Future<Uint8List> getVideoTumbnail(String videoUrl) async {
    String input = '{"videoUrl" : "$videoUrl"}';
    String url =
        "https://video-thumbnail-generator-pub.herokuapp.com/generate/thumbnail";
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {"Content-type": "application/json"},
        body: input,
      );
      if (response.statusCode == 200) {
        var data = response.body;
        return base64Decode(data);
      } else {
        throw 'Could not fetch data from api | Error Code: ${response.statusCode}';
      }
    } on Exception catch (e) {
      throw "Error : $e";
    }
  }
}


```

### Create Main & Sidebar Bloc
> Example Main Bloc: https://github.com/enoraminc/core-cai-v3/tree/master/core_cai_v3/example/lib/core/blocs/main_screen


> Example Sidebar Bloc: https://github.com/enoraminc/core-cai-v3/tree/master/core_cai_v3/example/lib/core/blocs/sidebar


### Create main.dart
```dart
import 'package:flutter/material.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';

import 'my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    EasyDynamicThemeWidget(
      initialThemeMode: ThemeMode.dark,
      child: const MyApp(),
    ),
  );
}
```


### Create my_app.dart
```dart

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SidebarBloc>(create: (_) => SidebarBloc()),
        BlocProvider<MainScreenBloc>(create: (_) => MainScreenBloc()),
        BlocProvider<ChatMessageBloc>(
          create: (_) => ChatMessageBloc(
            ChatMessageApiImpl(),
            UploadMediaApiImpl(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Core CAI Boilerplate",
        theme: DynamicTheme.lightTheme(),
        darkTheme: DynamicTheme.darkTheme(),
        themeMode: EasyDynamicTheme.of(context).themeMode,

        // Just for Example, use Route for Production Project
        home: const HomeScreen(),
      ),
    );
  }
}

```

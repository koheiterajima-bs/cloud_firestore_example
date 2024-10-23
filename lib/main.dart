import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // Flutterアプリケーションが実行される前にウィジェットバインディングを初期化
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Firebaseの初期化に失敗しました: $e");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firestore-example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyFirestorePage(),
    );
  }
}

class MyFirestorePage extends StatefulWidget {
  @override
  _MyFirestorePageState createState() => _MyFirestorePageState();
}

class _MyFirestorePageState extends State<MyFirestorePage> {
  // 作成したドキュメント一覧
  List<DocumentSnapshot> documentList = [];

  // 指定したドキュメントの情報
  String orderDocumentInfo = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Firebase操作'),
            const SizedBox(height: 10),
            ElevatedButton(
                child: Text('コレクション+ドキュメント作成'),
                onPressed: () async {
                  print('ボタンが押されました');
                  // ドキュメント作成
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc('id_abc')
                      .collection('orders')
                      .doc('id_123')
                      .set({'price': 600, 'date': '9/13'});
                }),
            const SizedBox(height: 10),
            ElevatedButton(
                child: Text('ドキュメント一覧取得'),
                onPressed: () async {
                  // コレクション内のドキュメント一覧を取得
                  final snapshot = await FirebaseFirestore.instance
                      .collection('users')
                      .get();
                  // 取得したドキュメント一覧をUIに反映
                  setState(() {
                    documentList = snapshot.docs;
                  });
                }),
            // コレクション内のドキュメント一覧を表示
            Column(
              children: documentList.map((document) {
                return ListTile(
                  title: Text('${document['name']}さん'),
                  subtitle: Text('${document['age']}歳'),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: Text('ドキュメントを指定して取得'),
              onPressed: () async {
                // コレクションIDとドキュメントIDを指定して取得
                final document = await FirebaseFirestore.instance
                    .collection('users')
                    .doc('id_abc')
                    .collection('orders')
                    .doc('id_123')
                    .get();
                // 取得したドキュメントの情報をUIに反映
                setState(() {
                  orderDocumentInfo =
                      '${document['date']} ${document['price']}円';
                });
              },
            ),
            // ドキュメントの情報を表示
            ListTile(title: Text(orderDocumentInfo)),
            const SizedBox(height: 10),
            ElevatedButton(
              child: Text('ドキュメント更新'),
              onPressed: () async {
                // ドキュメント更新
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc('id_abc')
                    .update({'age': 100});
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: Text('ドキュメント削除'),
              onPressed: () async {
                // ドキュメント削除
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc('id_abc')
                    .collection('orders')
                    .doc('id_123')
                    .delete();
              },
            ),
          ],
        ),
      ),
    );
  }
}

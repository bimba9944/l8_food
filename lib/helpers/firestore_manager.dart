import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreManager {
  static FirestoreManager? _instance;
  FirebaseFirestore? _firebaseFirestore;

  static FirestoreManager get instance {
    _instance ??= FirestoreManager();
    return _instance!;
  }

  FirebaseFirestore get firebaseStore {
    _firebaseFirestore ??= FirebaseFirestore.instance;
    return _firebaseFirestore!;
  }

  String _getFullPath(String collectionPath) {
    return collectionPath;
  }

  String _getDocPath(String docPath){
    return docPath;
  }

  Stream getCollectionStream({required String collectionPath, Function? queryBuilder}) {
    Stream stream;
    String fullPath = _getFullPath(collectionPath);
    CollectionReference<Map<String, dynamic>> collection = instance.firebaseStore.collection(fullPath);
    if (queryBuilder != null) {
      Query query = queryBuilder(collection);
      stream = query.snapshots();
    } else {
      stream = collection.snapshots();
    }
    return stream;
  }

  Stream getDocumentStream({required String collectionPath, Function? queryBuilder,required String docPath}) {
    Stream stream;
    String fullPath = _getFullPath(collectionPath);
    String documentPath = _getDocPath(docPath);
    DocumentReference<Map<String, dynamic>> collection = instance.firebaseStore.collection(fullPath).doc(documentPath);
    if (queryBuilder != null) {
      Query query = queryBuilder(collection);
      stream = query.snapshots();
    } else {
      stream = collection.snapshots();
    }
    return stream;
  }

  void addNewDocumentItem({required String collectionPath, required dynamic item,required String docName}) async {
    String fullPath = _getFullPath(collectionPath);
    return await instance.firebaseStore.collection(fullPath).doc(docName).set(item,SetOptions(merge: true));
  }

  Future<dynamic> updateCollectionItem(
      {required String collectionPath, required String documentId, required dynamic item}) async {
    String fullPath = _getFullPath(collectionPath);
    return await instance.firebaseStore.collection(fullPath).doc(documentId).update(item);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String name;

  CategoryModel({required this.id,required this.name});

  factory CategoryModel.fromFireStore(DocumentSnapshot doc){
    Map data = doc.data() as Map;
    return CategoryModel(id: doc.id, name: data['name'] ?? '');
  }
}
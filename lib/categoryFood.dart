import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsi_tpm_123200103/listFood.dart';

class Category {
  final String strCategory;
  final String strCategoryThumb;

  Category({required this.strCategory, required this.strCategoryThumb});
}

class CategoryFood extends StatefulWidget {
  @override
  State<CategoryFood> createState() => _CategoryFoodState();
}

class _CategoryFoodState extends State<CategoryFood> {
  late Future<List<Category>> categories;
  String? text;

  @override
  void initState(){
    super.initState();
    categories = fetchCategories();
  }

  Future<List<Category>> fetchCategories() async{
    final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final categoryList = data['categories'] as List;

      return categoryList.map((category) {
        return Category(
          strCategory: category['strCategory'],
          strCategoryThumb: category['strCategoryThumb'],
        );
      }).toList();
    } else {
      throw Exception('Failed to fetch categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Categories'),
      ),
      body: FutureBuilder<List<Category>>(
        future: categories,
        builder: (context, snapshot){
          if (snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context,index){
                final category = snapshot.data![index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context){
                      return ListFood(text: category.strCategory);
                    }));
                  },
                  child: Card(
                      elevation: 4,
                      child: ListTile(
                        leading: Image.network(category.strCategoryThumb),
                        title: Text(category.strCategory),
                      )
                  ),
                );
              },
            );
          }else if (snapshot.hasError){
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

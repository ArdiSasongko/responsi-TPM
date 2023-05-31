import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'API/load_data_source.dart';
import 'detailFood.dart';
import 'model/foodModel.dart';

class ListFood extends StatefulWidget {
  final String text;
  const ListFood({Key? key, required this.text}) : super(key: key);

  @override
  State<ListFood> createState() => _ListFoodState();
}

class _ListFoodState extends State<ListFood> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Foods')
      ),
      body: Container(
        child: FutureBuilder(
          future: MealSource.instance.loadMeal(widget.text),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError || widget.text.isEmpty) {
              return _buildErrorSection();
            }
            if (snapshot.hasData) {
              Makanan maem = Makanan.fromJson(snapshot.data);
              return _buildSuccessSection(maem);
            }
            return _buildLoadingSection();
          },
        )
      ),
    );
  }

  Widget _buildLoadingSection() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorSection() {
    if (widget.text.isEmpty) {
      return const Text("");
    } else {
      return const Text("Error");
    }
  }

  // Jika data ada
  Widget _buildSuccessSection(Makanan data) {
    return ListView.builder(
      itemCount: data.meals?.length,
      itemBuilder: (BuildContext context, int index) {
        final maem = data.meals![index];
        return Padding(
          padding:
          EdgeInsets.all(8.0), // Tambahkan padding di sini sesuai kebutuhan
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FoodDetailPage(foodId: maem.idMeal!),
                ),
              );
            },
            leading: Image.network(maem.strMealThumb as String),
            title: Text(maem.strMeal as String),
          ),
        );
      },
    );
  }
}

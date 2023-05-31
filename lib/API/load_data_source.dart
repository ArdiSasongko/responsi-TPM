
import 'package:responsi_tpm_123200103/API/base_network.dart';

class MealSource {
  static MealSource instance = MealSource();
  Future<Map<String, dynamic>> loadMeal(String text){
    return BaseNetwork.get(text);
  }
}
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../app/utils/const/string_const.dart';
import '../../model/cinema/cinema_model.dart';

abstract class CinemaLocalDataSource {
  Future<List<CinemaModel>> getCinemas();
}

class CinemaLocalDataSourceImpl implements CinemaLocalDataSource {
  @override
  Future<List<CinemaModel>> getCinemas() async {
    try {
      final jsonString = await rootBundle.loadString(StringConst.mockDataPath);
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList
          .map((item) => CinemaModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Gagal membaca data bioskop: $e');
    }
  }
}

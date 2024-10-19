import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<dynamic>> getAllPosts() async {
    final allProductsUrl = Uri.parse('https://fakestoreapi.com/products');
    final result = await http.get(allProductsUrl);

    if (result.statusCode == 200) {
      return json.decode(result.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Map<String, dynamic>> getSingleProduct(int id) async {
    final singleProd = Uri.parse('https://fakestoreapi.com/products/$id');
    final result = await http.get(singleProd);

    if (result.statusCode == 200) {
      return json.decode(result.body);
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<List<dynamic>> getAllCategory() async {
    final allCat = Uri.parse('https://fakestoreapi.com/products/categories');
    final result = await http.get(allCat);

    if (result.statusCode == 200) {
      return json.decode(result.body);
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<dynamic>> getProducts(String cat) async {
    final getProducts =
        Uri.parse('https://fakestoreapi.com/products/category/$cat');
    final result = await http.get(getProducts);

    if (result.statusCode == 200) {
      return json.decode(result.body);
    } else {
      throw Exception('Failed to load products by category');
    }
  }

  Future<Map<String, dynamic>> userLogin(
      String username, String password) async {
    final loginUrl = Uri.parse('https://fakestoreapi.com/auth/login');
    final result = await http
        .post(loginUrl, body: {'username': username, 'password': password});

    if (result.statusCode == 200) {
      print(result.statusCode);
      print(result.body);
      return json.decode(result.body);
    } else {
      throw Exception('Failed to login');
    }
  }
}

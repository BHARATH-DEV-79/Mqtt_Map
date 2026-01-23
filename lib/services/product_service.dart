
import '../model/model.dart';

import '../routes/api_points.dart';
import '../utils/apis/api_service.dart';


// Future<ResponseListProduct> getproduct () async{
//   await Future.delayed(const Duration(seconds: 1));
//   return ResponseListProduct.fromJson(fakeOrderApiResponse);
// }
Future<ResponseListProduct> getproduct() async {
  try {
    return await ApiService.get(
      path: ApiEndPoints.productList,
      fromJson: (json) => ResponseListProduct.fromJson(json),
    );
  } catch (e) {
    print(' getproduct error: $e');
    rethrow; 
  }
}
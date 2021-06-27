// import 'package:app/app/data/models/products_by_category_response.dart';
// import 'package:app/app/utils/helper/echo.dart';
// import 'package:app/app/utils/translations/strings.dart';
// import 'package:get/get.dart';

// import 'database_helper.dart';

// class CartDatabaseCRUD {
//   final _dbHelper = DatabaseHelper.instance;

//   Future<String> insert(CategoryProduct categoryProduct) async {
//     Map<String, dynamic> row = {
//       DatabaseHelper.columnProductId: categoryProduct.id,
//       DatabaseHelper.columnNameEn: categoryProduct.nameEn,
//       DatabaseHelper.columnNameAr: categoryProduct.nameAr,
//       DatabaseHelper.columnImage: categoryProduct.image == null ? 'e' : categoryProduct.image,
//       DatabaseHelper.columnPrice: categoryProduct.price,
//       DatabaseHelper.columnFragmentation: categoryProduct.fragmentation == null?0: categoryProduct.fragmentation,
//       DatabaseHelper.columnNewPrice: categoryProduct.newPrice,
//       DatabaseHelper.columnQty: categoryProduct.fragmentation != null && categoryProduct.fragmentation == 1 ? 0.250 : 1,
//       DatabaseHelper.columnShopId: categoryProduct.shopId,
//     };
// //    check if already exist
//     CategoryProduct product = await getProduct(categoryProduct.id);
//     if (product != null) return 'already in cart';

//     //check if product not same shop-id
//     CategoryProduct firstProduct = await getFirstProduct();
//     if (firstProduct != null) if (firstProduct.shopId != categoryProduct.shopId) {
//       Echo('shopId ${firstProduct.shopId} ${categoryProduct.shopId}');
//       Get.snackbar(Strings().notification, Strings().cantAddProductFromOtherShop);
//       return ' String cantAddProductFromOtherShop';
//     }

//     await _dbHelper.insert(row);
//     return 'success';
//   }

//   Future<List<CategoryProduct>> getCartItems() async {
//     List<CategoryProduct> list = [];
//     final allRows = await _dbHelper.queryAllRows();
//     allRows.forEach((row) {
//       list.add(CategoryProduct(
//         id: row[DatabaseHelper.columnProductId],
//         nameEn: row[DatabaseHelper.columnNameEn],
//         nameAr: row[DatabaseHelper.columnNameAr],
//         image: row[DatabaseHelper.columnImage],
//         price: row[DatabaseHelper.columnPrice],
//         newPrice: row[DatabaseHelper.columnNewPrice],
//         qty: row[DatabaseHelper.columnQty],
//         shopId: row[DatabaseHelper.columnShopId],
//         fragmentation: 1,
//         available: 1,
//       ));
//     });

//     list.forEach((element) {
//       if(element.qty <=0){
//         removeProduct(element.id);
//       list.remove(element);
//       }
//     });

//     return list;
//   }

//   Future<CategoryProduct> getProduct(int id) async {
//     final allRows = await _dbHelper.select(id);
//     CategoryProduct categoryProduct;
//     if (allRows != null && allRows.length > 0)
//       categoryProduct = CategoryProduct(
//         id: allRows[0][DatabaseHelper.columnProductId],
//         nameEn: allRows[0][DatabaseHelper.columnNameEn],
//         nameAr: allRows[0][DatabaseHelper.columnNameAr],
//         image: allRows[0][DatabaseHelper.columnImage],
//         price: allRows[0][DatabaseHelper.columnPrice],
//         newPrice: allRows[0][DatabaseHelper.columnNewPrice],
//         qty: allRows[0][DatabaseHelper.columnQty],
//         fragmentation: allRows[0][DatabaseHelper.columnFragmentation],
//         available: 1,
//       );
//     return categoryProduct;
//   }

//   Future<CategoryProduct> getFirstProduct() async {
//     final allRows = await _dbHelper.firstProduct();
//     CategoryProduct categoryProduct;
//     if (allRows != null && allRows.length > 0)
//       categoryProduct = CategoryProduct(
//         id: allRows[0][DatabaseHelper.columnProductId],
//         nameEn: allRows[0][DatabaseHelper.columnNameEn],
//         nameAr: allRows[0][DatabaseHelper.columnNameAr],
//         image: allRows[0][DatabaseHelper.columnImage],
//         price: allRows[0][DatabaseHelper.columnPrice],
//         newPrice: allRows[0][DatabaseHelper.columnNewPrice],
//         qty: allRows[0][DatabaseHelper.columnQty],
//         shopId: allRows[0][DatabaseHelper.columnShopId],
//         fragmentation: allRows[0][DatabaseHelper.columnFragmentation],
//         available: 1,
//       );
//     return categoryProduct;
//   }

//   Future<double> updateProductQty(int id, {bool addQty = true}) async {
//     CategoryProduct product = await getProduct(id);
//     double increaseQty = product.fragmentation != null && product.fragmentation == 1 ? 0.250 : 1.0;
//     double qty = addQty ? product.qty + increaseQty : product.qty - increaseQty;
//     if (qty == 0) {
//       await _dbHelper.removeByProductId(id);
//     } else {
//       Map<String, dynamic> row = {
//         DatabaseHelper.columnProductId: id,
//         DatabaseHelper.columnQty: qty,
//       };
//       await _dbHelper.update(row);
//     }
//     Echo('QTy $qty');

//     return qty;
//   }

//   Future<bool> removeProduct(int id) async {
//     await _dbHelper.removeByProductId(id);
//     return true;
//   }

//   Future<void> deleteAll() async {
//     await _dbHelper.delete(0);
//   }
// }

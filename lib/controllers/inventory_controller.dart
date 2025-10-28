import 'package:get/get.dart';
import 'package:mistpos/models/supplier_model.dart';
import 'package:mistpos/services/network_wrapper.dart';
import 'package:mistpos/utils/toast.dart';

class InventoryController extends GetxController {
  RxList<SupplierModel> suppliers = RxList<SupplierModel>();
  Future<bool> addSupplier(Map<String, dynamic> data) async {
    final result = await Net.post("/admin/supplier", data: data);
    if (result.hasError) {
      Toaster.showError(result.response);
      return false;
    }
    loadSuppliers();
    return true;
  }

  Rx<SupplierModel?> selectedSupplier = Rx<SupplierModel?>(null);
  RxBool suppliersLoading = RxBool(false);
  RxInt supplierPage = RxInt(1);
  RxInt supplierTotalPages = RxInt(2);
  void loadSuppliers({String search = '', int page = 1}) async {
    if (suppliersLoading.value) return;
    suppliersLoading.value = true;
    final result = await Net.get("/admin/suppliers?search=$search&page=$page");
    if (result.hasError) {
      suppliersLoading.value = false;
      return;
    }
    supplierPage.value = result.body['currentPage'] ?? 1;
    supplierTotalPages.value = result.body['totalPages'] ?? 0;
    if (result.body['list'] != null) {
      List<dynamic> usersList = result.body['list'];
      suppliers.assignAll(
        usersList.map((e) => SupplierModel.fromJson(e)).toList(),
      );
    }
    suppliersLoading.value = false;
  }
}

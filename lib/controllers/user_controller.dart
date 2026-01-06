import 'package:get/get.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/models/user_model.dart';
import 'package:mistpos/models/token_model.dart';
import 'package:mistpos/services/network_wrapper.dart';
import 'package:mistpos/screens/basic/screen_main.dart';
import 'package:mistpos/services/auth_interceptor.dart';
import 'package:mistpos/screens/auth/screen_splash.dart';

class UserController extends GetxController {
  RxBool loading = RxBool(false);
  Rx<User?> user = Rx<User?>(null);
  @override
  void onInit() {
    super.onInit();
    user.value = User.fromStorage();
    if (user.value == null) {
      return;
    }
    validateUser();
  }

  void validateUser() async {
    loading.value = true;
    final response = await AuthenticationInterceptor.requestToken();
    loading.value = false;
    if (response.hasError) {
      if (response.statusCode == 401) {
        User.clearStorage();
        TokenModel.fromStorage();
        user.value = null;
      }
      return;
    }
    user.value = User.fromMap(response.body['user']);
    User.saveToStorage(user.value!);
  }

  void registerUser(User userData) async {
    loading.value = true;
    final response = await Net.post("/user/register", data: userData.toMap());
    loading.value = false;
    if (response.hasError) {
      Toaster.showError(response.response);
      return;
    }
    if (response.body['user'] == null) {
      Toaster.showError("Response send an empty response");
      return;
    }
    user.value = User.fromMap(response.body['user']);
    User.saveToStorage(user.value!);
    final token = TokenModel.fromJson(response.body['tokens']);
    token.saveToStorage();
    Get.offAll(() => ScreenMain());
  }

  void loginUser(String email, String password) async {
    loading.value = true;
    final response = await Net.post(
      "/user/login",
      data: {"email": email, "password": password},
    );
    loading.value = false;
    if (response.hasError) {
      Toaster.showError(response.response);
      return;
    }
    if (response.body['user'] == null) {
      Toaster.showError("Response send an empty response");
      return;
    }
    user.value = User.fromMap(response.body['user']);
    User.saveToStorage(user.value!);
    final token = TokenModel.fromJson(response.body['tokens']);
    token.saveToStorage();
    Get.offAll(() => ScreenMain());
  }

  RxList<User> relatedAccounts = RxList<User>();
  RxBool loadingRelatedAccounts = RxBool(false);
  RxString relatedAccountsError = RxString("");
  Future<void> findRelatedAccounts({String searchKey = ''}) async {
    if (user.value == null || loadingRelatedAccounts.value) {
      return;
    }
    loadingRelatedAccounts.value = true;
    relatedAccountsError.value = "";
    final response = await Net.get("/filtered-users?search=$searchKey");
    loadingRelatedAccounts.value = false;
    if (response.hasError) {
      relatedAccountsError.value = response.response;
      return;
    }
    if (response.body['list'] != null) {
      List<dynamic> list = response.body['list'];
      relatedAccounts.value = list.map((e) => User.fromMap(e)).toList();
    }
  }

  RxBool changingPassword = RxBool(false);
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    if (user.value == null) {
      return false;
    }
    changingPassword.value = true;
    final response = await Net.put(
      "/user/change-password",
      data: {"oldPassword": oldPassword, "newPassword": newPassword},
    );
    changingPassword.value = false;
    if (response.hasError) {
      Toaster.showError(response.response);
      return false;
    }
    Toaster.showSuccess("Password changed successfully");
    return true;
  }

  RxBool logingOut = RxBool(false);
  Future<void> logout() async {
    if (user.value == null) {
      return;
    }
    logingOut.value = true;
    final response = await Net.put("/user/logout");
    logingOut.value = false;
    if (response.hasError) {
      Toaster.showError(response.response);
      return;
    }
    Get.offAll(() => ScreenSplash());
    User.clearStorage();
    TokenModel.clearStorage();
    user.value = null;
  }

  RxBool switchingCurrency = RxBool(false);
  void switchCurrency(String key) async {
    if (user.value == null) {
      return;
    }
    switchingCurrency.value = true;
    final response = await Net.put("/user/curreny/$key");
    switchingCurrency.value = false;
    if (response.hasError) {
      Toaster.showError(response.response);
      return;
    }
    user.value = User.fromMap(response.body['update']);
    User.saveToStorage(user.value!);
    Toaster.showSuccess("Currency switched successfully");
  }

  RxBool switchingStore = RxBool(false);
  Future<bool> switchStore(String key) async {
    if (user.value == null) {
      return false;
    }
    if (key.trim().isEmpty) {
      Toaster.showError("Store is required");
      return false;
    }
    switchingStore.value = true;
    final response = await Net.put("/user/company/$key");
    switchingStore.value = false;
    if (response.hasError) {
      Toaster.showError(response.response);
      return false;
    }
    user.value = User.fromMap(response.body['update']);
    User.saveToStorage(user.value!);
    Toaster.showSuccess("Currency switched successfully");
    return true;
  }

  Future<({User? user, String error})> getUserById(String senderId) async {
    final response = await Net.get("/user/$senderId");
    if (response.hasError) {
      return (error: response.response, user: null);
    }
    return (error: "", user: User.fromMap(response.body['update']));
  }
}

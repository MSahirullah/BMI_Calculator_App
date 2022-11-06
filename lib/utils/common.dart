import 'package:flutter_easyloading/flutter_easyloading.dart';

void hideLoading(timer) async {
  timer?.cancel();
  await EasyLoading.dismiss();
}

void showSuccess(timer, msg) async {
  timer?.cancel();
  await EasyLoading.showSuccess(msg);
}

void showSnackBar(msg) {
  EasyLoading.showToast(msg);
}

import 'package:flutter_easyloading/flutter_easyloading.dart';

void showSuccess(timer, msg) async {
  timer?.cancel();
  await EasyLoading.showSuccess(msg);
}

void showSnackBar(msg) {
  EasyLoading.showToast(msg);
}

void showLoading(timer) async {
  timer?.cancel();
  await EasyLoading.show(
    status: 'loading...',
    maskType: EasyLoadingMaskType.black,
  );
}

void hideLoading(timer) async {
  timer?.cancel();
  await EasyLoading.dismiss();
}

void dismissSnackBar() async {
  await EasyLoading.dismiss();
}


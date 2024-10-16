import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordProcess {
  String pass;
  String repass;
  bool notValidPass = true;
  PasswordProcess(this.pass, this.repass, this.notValidPass);
}

class ChangePasswordNotifier extends StateNotifier<PasswordProcess> {
  ChangePasswordNotifier() : super(PasswordProcess("", "", false));

  String? validate(String? value) {
    String pattern = r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,16}$";
    final regex = RegExp(pattern);
    if (value!.isNotEmpty && !regex.hasMatch(value)) {
      state.notValidPass = true;
      return 'Şifreniz minimum 8 maximum 16 karakter olabilir\nEn az bir harf ve bir rakam içermelidir';
    } else {
      state.notValidPass = false;
      return null;
    }
  }

  statePass(pass) {
    state.pass = pass;
  }

  stateRepass(repass) {
    state.repass = repass;
  }

  doCheck() {
    return state.pass.isNotEmpty && state.repass.isNotEmpty
        ? state.notValidPass
            ? "notvalid"
            : state.pass == state.repass
                ? true
                : false
        : "empty";
  }
}

final changePasswordProvider =
    StateNotifierProvider((ref) => ChangePasswordNotifier());

String validateName(String value) {
  if (value.isEmpty) {
    return "Nama tidak boleh kosong";
  } else if (value.length < 6) {
    return "Nama harus lebih dari 6 huruf";
  } else {
    return null;
  }
}

String validatePassword(String value) {
  if (value.isEmpty) {
    return "Password tidak boleh kosong";
  } else if (value.length < 6) {
    return "Password harus lebih dari 6 huruf";
  } else {
    return null;
  }
}

String validateEmail(String value) {
  Pattern pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  RegExp regex = new RegExp(pattern);
  if(value.isEmpty) {
    return "Email tidak boleh kosong";
  } else if (!regex.hasMatch(value)) {
    return "Masukkan Email dengan benar";
  } else {
    return null;
  }
}

String validatePasswordRegister(String value, String confirmation) {
  if (value.isEmpty) {
    return "Password tidak boleh kosong";
  } else if (value.length < 6) {
    return "Password harus lebih dari 6 huruf";
  } else if (value != confirmation) {
    return "Password harus sama dengan konfirmasi";
  } else {
    return null;
  }
}

String validateStory(String text) {
  if(text.length > 450) {
    return "Maksimal 450 Karakter";
  } else {
    return null;
  }
}

String validateWriting(String text) {
  final List words = text.split(" ");

  if(words.length < 200) {
    return "Minimal 200 Kata";
  } else if(words.length > 500) {
    return "Minimal 500 Kata";
  } else {
    return null;
  }
}

String trim(String text) {
  return text.replaceAll(new RegExp(r"\s+"), "");
}
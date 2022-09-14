import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sprint/screens/registration_screen.dart';

class Validations {
  String? validate(int decide, String value) {
    //ناقص 0,3,7
    switch (decide) {
      case 0:
        // birth date
        return validateBD(value);
      case 1:
        // Email
        return validateEmail(value);
      case 2:
        // Password
        return validatePassword(value);
      case 3:
        // Name
        return validateName(value);
      case 4:
        // Mobile
        return validateMobile(value);
      case 5:
        // National ID
        return validateNationalID(value);
      case 6:
        // ConfirmPassword
        return validateConPassworde(value);
      case 7:
        // UserName
        return validateUserName(value);

      case 8:
        // UserName
        return validateSimple(value);
      default:
        return null;
    }
  }

  String? validateSimple(String value) {
    if (value.isEmpty || value.trim().isEmpty) {
      return 'لا يمكن ان يكون الحقل فارغا';
    }
    return null;
  }

  String? validateName(String value) {
    RegExp regex = RegExp(r'^.{2,}$');
    if (value.isEmpty || value.trim().isEmpty) {
      return 'الاسم مطلوب';
    }
    if (!regex.hasMatch(value)) {
      return ("يجب ان يحتوي على حرفين على الأقل");
    }
    /*if (!RegExp(r"^[\p{L} ,.'-]*$").hasMatch(
            value) /*||
        !RegExp(r"^[\p{InArabic} ,.'-]*$").hasMatch(value)*/
        ) {
      return ("يجب ان يحتوي الأسم على أحرف فقط");
    }*/
    if (value.length > 10) {
      return ("الأسم المدخل غير صحيح");
    }
    return null;
  }

  /*String? validateName(String value) {
    RegExp regex = RegExp(r'^.{2,}$');
    if (value.isEmpty || value.trim().isEmpty) return 'الاسم مطلوب';
    if (!regex.hasMatch(value)) {
      return ("يجب ان يحتوي على حرفين على الأقل");
    }
    RegExp regex2 = RegExp(r'^[A-Za-z]*(\s[A-Za-z]*)+$');
    if (!regex2.hasMatch(value)) {
      return (" يجب ان يحتوي الأسم على أحرف فقط واسمين على الاقل");
    }
    if (value.length > 30) {
      return ("الأسم المدخل غير صحيح");
    }
    return null;
  }*/

  String? validateEmail(String value) {
    if (value.isEmpty || value.trim().isEmpty) {
      return ("الرجاء إدخال بريدك إلكتروني");
    }
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    if (!regex.hasMatch(value)) {
      return 'البريد الإلكتروني غير صحيح';
    } else {
      return null;
    }
  }

  String? validatePassword(String value) {
    RegExp regex = new RegExp(r'^.{8,}$');
    if (value.isEmpty || value.trim().isEmpty) {
      return ("الرجاء تعيين كلمة مرور");
    }

    if (!isPasswordCompliant(value)) {
      return ('الرجاء إدخال كلمة مرور تحتوي على حرف كبير وصغير ورقم');
    } else if (!isPasswordCompliant2(value)) {
      return ('    الرجاء إدخال كلمة مرور تحتوي على ٨ خانات');
    } else
      return null;
  }

  String? validateConPassworde(String value) {
    RegExp regex = new RegExp(r'^.{8,}$');
    if (value.isEmpty || value.trim().isEmpty) {
      return ("الرجاء تعيين كلمة مرور");
    }
    if (!regex.hasMatch(value)) {
      return ("يجب أن تحتوي على 8 رموز او أكثر");
    }
    //if (RegistrationScreen. ) {
    //return "كلمة المرور مختلفة*"; // don't match
    //}

    return null;
  }

  bool isPasswordCompliant(String password, [int minLength = 8]) {
    if (password.isEmpty) {
      return false;
    }

    bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(new RegExp(r'[0-9]'));
    bool hasLowercase = password.contains(new RegExp(r'[a-z]'));
    //bool hasMinLength = password.length > minLength;

    return hasDigits & hasUppercase & hasLowercase;
  }

  bool isPasswordCompliant2(String password, [int minLength = 8]) {
    if (password.length > minLength) {
      return true;
    } else
      return false;
  }

  String? validateBD(String value) {
    //int value2 = value as int;
    RegExp regex = RegExp(r'[0-9]{2}');

    if (value.isEmpty || value.trim().isEmpty) return ("الرجاء اختيار عمرك ");
    /*if (value2 <= 0 && value2 >= 200) {
      return ("العمر المدخل غير صحيح");
    }*/
    if (!regex.hasMatch(value)) {
      return ("العمر المدخل غير صحيح");
    }
    /*if (calculateAge(DateTime.parse(value)) < 16)
      return ("يجب ان يكون عمرك اكبر من 16 سنة"); */
    /* Pattern pattern =
      //  r'((0|1)[0-9]|2[0-9]|3[0-1])\/(0[1-9]|1[0-2])\/((19|20)\d\d))$';
    //RegExp regex = RegExp(pattern.toString());
    //if (!regex.hasMatch(value)) {
    //  return 'الرجاء اخال تاريخ الميلاد "اليوم/الشهر/السنة" بهذة الصبغة';
    } */
    else {
      return null;
    }
  }

  String? validateMobile(String value) {
    RegExp regex = RegExp(r'^((?:[0]+)(?:[5]+)(?:\s?\d{8}))$');
    if (value.isEmpty || value.trim().isEmpty) {
      return ("الرجاء إدخال رقم الجوال ");
    }
    if (!regex.hasMatch(value)) {
      return ("رقم الجوال المدخل غير صحيح");
    }
    if (value.length < 10) {
      return ("رقم الجوال المدخل غير صحيح");
    }
    return null;
  }

  String? validateNationalID(String value) {
    RegExp regex = RegExp(r'[0-9]{10}');
    if (value.isEmpty || value.trim().isEmpty) {
      return 'يجب ادخال رقم هويتك صحيحا';
    } else if (!regex.hasMatch(value)) {
      return 'يجب ان يكون رقم الهويه مكون من 10 ارقام';
    } else {
      return null;
    }
  }

  String? validateUserName(String value) {
    RegExp regex = RegExp(r'^.{2,}$');
    if (value.isEmpty || value.trim().isEmpty) return 'اسم المستخدم مطلوب';
    if (!regex.hasMatch(value)) {
      return ("يجب ان يحتوي على حرفين على الأقل");
    }
    if (value.length > 15) {
      return ("يجب ان يكون اسم المستخدم لا يزيد عن 15 حرف");
    }
    return null;
  }
/*
    bool result = isDuplicateUniqueName(value) as bool;

    //bool result = usernameCheck(value) as bool;
    if (!result) {
      return ("اسم المستخدم موجود الرجاء اختيار غيره");
    }
    return null;
  }

  Future<bool> isDuplicateUniqueName(String uniqueName) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .where('userName', isEqualTo: uniqueName)
        .get();
    return query.docs.isNotEmpty;
  }*/

/*
  Future<String?> validateUserName1(String value) async {
    RegExp regex = RegExp(r'^.{2,}$');
    if (value.isEmpty || value.trim().isEmpty) return 'اسم المستخدم مطلوب';
    if (!regex.hasMatch(value)) {
      return ("يجب ان يحتوي على حرفين على الأقل");
    }
    //if (!RegExp(r"^[\p{L},.'-]*$",caseSensitive: false, unicode: true, dotAll: true).hasMatch(value)) {
    //return ("يجب ان يحتوي الأسم على أحرف فقط");
    //}
    if (value.length > 15) {
      return ("يجب ان يكون اسم المستخدم لا يزيد عن 15 حرف");
    }

    
    bool result = isDuplicateUniqueName(value) as bool;
    
    //bool result = usernameCheck(value) as bool;
    
    if (await isDuplicateUniqueName(value)) {
      return ("اسم المستخدم موجود الرجاء اختيار غيره");
    }
    return null;
  }
Future<bool> isDuplicateUniqueName(String uniqueName) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .where('userName', isEqualTo: uniqueName)
        .get();
    return query.docs.isNotEmpty;
  }
  String? validateUserName(String value) {
    Future<String?> result1 = validateUserName1(value);
    String result = result1 as String;
    return result;
  }
*/
  /*final firestore = FirebaseFirestore.instance;

  Future<bool> usernameCheck(String username) async {
    final result = await FirebaseFirestore.instance
       .collection('users')
        .doc('userName')
        .get();
     /*   .collection('users').get()
.then(querySnapshot => {
   querySnapshot.docs.map(doc => { return <userCred userName={username} /> });
});
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('userName', isEqualTo: username)
        .get();*/
    return result.exists;
  }
*/
  ///////////////////////////////////////////////////////*
  /*int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    if (birthDate.month > currentDate.month) {
      age--;
    } else if (currentDate.month == birthDate.month) {
      if (birthDate.day > currentDate.day) {
        age--;
      }
    }
    return age;
  }*/
}

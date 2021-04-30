import 'package:get/get.dart';
import 'package:pet_and_vet/utils/langs/ar.dart';
import 'package:pet_and_vet/utils/langs/en.dart';



class Translation extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys =>
      {
        'en': en,
        'ar': ar,
      };
}

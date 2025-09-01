import 'package:get/get.dart';

class Authcontroller extends GetxController{
  RxBool ischecked=false.obs;
  RxBool isLoadingpass=false.obs;

  RxBool isLoadingresend=false.obs;
  RxString fromPage="".obs;
}

import 'package:get/get.dart';


class NavController extends GetxController {
  var currentIndex = 0.obs;
  final RxBool showCategoryOverlay = false.obs;
  RxInt highlightedIndex = (-1).obs;
  var selectedCategory = 'Category'.obs;
}


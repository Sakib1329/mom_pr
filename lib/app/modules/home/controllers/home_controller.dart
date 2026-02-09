import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/Get.dart';
import 'package:Nuweli/app/modules/home/models/allcontent_model.dart';
import 'package:Nuweli/app/modules/home/views/details.dart';
import 'package:Nuweli/app/modules/home/views/series_details.dart';

import '../../../res/colors/color.dart';
import '../models/movie_model.dart';
import '../models/movieresponse_model.dart';
import '../models/series_model.dart';
import '../models/seriesresponse_model.dart';
import '../services/home_service.dart';
import 'navcontroller.dart';

class HomeController extends GetxController {
  final HomeService _homeService = Get.find<HomeService>();
  final NavController _navController = Get.find<NavController>();

  var currentIndex = 0.obs;
  RxBool issubscribed = false.obs;
  var selectedSeasonIndex = 0.obs;

  // Search
  var items = <dynamic>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var searchQuery = ''.obs;
  Timer? _debounce;

  // Popular movies and genres for CategoryHome
  var popularItems = <dynamic>[].obs;
  var bannerMovies = <String, List<String>>{}.obs;
  var movieTypes = <String>[].obs;
  var seriesTypes = <String>[].obs;
  var genre = <String>[].obs;

  // Movie Details
  var movieDetails = Rxn<Movie>();
  var isDetailsLoading = false.obs;
  var detailsErrorMessage = ''.obs;

  // Series Details
  var SeriesDetails = Rxn<Series>();
  var isSeriesDetailsLoading = false.obs;
  var SeriesdetailsErrorMessage = ''.obs;

  // Watch Later
  var watchLaterItems = <dynamic>[].obs;
  var isWatchLaterLoading = false.obs;
  var watchLaterErrorMessage = ''.obs;

  // Watch History
  var watchjistoryitems = <dynamic>[].obs;
  var isWatchhistoryLoading = false.obs;
  var watchjistoryErrorMessage = ''.obs;

  // Collections
  var collectionitems = <dynamic>[].obs;
  var iscollectionLoading = false.obs;
  var collectionErrorMessage = ''.obs;

  // Genres
  var isGenresLoading = false.obs;
  var genresErrorMessage = ''.obs;

  // All Content
  var allContentResponse = Rxn<AllContentResponse>();
  var isAllContentLoading = false.obs;
  var allContentErrorMessage = ''.obs;

  // All Movies
  var allMoviesResponse = Rxn<MovieResponse>();
  var isAllMoviesLoading = false.obs;
  var allMoviesErrorMessage = ''.obs;

  // All Series
  var allSeriesResponse = Rxn<SeriesResponse>();
  var isAllSeriesLoading = false.obs;
  var allSeriesErrorMessage = ''.obs;
  // 1. Your observable list
  var continueWatchingItems = <Movie>[].obs;
  var isContinueLoading = false.obs; // Recommended to show a loader if needed

  Future<void> loadContinueWatching() async {
    try {
      isContinueLoading.value = true;

      // Call the service
      AllContentResponse response = await _homeService.getContinueWatching();

      // 2. Update the UI observable
      // We use .assignAll to notify listeners and replace the old list
      continueWatchingItems.assignAll(response.continueWatchingMovies);

      debugPrint("Loaded ${continueWatchingItems.length} continue watching items");
    } catch (e) {
      debugPrint("Error loading continue watching: $e");
    } finally {
      isContinueLoading.value = false;
    }
  }


  @override
  void onInit() {
    super.onInit();
    ever(_navController.selectedCategory, (genreName) {
      if (genreName.isNotEmpty && genreName.toLowerCase() != 'all' && genreName != 'My List') {
        onGenreSelected(genreName);
      } else if (genreName == 'All') {
        fetchAllMovies();
        fetchAllSeries();
      }
    });
    fetchSearchData();
    fetchAllSeries();
    fetchWatchLaterData();
    fetchGenres();
    fetchAllMovies();
    fetchAllContent();
    fetchWatchhistoryData();
    loadContinueWatching();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }

  void onGenreSelected(String genreName) {
    final genreSlug = genreName.toLowerCase();
    fetchMoviesByGenre(genreSlug);
    fetchSeriesByGenre(genreSlug);
  }

  Future<void> fetchSearchData({String? title}) async {
    try {
      isLoading(true);
      errorMessage('');
      final searchResponse = await _homeService.searchAll(title: title);
      items.assignAll([...searchResponse.movies, ...searchResponse.series]);
    } catch (e) {
      errorMessage('Failed to load search data: $e');
    } finally {
      isLoading(false);
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchSearchData(title: query.isEmpty ? null : query);
    });
  }

  void clearSearch() {
    searchQuery.value = '';
    fetchSearchData();
  }

  Future<void> fetchMovieDetails(int id, String aliastype) async {
    try {
      isDetailsLoading(true);
      detailsErrorMessage('');
      final details = await HomeService.getMovieDetails(id, aliastype);
      movieDetails.value = details;
      Get.to(() => MovieDetailsPage(), transition: Transition.rightToLeftWithFade);
    } catch (e) {
      detailsErrorMessage('Failed to load movie details: $e');
    } finally {
      isDetailsLoading(false);
    }
  }

  Future<void> fetchSeriesDetails(int id, String aliastype) async {
    try {
      isSeriesDetailsLoading(true);
      SeriesdetailsErrorMessage('');
      final details = await HomeService.getSeriesDetails(id, aliastype);
      SeriesDetails.value = details;
      selectedSeasonIndex.value = 0;
      Get.to(() => SeriesDetailsPage(), transition: Transition.rightToLeftWithFade);
    } catch (e) {
      SeriesdetailsErrorMessage('Failed to load series details: $e');
    } finally {
      isSeriesDetailsLoading(false);
    }
  }

  Future<void> fetchWatchhistoryData() async {
    try {
      isWatchhistoryLoading(true);
      watchjistoryErrorMessage('');
      final searchResponse = await _homeService.getWatchHistory();
      final movies = searchResponse.movies;
      final series = searchResponse.series;
      watchjistoryitems.assignAll([...movies, ...series]);
    } catch (e) {
      watchjistoryErrorMessage('Failed to load watch history data: $e');
    } finally {
      isWatchhistoryLoading(false);
    }
  }

  Future<void> fetchCollectionsData() async {
    try {
      iscollectionLoading(true);
      collectionErrorMessage('');
      final searchResponse = await _homeService.getCollections();
      final movies = searchResponse.movies;
      final series = searchResponse.series;
      collectionitems.assignAll([...movies, ...series]);
    } catch (e) {
      collectionErrorMessage('Failed to load collections data: $e');
    } finally {
      iscollectionLoading(false);
    }
  }

  Future<void> addToWatchLater(int id, String aliasType) async {
    try {
      isWatchLaterLoading(true);
      watchLaterErrorMessage('');
      await _homeService.addToWatchLater(id, aliasType);
      await fetchWatchLaterData();
      Get.snackbar(
        'added_to_watch_later'.tr,
        'added_to_watch_later_msg'.tr,
        backgroundColor: AppColor.vividAmber,
        colorText: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16.w),
        borderRadius: 8.r,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      watchLaterErrorMessage('Failed to add to watch later: $e');
      Get.snackbar(
        'Error',
        'failed_add_watch_later'.tr,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16.w),
        borderRadius: 8.r,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isWatchLaterLoading(false);
    }
  }

  Future<void> removeFromWatchLater(int id, String aliasType) async {
    try {
      isWatchLaterLoading(true);
      watchLaterErrorMessage('');
      await _homeService.removeFromWatchLater(id, aliasType);
      await fetchWatchLaterData();
      Get.snackbar(
        'removed_from_watch_later'.tr,
        'removed_from_watch_later_msg'.tr,
        backgroundColor: AppColor.vividAmber,
        colorText: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16.w),
        borderRadius: 8.r,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      watchLaterErrorMessage('Failed to remove from watch later: $e');
      Get.snackbar(
        'Error',
        'failed_remove_watch_later'.tr,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16.w),
        borderRadius: 8.r,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isWatchLaterLoading(false);
    }
  }

  Future<void> removeFromWatchhistory(int id, String aliasType) async {
    try {
      isWatchhistoryLoading(true);
      watchjistoryErrorMessage('');
      await _homeService.removeFromWatchhistory(id, aliasType);
      await fetchWatchhistoryData();
      Get.snackbar(
        'removed_from_watch_history'.tr,
        'removed_from_watch_history_msg'.tr,
        backgroundColor: AppColor.vividAmber,
        colorText: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16.w),
        borderRadius: 8.r,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      watchjistoryErrorMessage('Failed to remove from watch history: $e');
      Get.snackbar(
        'Error',
        'failed_remove_watch_history'.tr,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16.w),
        borderRadius: 8.r,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isWatchhistoryLoading(false);
    }
  }

  Future<void> fetchWatchLaterData() async {
    try {
      isWatchLaterLoading(true);
      watchLaterErrorMessage('');
      final searchResponse = await _homeService.getWatchLater();
      final movies = searchResponse.movies;
      final series = searchResponse.series;
      watchLaterItems.assignAll([...movies, ...series]);
    } catch (e) {
      watchLaterErrorMessage('Failed to load watch later data: $e');
    } finally {
      isWatchLaterLoading(false);
    }
  }

  Future<void> likeMovie(int id, String aliasType) async {
    try {
      await _homeService.likeItem(id, aliasType);
      await fetchMovieDetails(id, aliasType);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update like: $e', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> dislikeMovie(int id, String aliasType) async {
    try {
      await _homeService.dislikeContent(id, aliasType);
      await fetchMovieDetails(id, aliasType);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update dislike: $e', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> likeSeries(int id, String aliasType) async {
    try {
      await _homeService.likeItem(id, aliasType);
      await fetchSeriesDetails(id, aliasType);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update like: $e', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> dislikeSeries(int id, String aliasType) async {
    try {
      await _homeService.dislikeContent(id, aliasType);
      await fetchSeriesDetails(id, aliasType);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update dislike: $e', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> fetchGenres() async {
    try {
      isGenresLoading(true);
      genresErrorMessage('');
      final genres = await _homeService.getGenres();
      final capitalizedGenres = genres.map((genre) => genre.capitalizeFirst!).toList();
      genre.assignAll(capitalizedGenres);
    } catch (e) {
      genresErrorMessage('Failed to load genres: $e');
    } finally {
      isGenresLoading(false);
    }
  }

  Future<void> fetchAllMovies() async {
    try {
      isAllMoviesLoading(true);
      allMoviesErrorMessage('');
      final response = await _homeService.getAllMovies();
      allMoviesResponse.value = response;
      _updateMovieTypes(response);
    } catch (e) {
      allMoviesErrorMessage('Failed to load all movies: $e');
    } finally {
      isAllMoviesLoading(false);
    }
  }

  Future<void> fetchMoviesByGenre(String genreSlug) async {
    try {
      isAllMoviesLoading(true);
      allMoviesErrorMessage('');
      final response = await _homeService.getMoviesByGenre(genreSlug);
      allMoviesResponse.value = response;
      _updateMovieTypes(response);
    } catch (e) {
      allMoviesErrorMessage('Failed to load movies by genre: $e');
    } finally {
      isAllMoviesLoading(false);
    }
  }

  void _updateMovieTypes(MovieResponse? response) {
    if (response != null) {
      final types = <String>[];
      if (response.popular.isNotEmpty) types.add('popular');
      if (response.watchLater.isNotEmpty) types.add('watch_later');
      if (response.previousYear.isNotEmpty) types.add('previous_year');
      if (response.animation.isNotEmpty) types.add('animation');
      if (response.action.isNotEmpty) types.add('action');
      if (response.drama.isNotEmpty) types.add('drama');
      if (response.horror.isNotEmpty) types.add('horror');
      if (response.scienceFiction.isNotEmpty) types.add('science-fiction');
      if (response.mystery.isNotEmpty) types.add('mystery');
      movieTypes.assignAll(types);
    }
  }

  Future<void> fetchAllSeries() async {
    try {
      isAllSeriesLoading(true);
      allSeriesErrorMessage('');
      final response = await _homeService.getAllSeries();
      allSeriesResponse.value = response;
      _updateSeriesTypes(response);
    } catch (e) {
      allSeriesErrorMessage('Failed to load all series: $e');
    } finally {
      isAllSeriesLoading(false);
    }
  }

  Future<void> fetchSeriesByGenre(String genreSlug) async {
    try {
      isAllSeriesLoading(true);
      allSeriesErrorMessage('');
      final response = await _homeService.getSeriesByGenre(genreSlug);
      allSeriesResponse.value = response;
      _updateSeriesTypes(response);
    } catch (e) {
      allSeriesErrorMessage('Failed to load series by genre: $e');
    } finally {
      isAllSeriesLoading(false);
    }
  }

  void _updateSeriesTypes(SeriesResponse? response) {
    if (response != null) {
      final types = <String>[];
      if (response.popular.isNotEmpty) types.add('popular');
      if (response.watchLater.isNotEmpty) types.add('watch_later');
      if (response.previousYear.isNotEmpty) types.add('previous_year');
      if (response.animation.isNotEmpty) types.add('animation');
      if (response.action.isNotEmpty) types.add('action');
      if (response.drama.isNotEmpty) types.add('drama');
      if (response.horror.isNotEmpty) types.add('horror');
      if (response.scienceFiction.isNotEmpty) types.add('science-fiction');
      if (response.mystery.isNotEmpty) types.add('mystery');
      seriesTypes.assignAll(types);
    }
  }

  Future<void> fetchAllContent() async {
    try {
      isAllContentLoading(true);
      allContentErrorMessage('');
      final response = await _homeService.getAllContent();
      allContentResponse.value = response;
      popularItems.assignAll(_alternateMoviesAndSeries(response.movies.popular, response.series.popular));
      bannerMovies.assignAll({
        for (var item in popularItems)
          if (item.postersUrl.isNotEmpty && item.postersUrl.first.isNotEmpty)
            item.postersUrl.first: (item is Movie || item is Series)
                ? item.genres.map((g) => g.name).toList().cast<String>()
                : <String>[],
      });
    } catch (e) {
      allContentErrorMessage('Failed to load all content: $e');
    } finally {
      isAllContentLoading(false);
    }
  }

  List<dynamic> _alternateMoviesAndSeries(List<dynamic> movies, List<dynamic> series) {
    final mixed = <dynamic>[];
    final maxLength = movies.length > series.length ? movies.length : series.length;
    for (int i = 0; i < maxLength; i++) {
      if (i < movies.length) mixed.add(movies[i]);
      if (i < series.length) mixed.add(series[i]);
    }
    return mixed;
  }
}
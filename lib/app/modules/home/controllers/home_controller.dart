import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/Get.dart';
import 'package:toastification/toastification.dart';
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
import '../../../utils/error_helper.dart';

class HomeController extends GetxController {
  final HomeService _homeService = Get.find<HomeService>();
  final NavController _navController = Get.find<NavController>();

  var currentIndex = 0.obs;

  var selectedSeasonIndex = 0.obs;

  // New Error States
  var isOffline = false.obs;
  var isServerDown = false.obs;
  var lastErrorCode = 0.obs;

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
      errorMessage(cleanErrorMessage(e));
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

    } catch (e) {
      detailsErrorMessage(cleanErrorMessage(e));
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
      SeriesdetailsErrorMessage(cleanErrorMessage(e));
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
      watchjistoryErrorMessage(cleanErrorMessage(e));
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
      collectionErrorMessage(cleanErrorMessage(e));
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
      toastification.show(
        title: Text('added_to_watch_later'.tr),
        description: Text('added_to_watch_later_msg'.tr),
        style: ToastificationStyle.fillColored, type: ToastificationType.success,
        autoCloseDuration: const Duration(seconds: 2),
      );
    } catch (e) {
      watchLaterErrorMessage(cleanErrorMessage(e));
      toastification.show(
        title: const Text('Error'),
        description: Text('failed_add_watch_later'.tr),
        style: ToastificationStyle.fillColored, type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 2),
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
      toastification.show(
        title: Text('removed_from_watch_later'.tr),
        description: Text('removed_from_watch_later_msg'.tr),
        style: ToastificationStyle.fillColored, type: ToastificationType.success,
        autoCloseDuration: const Duration(seconds: 2),
      );
    } catch (e) {
      watchLaterErrorMessage(cleanErrorMessage(e));
      toastification.show(
        title: const Text('Error'),
        description: Text('failed_remove_watch_later'.tr),
        style: ToastificationStyle.fillColored, type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 2),
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
      toastification.show(
        title: Text('removed_from_watch_history'.tr),
        description: Text('removed_from_watch_history_msg'.tr),
        style: ToastificationStyle.fillColored, type: ToastificationType.success,
        autoCloseDuration: const Duration(seconds: 2),
      );
    } catch (e) {
      watchjistoryErrorMessage(cleanErrorMessage(e));
      toastification.show(
        title: const Text('Error'),
        description: Text('failed_remove_watch_history'.tr),
        style: ToastificationStyle.fillColored, type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 2),
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
      watchLaterErrorMessage(cleanErrorMessage(e));
    } finally {
      isWatchLaterLoading(false);
    }
  }

  Future<void> likeMovie(int id, String aliasType) async {
    try {
      await _homeService.likeItem(id, aliasType);
      await fetchMovieDetails(id, aliasType);
    } catch (e) {
      final msg = cleanErrorMessage(e);
      if (msg != 'offline') {
        toastification.show(title: const Text('Error'), description: Text(msg), style: ToastificationStyle.fillColored, type: ToastificationType.error, autoCloseDuration: const Duration(seconds: 3));
      }
    }
  }

  Future<void> dislikeMovie(int id, String aliasType) async {
    try {
      await _homeService.dislikeContent(id, aliasType);
      await fetchMovieDetails(id, aliasType);
    } catch (e) {
      final msg = cleanErrorMessage(e);
      if (msg != 'offline') {
        toastification.show(title: const Text('Error'), description: Text(msg), style: ToastificationStyle.fillColored, type: ToastificationType.error, autoCloseDuration: const Duration(seconds: 3));
      }
    }
  }

  Future<void> likeSeries(int id, String aliasType) async {
    try {
      await _homeService.likeItem(id, aliasType);
      await fetchSeriesDetails(id, aliasType);
    } catch (e) {
      final msg = cleanErrorMessage(e);
      if (msg != 'offline') {
        toastification.show(title: const Text('Error'), description: Text(msg), style: ToastificationStyle.fillColored, type: ToastificationType.error, autoCloseDuration: const Duration(seconds: 3));
      }
    }
  }

  Future<void> dislikeSeries(int id, String aliasType) async {
    try {
      await _homeService.dislikeContent(id, aliasType);
      await fetchSeriesDetails(id, aliasType);
    } catch (e) {
      final msg = cleanErrorMessage(e);
      if (msg != 'offline') {
        toastification.show(title: const Text('Error'), description: Text(msg), style: ToastificationStyle.fillColored, type: ToastificationType.error, autoCloseDuration: const Duration(seconds: 3));
      }
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
      genresErrorMessage(cleanErrorMessage(e));
    } finally {
      isGenresLoading(false);
    }
  }

  Future<void> fetchAllMovies() async {
    try {
      isAllMoviesLoading(true);
      allMoviesErrorMessage('');
      _resetErrorStates();
      final response = await _homeService.getAllMovies();
      allMoviesResponse.value = response;
      _updateMovieTypes(response);
    } catch (e) {
      _handleError(e, allMoviesErrorMessage);
    } finally {
      isAllMoviesLoading(false);
    }
  }

  Future<void> fetchAllContent() async {
    try {
      isAllContentLoading.value = true;
      allContentErrorMessage.value = '';
      _resetErrorStates();

      final response = await _homeService.getAllContent();
      allContentResponse.value = response;

      popularItems.assignAll(_alternateMoviesAndSeries(response.movies.popular, response.series.popular));
      
      bannerMovies.assignAll({
        for (var item in popularItems)
          if (item.postersUrl.isNotEmpty && item.postersUrl.first.isNotEmpty)
            item.postersUrl.first: (item is Movie)
                ? item.genres.map((g) => g.name).toList()
                : (item is Series)
                    ? item.genres.map((g) => g.name).toList()
                    : <String>[],
      });

    } catch (e) {
      _handleError(e, allContentErrorMessage);
    } finally {
      isAllContentLoading.value = false;
    }
  }

  void _resetErrorStates() {
    isOffline.value = false;
    isServerDown.value = false;
    lastErrorCode.value = 0;
  }

  /// Extracts a clean error label from an exception.
  /// Returns "offline", "server_down", or "HTTP XXX" / "Error".
  static String _cleanError(Object e) {
    final s = e.toString();
    // Check for offline
    if (s.contains('SocketException') || s.contains('failed to connect') || s.contains('No internet') || s.contains('Network is unreachable')) {
      return 'offline';
    }
    // Extract HTTP status codes
    final codeMatch = RegExp(r'\b([3-5]\d{2})\b').firstMatch(s);
    if (codeMatch != null) return 'HTTP ${codeMatch.group(1)}';
    return 'Error';
  }

  void _handleError(Object e, RxString errorObservable) {
    final s = e.toString();
    if (s.contains('502')) {
      isServerDown.value = true;
      lastErrorCode.value = 502;
    } else if (s.contains('SocketException') || s.contains('failed to connect') || s.contains('No internet')) {
      isOffline.value = true;
    }
    errorObservable.value = _cleanError(e);
    debugPrint("API Error handled: $e");
  }

  Future<void> refreshHome() async {
    isOffline.value = false;
    isServerDown.value = false;
    await Future.wait([
      fetchAllContent(),
      fetchAllMovies(),
      fetchAllSeries(),
      fetchGenres(),
      loadContinueWatching(),
    ]);
  }

  Future<void> fetchMoviesByGenre(String genreSlug) async {
    try {
      isAllMoviesLoading(true);
      allMoviesErrorMessage('');
      _resetErrorStates();
      final response = await _homeService.getMoviesByGenre(genreSlug);
      allMoviesResponse.value = response;
      _updateMovieTypes(response);
    } catch (e) {
      _handleError(e, allMoviesErrorMessage);
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
      allSeriesErrorMessage(cleanErrorMessage(e));
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
      allSeriesErrorMessage(cleanErrorMessage(e));
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
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
  var selectedSeasonIndex = 0.obs; // Added for series season selection

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

  @override
  void onInit() {
    super.onInit();
    ever(_navController.selectedCategory, (genreName) {
      if (genreName.isNotEmpty &&
          genreName.toLowerCase() != 'all' &&
          genreName != 'My List') {
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
      isDetailsLoading(false);
      detailsErrorMessage('');
      final details = await HomeService.getMovieDetails(id, aliastype);
      movieDetails.value = details;
      Get.to(
        () => MovieDetailsPage(),
        transition: Transition.rightToLeftWithFade,
      );
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
      selectedSeasonIndex.value = 0; // Reset season index on new series
      Get.to(
        () => SeriesDetailsPage(),
        transition: Transition.rightToLeftWithFade,
      );
    } catch (e) {
      SeriesdetailsErrorMessage('Failed to load series details: $e');
    } finally {
      isSeriesDetailsLoading(false);
    }
  }

  void clearMovieDetails() {
    movieDetails.value = null;
    detailsErrorMessage('');
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
      collectionErrorMessage('Failed to load watch history data: $e');

    } finally {
      iscollectionLoading(false);
    }
  }

  Future<void> removeFromWatchLater(int id, String aliasType) async {
    try {
      isWatchLaterLoading(true);
      watchLaterErrorMessage('');
      await _homeService.removeFromWatchLater(id, aliasType);
      await fetchWatchLaterData();
      Get.snackbar(
        'Removed from Watch Later',
        'Item has been removed successfully!',
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
        'Failed to remove from Watch Later',
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
  /// 🔹 Fetch and update like status for a movie
  Future<void> likeMovie(int id, String aliasType) async {
    try {
      final updatedMovie = await _homeService.likeItem(id, aliasType);
await fetchMovieDetails(id, aliasType);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update like: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  /// 🔹 Fetch and update dislike status for a movie
  Future<void> dislikeMovie(int id, String aliasType) async {
    try {
      final updatedMovie = await _homeService.dislikeContent(id, aliasType);
      await fetchMovieDetails(id, aliasType);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update dislike: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  /// 🔹 Fetch and update like status for a series
  Future<void> likeSeries(int id, String aliasType) async {
    try {
      final updatedSeries = await _homeService.likeItem(id, aliasType);
      await fetchSeriesDetails(id, aliasType);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update like: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  /// 🔹 Fetch and update dislike status for a series
  Future<void> dislikeSeries(int id, String aliasType) async {
    try {
      final updatedSeries = await _homeService.dislikeContent(id, aliasType);
      await fetchSeriesDetails(id, aliasType);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update dislike: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> fetchGenres() async {
    try {
      isGenresLoading(true);
      genresErrorMessage('');
      final genres = await _homeService.getGenres();
      final capitalizedGenres = genres
          .map((genre) => genre.capitalizeFirst!)
          .toList();
      genre.assignAll(capitalizedGenres);
    } catch (e) {
      genresErrorMessage('Failed to load genres: $e');

    } finally {
      isGenresLoading(false);
    }
  }

  Future<void> addToWatchLater(int id, String aliasType) async {
    try {
      isWatchLaterLoading(true);
      watchLaterErrorMessage('');
      await _homeService.addToWatchLater(id, aliasType);
      await fetchWatchLaterData();
      Get.snackbar(
        'Added to Watch Later',
        'Item has been added successfully!',
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
        'Failed to add to Watch Later',
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
        'Removed from Watch History',
        'Item has been removed successfully!',
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
        'Failed to remove from Watch History',
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

  Future<void> fetchAllMovies() async {
    try {
      isAllMoviesLoading(true);
      allMoviesErrorMessage('');
      final response = await _homeService.getAllMovies();
      allMoviesResponse.value = response;
      final movieResponse = allMoviesResponse.value;
      if (movieResponse != null) {
        final types = <String>[];
        if (movieResponse.popular.isNotEmpty) types.add('popular');
        if (movieResponse.watchLater.isNotEmpty) types.add('watch_later');
        if (movieResponse.previousYear.isNotEmpty) types.add('previous_year');
        if (movieResponse.animation.isNotEmpty) types.add('animation');
        if (movieResponse.action.isNotEmpty) types.add('action');
        if (movieResponse.drama.isNotEmpty) types.add('drama');
        if (movieResponse.horror.isNotEmpty) types.add('horror');
        if (movieResponse.scienceFiction.isNotEmpty)
          types.add('science-fiction');
        if (movieResponse.mystery.isNotEmpty) types.add('mystery');
        movieTypes.assignAll(types);
      }
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
      final movieResponse = allMoviesResponse.value;
      if (movieResponse != null) {
        final types = <String>[];
        if (movieResponse.popular.isNotEmpty) types.add('popular');
        if (movieResponse.watchLater.isNotEmpty) types.add('watch_later');
        if (movieResponse.previousYear.isNotEmpty) types.add('previous_year');
        if (movieResponse.animation.isNotEmpty) types.add('animation');
        if (movieResponse.action.isNotEmpty) types.add('action');
        if (movieResponse.drama.isNotEmpty) types.add('drama');
        if (movieResponse.horror.isNotEmpty) types.add('horror');
        if (movieResponse.scienceFiction.isNotEmpty)
          types.add('science-fiction');
        if (movieResponse.mystery.isNotEmpty) types.add('mystery');
        movieTypes.assignAll(types);
      }
    } catch (e) {
      allMoviesErrorMessage('Failed to load movies by genre: $e');

    } finally {
      isAllMoviesLoading(false);
    }
  }

  Future<void> fetchAllSeries() async {
    try {
      isAllSeriesLoading(true);
      allSeriesErrorMessage('');
      final response = await _homeService.getAllSeries();
      allSeriesResponse.value = response;
      final seriesResponse = allSeriesResponse.value;
      if (seriesResponse != null) {
        final types = <String>[];
        if (seriesResponse.popular.isNotEmpty) types.add('popular');
        if (seriesResponse.watchLater.isNotEmpty) types.add('watch_later');
        if (seriesResponse.previousYear.isNotEmpty) types.add('previous_year');
        if (seriesResponse.animation.isNotEmpty) types.add('animation');
        if (seriesResponse.action.isNotEmpty) types.add('action');
        if (seriesResponse.drama.isNotEmpty) types.add('drama');
        if (seriesResponse.horror.isNotEmpty) types.add('horror');
        if (seriesResponse.scienceFiction.isNotEmpty)
          types.add('science-fiction');
        if (seriesResponse.mystery.isNotEmpty) types.add('mystery');
        seriesTypes.assignAll(types);
      }
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
      final seriesResponse = allSeriesResponse.value;
      if (seriesResponse != null) {
        final types = <String>[];
        if (seriesResponse.popular.isNotEmpty) types.add('popular');
        if (seriesResponse.watchLater.isNotEmpty) types.add('watch_later');
        if (seriesResponse.previousYear.isNotEmpty) types.add('previous_year');
        if (seriesResponse.animation.isNotEmpty) types.add('animation');
        if (seriesResponse.action.isNotEmpty) types.add('action');
        if (seriesResponse.drama.isNotEmpty) types.add('drama');
        if (seriesResponse.horror.isNotEmpty) types.add('horror');
        if (seriesResponse.scienceFiction.isNotEmpty)
          types.add('science-fiction');
        if (seriesResponse.mystery.isNotEmpty) types.add('mystery');
        seriesTypes.assignAll(types);
      }
    } catch (e) {
      allSeriesErrorMessage('Failed to load series by genre: $e');

    } finally {
      isAllSeriesLoading(false);
    }
  }

  Future<void> fetchAllContent() async {
    try {
      isAllContentLoading(true);
      allContentErrorMessage('');
      final response = await _homeService.getAllContent();
      allContentResponse.value = response;
      popularItems.assignAll(
        _alternateMoviesAndSeries(
          response.movies.popular,
          response.series.popular,
        ),
      );
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

  List<dynamic> _alternateMoviesAndSeries(
    List<dynamic> movies,
    List<dynamic> series,
  ) {
    final mixed = <dynamic>[];
    final maxLength = movies.length > series.length
        ? movies.length
        : series.length;
    for (int i = 0; i < maxLength; i++) {
      if (i < movies.length) mixed.add(movies[i]);
      if (i < series.length) mixed.add(series[i]);
    }
    return mixed;
  }
}

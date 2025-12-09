// lib/services/notification_service.dart
import 'dart:convert';
import 'package:Nuweli/app/res/colors/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import '../../main.dart';
import '../modules/home/services/home_service.dart';

@pragma('vm:entry-point')
Future<void> showRichNotification(Map<String, dynamic> data, {required bool isBackground}) async {
  final prefix = isBackground ? "BACKGROUND" : "FOREGROUND";
  print("$prefix → RAW DATA: $data");

  // ------------------------------------------------------------
  // FIX 1: Decode nested JSON from "body"
  // ------------------------------------------------------------
  if (data['body'] is String) {
    try {
      data = jsonDecode(data['body']);
      print("$prefix → DECODED BODY: $data");
    } catch (e) {
      print("$prefix → BODY DECODE FAILED: $e");
    }
  }

  print("$prefix → STARTED WITH DATA: $data");

  // Default notification text
  String title = "New on Nuweli";
  String body = "Now Streaming";
  String? posterUrl;

  // ------------------------------------------------------------
  // Extract ID + TYPE
  // ------------------------------------------------------------
  final idStr = data['id']?.toString();
  final typeRaw = (data['type']?.toString() ?? 'movie').toLowerCase();

  // accept both "movie" and "movies"
  final type = typeRaw.replaceAll('s', '');


  if (idStr != null && idStr.isNotEmpty) {
    try {
      final id = int.parse(idStr);

      if (type == 'movie') {
        final m = await HomeService.getMovieDetails(id, "movie");
        title = m.title;
        body = m.isComingSoon ? "Releasing ${m.formattedComingSoonDate}" : "Coming Soon";
        posterUrl = m.firstPosterUrl;

        print("$prefix → MOVIE TITLE: $title");
        print("$prefix → POSTER URL = $posterUrl");
      } else {
        final s = await HomeService.getSeriesDetails(id, "series");
        title = s.name;
        body = "New season available";
        posterUrl = s.firstPosterUrl;

        print("$prefix → SERIES NAME: $title");
        print("$prefix → POSTER URL = $posterUrl");
      }
    } catch (e) {
      print("$prefix → API FAILED: $e");
    }
  }

  // ------------------------------------------------------------
  // Build Big Picture Style
  // ------------------------------------------------------------
  BigPictureStyleInformation? bigPic;

  if (posterUrl != null && posterUrl.startsWith("http")) {
    try {
      final r = await http.get(Uri.parse(posterUrl)).timeout(const Duration(seconds: 10));

      if (r.statusCode == 200 && r.bodyBytes.isNotEmpty) {
        final bitmap = ByteArrayAndroidBitmap(r.bodyBytes);

        bigPic = BigPictureStyleInformation(
          bitmap,
          largeIcon: bitmap,
          contentTitle: '<b>$title</b>',
          htmlFormatContentTitle: true,
          summaryText: body,
        );
      } else {
        print("$prefix → POSTER FETCH FAILED (${r.statusCode})");
      }
    } catch (e) {
      print("$prefix → POSTER DOWNLOAD ERROR: $e");
    }
  }

  // ------------------------------------------------------------
  // Notification Channel
  // ------------------------------------------------------------
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'fcm_fallback_channel',
    'Nuweli Updates',
    description: 'Movie & Series Notifications',
    importance: Importance.max,
    playSound: true,
  );

  final android = flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  await android?.createNotificationChannel(channel);

  // ------------------------------------------------------------
  // Show Notification
  // ------------------------------------------------------------
  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    NotificationDetails(
      android: AndroidNotificationDetails(
        'fcm_fallback_channel',
        'Nuweli Updates',
        channelDescription: 'Movie & Series Notifications',
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: bigPic,
        playSound: true,
        enableVibration: true,
        showWhen: true,

      ),
    ),
    payload: jsonEncode(data),
  );

  print("$prefix → NOTIFICATION SHOWN: $title");
}

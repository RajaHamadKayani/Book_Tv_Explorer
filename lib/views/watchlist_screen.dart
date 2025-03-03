import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tv_and_movie_explorer/view_model/controllers/watchlist_controller.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  final WatchlistController watchlistController =
      Get.put(WatchlistController());
  @override
  void initState() {
    super.initState();
    watchlistController.fetchWatchlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Obx(() {
        if (watchlistController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (watchlistController.watchlistMovies.isEmpty) {
          return Center(
            child: Text(
              "No watchlist movie found",
              style: GoogleFonts.poppins(
                color: Colors.black,
              ),
            ),
          );
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "WatchList",
                  style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                    child: SizedBox(
                  width: double.infinity,
                  child: ListView.builder(
                      itemCount: watchlistController.watchlistMovies.length,
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        final movie =
                            watchlistController.watchlistMovies[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: SizedBox(
                              height: 100,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          "https://image.tmdb.org/t/p/w500${movie['poster_path']}",
                                          height: 100,
                                          width: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      FittedBox(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              movie['title'],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return alertDialogWidget(
                                                          movie['title'],
                                                          movie['id']);
                                                    });
                                              },
                                              child: Container(
                                                height: 40,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Center(
                                                  child: Text(
                                                    "Delete",
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        );
                      }),
                ))
              ],
            ),
          );
        }
      })),
    );
  }

  Widget alertDialogWidget(String movieTItle, int movieId) {
    return AlertDialog(
      title: Text(
        "Remove from watchlist",
        style: GoogleFonts.poppins(color: Colors.black),
      ),
      content: Text(
        "Are you sure want to remove $movieTItle from watchlist?",
        style: GoogleFonts.poppins(),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: 100,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            watchlistController.removeMovie(movieId);
            Navigator.pop(context);
          },
          child: Container(
            width: 100,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text(
                "Delete",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ),
        )
      ],
    );
  }
}

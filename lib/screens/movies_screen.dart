import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pmsn2024b/database/movies_database.dart';
import 'package:pmsn2024b/models/moviesdao.dart';
import 'package:pmsn2024b/settings/global_values.dart';
import 'package:pmsn2024b/views/movie_view.dart';
import 'package:pmsn2024b/views/movie_view_item.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  late MoviesDatabase moviesDB;

  @override
  void initState() {
    super.initState();
    moviesDB = MoviesDatabase();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies List'),
        actions: [
          IconButton(
            onPressed: (){
              WoltModalSheet.show(
                context: context,
                pageListBuilder: (context) => [
                  WoltModalSheetPage(
                    child: MovieView()
                  )
                ],
              );
            },
            icon: const Icon(Icons.add)
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: GlobalValues.flagUpdListMovies,
        builder: (context, value, child) {
          return FutureBuilder(
            future: moviesDB.SELECT(),
            builder: (context, AsyncSnapshot<List<MoviesDAO>> snapshot) {
              if(snapshot.hasData){
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index){
                    return MovieViewItem(moviesDAO: snapshot.data![index],);
                  },
                );
              } else {
                if(snapshot.hasError){
                  return Center(child: Text(snapshot.toString()));
                } else {
                  return Center(child: Lottie.asset('assets/lottie/TecNMLoading.json')/*CircularProgressIndicator()*/,);
                }
              }
            }
          );
        }
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mosdetector/features/mosqiuto/presentation/screens/mosqiuto_detail_page.dart';
import 'package:mosdetector/features/mosqiuto/presentation/screens/name_mapper.dart';

import '../../../../core/shared_widgets/appBar.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/ui_converter.dart';
import '../bloc/mosqiuto_bloc.dart';
// import '../widgets/recent_cards.dart';

class RecentPage extends StatefulWidget {
  const RecentPage({super.key});
  
  @override
  State<RecentPage> createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CHSAppBar.build(context, 'Recent', () {}, false),
      body: BlocConsumer<MosqiutoBloc, MosqiutoState>(
        listener: (context, state) {
          print("STATATTTTttttttttttttttttttttttttt");
          
        },
        builder: (context, state) {
          if (state is MosquitoSuccessState) {
             return ListView.builder(
              itemCount: state.mosqiutoes.length,
              itemBuilder: (context, ind) {
                return GestureDetector(
                  onTap: () {
                          
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MosquitoesDetail(description: dict[state.mosqiutoes[ind].name]!.description, name: state.mosqiutoes[ind].name, url: dict[state.mosqiutoes[ind].name]!.url,))
                                  );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0XFFF1F3FC),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: EdgeInsets.only(
                              top: 5,
                              bottom: 5,
                              left: UIConverter.getComponentWidth(context, 30),
                              right: UIConverter.getComponentWidth(context, 30)),
                          width: UIConverter.getComponentWidth(context, 370),
                          height: UIConverter.getComponentHeight(context, 108),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Container(
                                width:
                                    UIConverter.getComponentWidth(context, 110),
                                height:
                                    UIConverter.getComponentWidth(context, 88),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(10)),
                                  image: DecorationImage(
                                      image: AssetImage(dict[state.mosqiutoes[ind].name]!.url),
                                      fit: BoxFit.fill),
                                ),
                              ),
                              SizedBox(
                                width: UIConverter.getComponentWidth(context, 8),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: UIConverter.getComponentWidth(context, 230),
                                    child:  Text(
                                      dict[state.mosqiutoes[ind].name]!.name,
                                       maxLines:1,
                                      style: const TextStyle(
                                          color: cardTitleColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                         
                                          ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    state.mosqiutoes[ind].time.substring(11,19),
                                    style: const TextStyle(
                                        color: cardSubTitleColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(height: 5,),
                                  Text(
                                    state.mosqiutoes[ind].time.substring(0,10),
                                    style: const TextStyle(
                                        color: cardSubTitleColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        );
              });
          } else if (state is MosquitoLoadingState  || state is MosqiutoInitial) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Recent"),
              ),

              body: const Center(child: CircularProgressIndicator(backgroundColor: Colors.amber, color: Colors.red,)),
            ) ;
          } else {
            return const Center(
              child: Text("Error while fecthing"),
            );
          }
         
        }
      ),
    );
  }
}

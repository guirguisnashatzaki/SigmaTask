import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:sigma_task/business_logic/cubit/user_cubit.dart';
import 'package:sigma_task/models/user.dart';
import 'package:sigma_task/widgets/custom_button.dart';
import 'package:flutter_offline/flutter_offline.dart';
import '../constants/colors.dart';
import '../widgets/add_player_widget.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int limit = 10;
  final ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  late List<User> list;
  bool isSearch = false;
  bool isLoading = false;

  List<User> searchedList = [];

  List<Map<String,String?>> imagesList = [
    {
      "id":null,
      "image":null,
      "added":"false"
    },{
      "id":null,
      "image":null,
      "added":"false"
    },{
      "id":null,
      "image":null,
      "added":"false"
    },{
      "id":null,
      "image":null,
      "added":"false"
    },{
      "id":null,
      "image":null,
      "added":"false"
    },{
      "id":null,
      "image":null,
      "added":"false"
    }
  ];

  // Player addition function to be added in buttons
  Function add(String image,int id){
    return (){
      bool found = true;
      for (var element in imagesList) {
        if(element["image"] == null){
          found = true;
          setState(() {
            imagesList[imagesList.indexOf(element)]["image"] = image;
            imagesList[imagesList.indexOf(element)]["id"] = id.toString();
            imagesList[imagesList.indexOf(element)]["added"] = "true";
          });
          break;
        }else{
          found = false;
        }
      }
      if(!found){
        const snackBar = SnackBar(
          content: Text('All places are filled'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    };
  }

  // Player removal function to be added in buttons
  Function remove(int id){
    return (){
      int i = imagesList.length - 1;
      bool found = false;

      while(i >= 0){
        if(imagesList[i]["id"] == id.toString()){
          found = true;
          setState(() {
            imagesList[i]["image"] = null;
            imagesList[i]["id"] = null;
            imagesList[i]["added"] = "false";
          });
          break;
        }
        i--;
      }

      if(!found){
        const snackBar = SnackBar(
          content: Text('Nothing to remove'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    };
  }

  // Get flag indicates whether this player is added or not
  getAdded(int id){
    for (var element in imagesList) {
      if(element["id"] == id.toString()){
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    list = BlocProvider.of<UserCubit>(context).getAllUsers(limit);
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;

      if (currentScroll == maxScroll) {
        setState(() {
          isLoading = true;
        });
        //When the last item is fully visible, load the next page

        setState(() {
          limit += 10;
          list = BlocProvider.of<UserCubit>(context).getAllUsers(limit);
          isLoading = false;
        });
      }
    });
  }

  Widget builBlocWidget(){
    return BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoaded) {
            list = (state).users;
            return Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  height: MediaQuery.of(context).size.height/1.6,
                  child: ListView(
                    controller: _scrollController,
                    children: isSearch? List.generate(searchedList.length, (index) =>
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  AddPlayerWidget(networkImage: searchedList[index].image,added: false),
                                  Text(searchedList[index].firstName!),
                                ],
                              ),

                              CustomButton(
                                addFunction: add(searchedList[index].image!,searchedList[index].id!),
                                removeFunction: remove(searchedList[index].id!),
                                added: getAdded(searchedList[index].id!),
                                imagesList: imagesList,
                              )

                            ],
                          ),
                        )
                    ) : List.generate(list.length, (index) =>
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  AddPlayerWidget(networkImage: list[index].image,added: false),
                                  Text(list[index].firstName!),
                                ],
                              ),

                              CustomButton(
                                addFunction: add(list[index].image!,list[index].id!),
                                removeFunction: remove(list[index].id!),
                                added: getAdded(list[index].id!),
                                imagesList: imagesList,
                              )

                            ],
                          ),
                        )
                    ),
                  ),
                ),
                Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: isLoading ? const Center(child: CircularProgressIndicator(color: MyColors.primary,),) :
                    const SizedBox.shrink()
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add players",style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // Players in game
            SizedBox(
              height: 90,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(imagesList.length, (index){
                  return Stack(
                    children: [
                      AddPlayerWidget(
                          networkImage: imagesList[index]["image"],
                          added: bool.parse(imagesList[index]["added"]!)
                      ),
                      bool.parse(imagesList[index]["added"]!) ? Positioned(
                        top: 15,
                        right: 15,
                        child: InkWell(
                          onTap: (){
                            int i = imagesList.length - 1;
                            bool found = false;

                            while(i >= 0){
                              if(imagesList[i]["id"] == imagesList[index]["id"].toString()){
                                found = true;
                                setState(() {
                                  imagesList[i]["image"] = null;
                                  imagesList[i]["id"] = null;
                                  imagesList[i]["added"] = "false";
                                });
                                break;
                              }
                              i--;
                            }

                            if(!found){
                              const snackBar = SnackBar(
                                content: Text('Nothing to remove'),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white),
                                color: Colors.white
                            ),
                            child:const Icon(Icons.clear,color: Colors.red,),
                          ),
                        ),
                      ):const SizedBox.shrink(),
                    ],
                  );
                })
              ),
            ),

            //Search bar
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: 40,
              color: Colors.white54,
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: TextFormField(
                onChanged: (value){
                  setState(() {
                    searchedList.clear();
                  });
                  if(value.isEmpty){
                    setState(() {
                      isSearch = false;
                    });
                  }else{
                    setState(() {
                      isSearch = true;
                    });
                  }
                  setState(() {
                    for (var element in list) {
                      if(element.firstName!.contains(value)){
                        searchedList.add(element);
                      }
                    }
                  });
                },
                controller: searchController,
                style: const TextStyle(
                  decoration: TextDecoration.none
                ),
                cursorColor: const Color.fromRGBO(92,105,212, 1),
                textAlign: TextAlign.justify,
                decoration: InputDecoration(

                  contentPadding: const EdgeInsets.all(8),
                  labelStyle: const TextStyle(
                    color: Colors.grey,

                  ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(92,105,212, 1)
                      )
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                        borderSide: const BorderSide(
                            color: Color.fromRGBO(92,105,212, 1)
                        )
                    ),
                  border: InputBorder.none,
                  prefixIcon: const Icon(
                    Icons.search
                  ),
                  label: const Text("Search by player name",textAlign: TextAlign.center,)
                ),
              ),
            ),

            //Players list
            OfflineBuilder(
              connectivityBuilder: (BuildContext context,ConnectivityResult connectivity,Widget child){
                final bool connected = connectivity != ConnectivityResult.none;

                if(connected){
                  return builBlocWidget();
                }else{
                  return  Center(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Can\'t connect .. check internet',
                            style: TextStyle(
                              fontSize: 22,
                              color: MyColors.primary,
                            ),
                          ),
                          Image.asset('assets/images/no_internet.png')
                        ],
                      ),
                    ),
                  );
                }
              },
              child: const Center(
                child: CircularProgressIndicator(
                  color: MyColors.primary,
                ),
              ),
            ),

            const Divider(),

            InkWell(
              onTap: (){

              },
              child: InkWell(
                onTap: () async {

                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(92,105,212, 1),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  alignment: Alignment.center,
                  child: const Text("Continue",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
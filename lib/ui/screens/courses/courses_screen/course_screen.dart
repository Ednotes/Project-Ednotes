import 'package:edtech/core/models/course.dart';
import 'package:edtech/ui/screens/courses/courses_screen/courses_screen_view_model.dart';
import 'package:edtech/ui/screens/courses/view_course_screen.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:edtech/core/graphql.dart ';
import 'package:stacked/stacked.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class CourseScreen extends StatefulWidget {
  static const routeName = "/course";
  @override
  CourseScreenState createState() {
    return CourseScreenState();
  }
}

class CourseScreenState extends State<CourseScreen> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CoursesViewModel>.reactive(
      viewModelBuilder: () => CoursesViewModel(),
      builder: (context, model, child) => Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: Theme.of(context).accentColor,
              elevation: 0,
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              transform: Matrix4.translationValues(0.0, -15.0, 0.0),
              // margin: EdgeInsets.only(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration:
                        BoxDecoration(color: Theme.of(context).accentColor),
                    height: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 9),
                        Text(
                          'Courses!',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(height: 6),
                        Container(
                          width: 350,
                          child: Text(
                            'Find this semester courses below',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      transform: Matrix4.translationValues(0.0, -50.0, 0.0),
                      margin: EdgeInsets.only(right: 10, left: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                      padding: EdgeInsets.only(left: 12, right: 12),
                      // height:300,
                      child: Column(
                        children: [
                          searchWidget(),
                          Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(
                                          top: 12,
                                          right: 27,
                                          left: 27,
                                          bottom: 12),
                                      decoration: BoxDecoration(
                                          color: Colors.lightBlueAccent,
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: Text(
                                        'All',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Container(
                                      padding: EdgeInsets.only(
                                          top: 12,
                                          right: 27,
                                          left: 27,
                                          bottom: 12),
                                      decoration: BoxDecoration(
                                          color: Color(0xFFF1F1F1),
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: Text(
                                        'Physics',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Container(
                                      padding: EdgeInsets.only(
                                          top: 12,
                                          right: 27,
                                          left: 27,
                                          bottom: 12),
                                      decoration: BoxDecoration(
                                          color: Color(0xFFF1F1F1),
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: Text(
                                        'Mathematics',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Container(
                                      padding: EdgeInsets.only(
                                          top: 12,
                                          right: 27,
                                          left: 27,
                                          bottom: 12),
                                      decoration: BoxDecoration(
                                          color: Color(0xFFF1F1F1),
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: Text(
                                        'Chemistry',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              )),

                          SizedBox(
                            height: 40,
                          ),
                          // GraphQLProvider.of(context)
                          GraphQLProvider(
                            client: client,
                            child: Query(
                                options: QueryOptions(
                                  document: gql(allCourses),
                                  // fetchPolicy: FetchPolicy.networkOnly,
                                ),
                                builder: (QueryResult? result,
                                    {VoidCallback? refetch,
                                    FetchMore? fetchMore}) {
                                  if (result!.isLoading) {
                                    return CircularProgressIndicator();
                                  }
                                  if (result.hasException) {
                                    print(result.exception.toString());
                                    // print(MyApp.temporaryToken);
                                    return Container(
                                      padding: EdgeInsets.only(top: 1),
                                      child: Text(
                                        result.exception.toString(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    );
                                  }
                                  // prefs.getString('token')
                                  // print(result.data);
                                  model.getCourses(result);
                                  return ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: model.coursesList.length,
                                      itemBuilder: (context, index) {
                                        print(model.coursesList);
                                        Course course =
                                            model.coursesList[index];
                                        return Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/aeror.png'),
                                                      fit: BoxFit.cover),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              height: 200,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(
                                                    left: 22, right: 22),
                                                padding: EdgeInsets.only(
                                                    top: 17, bottom: 17),
                                                transform:
                                                    Matrix4.translationValues(
                                                        0, -50, 0),
                                                decoration: BoxDecoration(
                                                    color: Color(0xFFF1F1F1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            19)),
                                                // height: 120,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ViewCourseScreen()));
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: 200,
                                                        child: Wrap(
                                                          children: [
                                                            Center(
                                                              child: Text(
                                                                course.name!,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      Container(
                                                        width: 255,
                                                        child: Wrap(
                                                          children: [
                                                            Center(
                                                              child: Text(
                                                                course
                                                                    .description!,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ))
                                          ],
                                        );
                                      });
                                }),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          )),
    );
  }

  Widget searchWidget() {
    return Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 2,
            blurRadius: 100,
            offset: Offset(0, -3),
          )
        ]),
        transform: Matrix4.translationValues(0, -30, 0),
        // width: 310,
        child: Form(
          child: TextFormField(
            decoration: InputDecoration(
                hintText: 'Search',
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide.none,
                ),
                // icon: new Icon(Icons.search, color: Colors.white),
                contentPadding: EdgeInsets.only(top: 20, bottom: 20, left: 35),
                suffixIcon: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: new Icon(Icons.search, color: Colors.white),
                )),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your email ';
              }
              // if(!RegExp())
              return null;
            },
          ),
        ));
  }
}

import 'dart:developer';

import 'package:edtech/core/models/error_model.dart';
import 'package:edtech/core/models/success_model.dart';
import 'package:edtech/core/services/auth_service.dart';

import 'package:edtech/locator.dart';
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:edtech/main.dart';

//  String token = '';
// Future <void>  getToken() async {
//   SharedPreferences prefs = await MyApp.prefs;
//   token = prefs.getString('token');
// }

String userToken = '';
bool tokenState = false;
final AuthService _authService = locator<AuthService>();

Future<void> savedToken() async {
  // var test;
  print('Saved Token opening');
  SharedPreferences prefs = await MyApp.prefs;

  // test = prefs.getString('token');
  // print('I am calling token');
  userToken = prefs.getString('token')!;

  MyApp.temporaryToken = userToken;
  // print('I am calling token');
  // print(userToken);
  if (userToken != '') {
    tokenState = true;
    MyApp.tokenTempState = true;
  }

  print(MyApp.temporaryToken);
}

Map<String, String> map = {};

// Map<String, String> headersTest() {
//   if (MyApp.tokenTempState == true) {
//     map.putIfAbsent(
//         'Authorization', () => "Bearer ${_authService.authModel.token}");
//   }
//   return map;
// }

class GraphQLConfiguration {
  static final AuthService _authService = AuthService();
  static final AuthLink authLink =
      AuthLink(getToken: () => 'Bearer  ${_authService.authModel.token}');

  static HttpLink httpLink = HttpLink(
    'https://ednotes-api.herokuapp.com/graphql/',
    // defaultHeaders: {"Authorization": "Bearer ${_authService.authModel.token}"}
  );

  var link = authLink.concat(httpLink);

  ValueNotifier<GraphQLClient> client = ValueNotifier(
      // cache: InMemoryCache(),
      GraphQLClient(cache: GraphQLCache(store: HiveStore()), link: httpLink));

  static ValueNotifier<GraphQLClient> initailizeClient() {
    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        cache: GraphQLCache(store: HiveStore()),
        link: httpLink,
      ),
    );

    return client;
  }

  Future<AuthLink> _getAuthLink() async {
    String? _getAuthToken;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token')??"";
    if (token.isNotEmpty) {
      _getAuthToken = "Bearer $token";
    } else {
      _getAuthToken = "";
    }

    print(" heres the token from graphql $_getAuthToken");
    return AuthLink(
      headerKey: "Authorization",
      getToken: () => _getAuthToken,
    );
  }

  Future<GraphQLClient> clientToQuery() async {
    // HttpLink httpLink = HttpLink(
    //   uri: 'https://ednotes-api.herokuapp.com/graphql/',
    //   // headers: {"Authorization": "Bearer ${_authService?.authModel?.token}"}
    // );
    return GraphQLClient(
        link: await _getAuthLink().then((value) {
          return value
              .concat(HttpLink('https://ednotes-api.herokuapp.com/graphql/'));
        }),
        cache: GraphQLCache(store: HiveStore()));
  }

  // ignore: missing_return
  gpMutate({
    @required String? mutationDOcument,
    Map<String, dynamic>? data,
  }) async {
    try {
      QueryResult queryResult;
      queryResult = await clientToQuery().then((value) {
        return value.mutate(MutationOptions(
          document: gql(mutationDOcument!),
          variables: data ?? {},
        ));
      });
      if (queryResult.hasException) {
        // print(queryResult.exception);
        return ErrorModel(queryResult.exception.toString());
      } else {
        // print(queryResult.data);
        return SuccessModel(queryResult.data!);
      }
    } catch (e) {
      log('Error $e');
      return ErrorModel(e);
    }
  }

  // ignore: missing_return
  gpQuery({
    @required String? queryDocumnet,
    Map<String, dynamic>? data,
  }) async {
    try {
      QueryResult queryResult = await clientToQuery().then((value) {
        return value.query(QueryOptions(
          document: gql(queryDocumnet!),
          variables: data ?? {},
        ));
      });

      if (queryResult.hasException) {
        return ErrorModel(queryResult.exception.toString());
      } else {
        return SuccessModel(queryResult.data);
      }
    } catch (e) {
      log('Error $e');
      return ErrorModel(e);
    }
  }
}

HttpLink link = HttpLink('https://ednotes-api.herokuapp.com/graphql/',
    defaultHeaders: {
      "Authorization": "Bearer ${_authService.authModel.token}"
    });

ValueNotifier<GraphQLClient> client = ValueNotifier(
    // cache: InMemoryCache(),
    GraphQLClient(
  cache: GraphQLCache(store: HiveStore()),
  link: link,
));

GraphQLClient myClient() {
  return GraphQLClient(cache: GraphQLCache(store: HiveStore()), link: link);
}

ValueNotifier<GraphQLClient> clientToQuery = ValueNotifier(
    GraphQLClient(link: link, cache: GraphQLCache(store: HiveStore())));

String getCountry = """
      query{
        schools {
          name
        }
        faculties {
          name
        }
        depts {
          name
        }
        levels {
          name
        }
      }
    """;

String allCourses = """
      query{
        get_all_courses{
          edges{
            name
            description,
            _id,
            semester,
            faculty{
              _id,
              name,
            },
            dept{
              _id,
              name
            },
            level{
              _id,
              name
            }
          }
        }
      }
    """;

String singleCourse = """
      query(\$courseId: String!){
        get_single_course(courseId: \$courseId){
          data{
            name
            description,
            _id,
            semester
          }
        }
      }
    """;

String studentProfile = """
      query{
        student{
          user{
            username,
            firstName
          },
          phoneNumber
        }
      }
    """;

String fetchSchools = """
      query{
        schools{
          name,
          _id
        }
      }
    """;

String fetchFaculties = """
      query{
        faculties{
          name,
          _id
        }
      }
    """;

String fetchLevels = """
      query{
        levels{
          name,
          _id
        }
      }
    """;

String fetchDept = """
      query{
        depts{
          name,
          _id
        }
      }
    """;

String editStudentProfile = """
    mutation editProfile(\$state: String!, \$school: ID!, \$faculty: ID!, \$dept: ID!, \$level: ID!) {
      updateStudentProfile(state: \$state, school: \$school, faculty: \$faculty,dept: \$dept,level: \$level) {
        message,value,student{
         
          state
        }
      }
    }
    """;

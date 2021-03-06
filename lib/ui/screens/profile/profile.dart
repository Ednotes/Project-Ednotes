import 'package:auto_route/auto_route.dart';
// import 'package:edtech/router/router.gr.dart';
import 'package:edtech/router/router.gr.dart';
import 'package:edtech/ui/screens/profile/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return ViewModelBuilder<ProfileViewModel>.reactive(
      onModelReady: (model) {
        model.getUser(context: context);
      },
      viewModelBuilder: () => ProfileViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    AutoRouter.of(context).pop();
                  }),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.edit_outlined,
                    color: Colors.white38,
                  ),
                ),
              ]),
        ),
        body: SingleChildScrollView(
          child: Container(
            // transform: Matrix4.translationValues(0.0, -50.0, 0.0),
            // margin: EdgeInsets.only(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  // shape: ,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                  child: Container(
                    transform: Matrix4.translationValues(0, -50, 0),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/profile.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(3)),
                    height: size.height * 0.3,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.only(right: 20, top: 16),
                  ),
                ),
                Container(
                  height: size.height * 0.45,
                  margin: EdgeInsets.only(right: 30, left: 30),
                  padding:
                      EdgeInsets.only(top: 24, bottom: 17, left: 12, right: 12),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(.25), blurRadius: 3)
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: size.width - 120,
                                child: Text(
                                  '${model.user.user!.firstName} ${model.user.user!.lastName}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                              onTap: () {
                                // ExtendedNavigator.of(context)
                                //     .push(Routes.editProfile);
                                AutoRouter.of(context)
                                    .push(const EditProfileRoute());
                              },
                              child: Icon(Icons.edit_outlined))
                        ],
                      ),
                      SizedBox(height: size.height * 0.04),
                      Text(
                        'Department: ${model.user.dept?.name ?? 'Edit profile to add info'}',
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      Text(
                        'Faculty: ${model.user.faculty?.name ?? 'Edit profile to add info'}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      Text(
                        'University: ${model.user.school?.name ?? 'Edit profile to add info'}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      Text(
                        'State: ${model.user.state ?? 'Edit profile to add info'}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
          },
          child: Icon(Icons.chat_bubble_outline_rounded),
          backgroundColor: Color(0xFFF7B928),
        ),
      ),
    );
  }
}

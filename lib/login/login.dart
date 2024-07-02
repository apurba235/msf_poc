import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:msf/common_graphics/buttons/common_filled_button.dart';
import 'package:msf/common_graphics/text_form_fields/common_text_form_field.dart';
import 'package:msf/config/app_colors.dart';
import 'package:msf/database/msf_db.dart';
import 'package:msf/utils/color_consts.dart';
import 'package:reactiv/reactiv.dart';
import '../config/constant.dart';
import '../config/size_config.dart';
import '../menu/menu_screen.dart';
import '../model/MasterDataModel.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  ReactiveInt tappedIndex = ReactiveInt(0);
  Map userData = {};
  final _formkey = GlobalKey<FormState>();
  DatabaseHelper databaseHelper = DatabaseHelper();
  final TextEditingController _emailController = TextEditingController(text: "admin@gmail.com");

  final TextEditingController _passwordController = TextEditingController(text: "admin@12345");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("selectId....    ");

    insertDataInUserList();
  }

  Future<int> selectTopSearchTable(String searchValue) async {
    // var db = await this.database;
    int selectId = -1;
    selectId = await databaseHelper
        .selectDataTable(DatabaseHelper.MSF_USERS_TABLE, "${Constant.EMAIL_ID} = ?  ", /*     "  ${Constant.SEARCH_TYPE} = ? ",*/
            [
      searchValue,
    ]);
    print("selectId....$selectId    $searchValue");
    return selectId;
  }

  insertDataInUserList() async {
    String emailID = "admin@gmail.com";
    await selectTopSearchTable(emailID).then((value) async {
      print("len......$value");
      if (value == 0) {
        int optionTableRowId = -1;

        MasterDataModel topSearchLocalDataModel = MasterDataModel(
          0,
          "admin@gmail.com",
          "admin@12345",
        );

        optionTableRowId =
            await databaseHelper.insertDataInTableGame(DatabaseHelper.MSF_USERS_TABLE, topSearchLocalDataModel.toMap());
      } else {
        await databaseHelper
            // .deleteRowsTopSearchTable(name.trim())
            .deleteAndInsertRowsTopSearchTable(emailID.trim())
            .then((value) async {
          print("deletet...$value");
          if (value == 1) {
            int optionTableRowId = -1;

            MasterDataModel topSearchLocalDataModel = MasterDataModel(0, "admin@gmail.com", "admin@12345");

            optionTableRowId =
                await databaseHelper.insertDataInTableGame(DatabaseHelper.MSF_USERS_TABLE, topSearchLocalDataModel.toMap());
          } /*else{
                     TopSearchLocalDataModel topSearchLocalDataModel =
                    new TopSearchLocalDataModel(
                        userId, searchType, name.trim(), isVip, picUrl);
                     optionTableRowId = await databaseHelper.updateTableRow(
                        DatabaseHelper.TOP_SEARCH_TABLE,
                        topSearchLocalDataModel.toMap(),'name',name.trim());
                }*/
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                // SizedBox(
                //   height: 100,
                //   child: Stack(
                //     alignment: Alignment.bottomCenter,
                //     clipBehavior: Clip.none,
                //     children: [
                //       Positioned(
                //         left: -75,
                //         top: 5,
                //         child: Container(
                //           width: 120,
                //           height: 100,
                //           decoration: const BoxDecoration(
                //             image: DecorationImage(
                //               image: AssetImage('assets/main_logo.png'),
                //             ),
                //           ),
                //         ),
                //       ),
                //       Text(
                //         'Medecins sans frontiers\ndoctors without borders'.toUpperCase(),
                //         style: const TextStyle(fontWeight: FontWeight.w900, fontStyle: FontStyle.italic),
                //       )
                //     ],
                //   ),
                // ),
                Image.asset('assets/main_logo.png'),
                const SizedBox(height: 30),
                Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CommonTextFormField(
                        controller: _emailController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Enter email address'),
                          EmailValidator(errorText: 'Please correct email ID'),
                        ]).call,
                        hintText: 'Email',
                        labelText: 'Email',
                        // prefixIcon: Icon(
                        //   Icons.email,
                        //   //color: Colors.green,
                        // ),
                      ),
                      const SizedBox(height: 20),
                      CommonTextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Please enter Password'),
                          MinLengthValidator(8, errorText: 'Password must be atlist 8 digit'),
                          PatternValidator(r'(?=.*?[#!@$%^&*-])', errorText: 'Password must be atlist one special character')
                        ]).call,
                        hintText: 'Password',
                        labelText: 'Password',
                        // prefixIcon: Icon(
                        //   Icons.key,
                        //   color: Colors.green,
                        // ),
                      ),
                      const SizedBox(height: 15),
                      // const Align(
                      //   alignment: Alignment.centerRight,
                      //   child: Text(
                      //     'Forgot Password?',
                      //     style: TextStyle(color: AppColorConsts.deepRed, fontWeight: FontWeight.w600),
                      //   ),
                      // ),
                      // const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: CommonFilledButton(
                              onPressed: () async {
                                //  var dbclient = await databaseHelper;
                                if (_formkey.currentState!.validate()) {
                                  // var queryResult = await dbclient.('SELECT * FROM ${DatabaseHelper.MSF_USERS_TABLE} WHERE uidCol="aaa"');
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(builder: (context) => MenuScreen()));
                                }
                              },
                              buttonText: 'Login',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

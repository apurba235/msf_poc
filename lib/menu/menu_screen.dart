import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msf/common_graphics/bottom_navbar/bottom_nav_bar.dart';
import 'package:msf/config/app_colors.dart';
import 'package:msf/config/app_string.dart';
import 'package:msf/config/size_config.dart';
import 'package:msf/dashboard/dashboard.dart';
import 'package:msf/database/database_helper.dart';
import 'package:msf/reports/reports_screen.dart';
import 'package:msf/scan/scan_ocr.dart';
import 'package:msf/utils/color_consts.dart';
import 'package:msf/utils/local_storage.dart';
import 'package:msf/utils/services.dart';
import 'package:reactiv/reactiv.dart';

class MenuScreen extends StatefulWidget {
  MenuScreen({super.key});

  final drawerItems = [
    DrawerItem(
      AppString.scanOCR,
      'assets/scan.png',
    ),
    DrawerItem(
      AppString.dashboard,
      'assets/dashboard.png',
    ),
    DrawerItem(
      AppString.reports,
      'assets/tick.png',
    ),
  ];

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool isLoading = false;

  @override
  void initState() {
    bool dataAvailability = LocalStorage.instance.readBool(LocalStorageKeys.dataPresent) ?? false;
    if (!dataAvailability) {
      isLoading = true;
      setState(() {});
      AppServices.instance.loadData().then((v) {
        isLoading = false;
        setState(() {});
        log('Data Written');
        LocalStorage.instance.writeBool(LocalStorageKeys.dataPresent, true);
      });
    }
    DatabaseHelper.instance.getItems();
    super.initState();
  }

  int _selectedDrawerIndex = -1;
  bool drawerVisible = false;
  ReactiveInt navIndex = ReactiveInt(0);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    List<Widget> drawerOptions = [];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(
        InkWell(
          onTap: () => _onSelectItem(i),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
            decoration: BoxDecoration(color: AppColorConsts.lightestWhite, borderRadius: BorderRadius.circular(16.0)),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: i == 0 ? AppColorConsts.lightDeepRed : AppColorConsts.lightGrey,
                        ),
                        child: Image.asset(
                          d.icon,
                          color: i == 2 ? null : AppColorConsts.white,
                          height: 40.0,
                          width: 40.0,
                        ),
                      ),
                      const SizedBox(width: 18.0),
                      Text(
                        d.title,
                        style: GoogleFonts.monomaniacOne
                            .call()
                            .copyWith(fontSize: 18.0, color: i == 0 ? AppColorConsts.blackishGrey : AppColorConsts.lightGrey),
                      )
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: i == 0 ? AppColorConsts.blackishGrey : AppColorConsts.lightGrey,
                )
              ],
            ),
          ),
        ),
      );
      // drawerOptions.add(ListTile(
      //     // leading: Icon(d.icon),
      //
      //     selectedColor: AppColors.lightBlueColor,
      //     leading: Image.asset(
      //       d.icon
      //     ),
      //     title: Text(
      //       d.title,
      //       style: TextStyle(
      //           fontSize: SizeConfig.blockSizeHorizontal * 5.0, color: AppColors.blackColor, fontWeight: FontWeight.w400),
      //     ),
      //     selected: i == _selectedDrawerIndex,
      //     onTap: () => _onSelectItem(i),
      // ),
      // );
    }
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.whiteColor,
      /* drawer: Drawer(
        // backgroundColor: Colors.transparent,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: SizeConfig.screenHeight * 0.25,
              decoration: const BoxDecoration(
                  color: AppColors.lightBlueColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: Padding(
                padding: EdgeInsets.only(
                  left: SizeConfig.screenWidth * 0.05,
                  right: SizeConfig.screenWidth * 0.05,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: SizeConfig.screenWidth * 0.2,
                      width: SizeConfig.screenWidth * 0.2,
                      margin: const EdgeInsets.only(right: 5),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                "assets/placeholder.png",
                              )),
                          shape: BoxShape.circle),
                    ),

                    // Container(
                    //   // color:Colors.white,
                    //   child: Image.asset(
                    //     ImagePath.placeholder,
                    //     height: SizeConfig.screenWidth * 0.2,
                    //     width: SizeConfig.screenWidth * 0.2,
                    //   ),
                    // ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Admin",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: SizeConfig.blockSizeHorizontal * 5.5),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Column(children: drawerOptions)
          ],
        ),
      ),*/
      //   body: _getDrawerItemWidget(_selectedDrawerIndex),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          Text(
                            'John doe',
                            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                          ),
                        ],
                      ),
                      Image.asset(
                        'assets/user_hero.png',
                        height: 70,
                        width: 70,
                      )
                    ],
                  ),
                  const SizedBox(height: 80),
                  ...List.generate(
                    drawerOptions.length,
                    (i) {
                      var d = widget.drawerItems[i];
                      return MenuRow(
                        onTapMenu: () {
                          if (i == 0) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (cx) => ScanOCRPage(),
                              ),
                            );
                          }
                          // _onSelectItem(i);
                        },
                        i: i,
                        icon: d.icon,
                        title: d.title,
                      );
                    },
                  ),
                ],
              ),
            ),
      // _selectedDrawerIndex == -1
      //     ? Padding(
      //         padding: const EdgeInsets.all(20.0),
      //         child: Column(
      //           children: [
      //             SizedBox(height: MediaQuery.of(context).padding.top + 20),
      //             Column(
      //               children: drawerOptions,
      //             ),
      //             // Expanded(
      //             //   child: GridView.builder(
      //             //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      //             //     itemBuilder: (_, index) => GestureDetector(
      //             //       onTap: () {
      //             //         //  _getDrawerItemWidget(_selectedDrawerIndex);
      //             //       },
      //             //       child: Column(
      //             //         children: drawerOptions,
      //             //       ),
      //             //     ),
      //             //     itemCount: 1,
      //             //   ),
      //             // ),
      //           ],
      //         ),
      //       )
      //     : _getDrawerItemWidget(_selectedDrawerIndex),
      bottomNavigationBar: Observer(
          listenable: navIndex,
          listener: (selectedIndex) {
            final List<String> icons = [
              'assets/home.png',
              'assets/scan.png',
              'assets/bell.png',
            ];
            return BottomNavBar<int>(
              selectedValue: selectedIndex,
              onChanged: (value) {
                navIndex.value = value;
              },
              items: List.generate(
                3,
                (index) {
                  return BottomNavBarItem<int>(
                    value: index,
                    icon: icons[index],
                  );
                },
              ),
            );
          }),
    );
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return ScanOCRPage();
      case 1:
        return const DashboardScreen();
      case 2:
        return const ReportScreen();
      default:
        return Center(
          child: Text(AppString.comingSoon),
        );
    }
  }

  _onSelectItem(int index) {
    setState(() {
      _selectedDrawerIndex = index;
    });
    //Navigator.of(context).pop();
    // close the drawer
  }
}

class MenuRow extends StatelessWidget {
  const MenuRow({
    super.key,
    required this.icon,
    required this.title,
    this.onTapMenu,
    required this.i,
  });

  final String icon;
  final String title;
  final void Function()? onTapMenu;
  final int i;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapMenu,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
        decoration: BoxDecoration(color: AppColorConsts.lightestWhite, borderRadius: BorderRadius.circular(16.0)),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: i == 0 ? AppColorConsts.lightDeepRed : AppColorConsts.lightGrey,
                    ),
                    child: Image.asset(
                      icon,
                      color: i == 2 ? null : AppColorConsts.white,
                      height: 40.0,
                      width: 40.0,
                    ),
                  ),
                  const SizedBox(width: 18.0),
                  Text(
                    title,
                    style: GoogleFonts.monomaniacOne
                        .call()
                        .copyWith(fontSize: 18.0, color: i == 0 ? AppColorConsts.blackishGrey : AppColorConsts.lightGrey),
                  )
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward,
              color: i == 0 ? AppColorConsts.blackishGrey : AppColorConsts.lightGrey,
            )
          ],
        ),
      ),
    );
  }
}

class DrawerItem {
  String title;
  String icon;

  DrawerItem(this.title, this.icon);
}

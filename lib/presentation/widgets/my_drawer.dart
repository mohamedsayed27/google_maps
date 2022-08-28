import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps/constants/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps/constants/strings.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/phone_auth_cubit/phone_auth_cubit.dart';

// ignore: must_be_immutable
class MyDrawer extends StatelessWidget {
  MyDrawer({Key? key}) : super(key: key);

  PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit();

  Widget buildDrawerHeader(context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsetsDirectional.fromSTEB(70, 10, 70, 10),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.blue[100],
          ),
          child: Image.network(
            'https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg',
            fit: BoxFit.cover,
            height: 100,
            width: 100,
          ),
        ),
        const Text(
          'Mohamed Sayed',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        BlocProvider<PhoneAuthCubit>(
            create: (context) => phoneAuthCubit,
            child: Text(
              '${phoneAuthCubit.loggedIn().phoneNumber}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            )),
      ],
    );
  }

  Widget buildDrawerListItem({
    required IconData leadingIcon,
    required String title,
    Widget? trailing,
    Function()? onTab,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(
        leadingIcon,
        color: color ?? AppColors.blue,
      ),
      title: Text(title),
      onTap: onTab,
      trailing: trailing ??= const Icon(
        Icons.arrow_right,
        color: AppColors.blue,
      ),
    );
  }

  Widget buildDividerItem() {
    return const Divider(
      height: 0,
      thickness: 1,
      indent: 10,
      endIndent: 24,
    );
  }

  void launcher(String url) async {
    final uri = Uri(host: url , scheme: 'https');
    try{
      await launchUrl(uri,mode: LaunchMode.externalNonBrowserApplication);
    }catch(e){
      throw '$e';
    }
  }

  Widget buildIcons(IconData icon, String url) {
    return InkWell(
      onTap: () => launcher(url),
      child: Icon(
        icon,
        color: AppColors.blue,
        size: 35,
      ),
    );
  }

  Widget buildSocialMediaIcons() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 16),
      child: Row(
        children: [
          buildIcons(FontAwesomeIcons.facebook, 'www.facebook.com'),
          buildIcons(FontAwesomeIcons.facebook, 'www.facebook.com'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 200,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue[100],
              ),
              child: buildDrawerHeader(context),
            ),
          ),
          buildDrawerListItem(leadingIcon: Icons.person, title: 'My Profile'),
          buildDividerItem(),
          buildDrawerListItem(
              leadingIcon: Icons.history, title: 'History', onTab: () {}),
          buildDividerItem(),
          buildDrawerListItem(leadingIcon: Icons.settings, title: 'Settings'),
          buildDividerItem(),
          buildDrawerListItem(leadingIcon: Icons.help, title: 'Help'),
          buildDividerItem(),
          BlocProvider<PhoneAuthCubit>(
            create: (context) => phoneAuthCubit,
            child: buildDrawerListItem(
                leadingIcon: Icons.logout,
                title: 'LogOut',
                onTab: () async {
                  final navigator = Navigator.of(context);
                  await phoneAuthCubit.loggedOut();
                  navigator.pushReplacementNamed(loginScreen);
                },
                color: Colors.red,
                trailing: const SizedBox(
                  width: 0,
                  height: 0,
                )),
          ),
          const SizedBox(
            height: 100,
          ),
          ListTile(
            leading: Text(
              'Follow Us',
              style: TextStyle(color: Colors.grey[400]),
            ),
          ),
          buildSocialMediaIcons(),
        ],
      ),
    );
  }
}

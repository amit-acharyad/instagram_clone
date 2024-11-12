import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/common/widgets/shimmer.dart';
import 'package:instagram_clone/features/personalization/data/models/usermodel.dart';
import 'package:instagram_clone/utils/helpers/helper_functions.dart';

import '../../../../common/widgets/searchbar.dart';
import '../../../../localizations/app_localizations.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../HomeScreen/widgets/posts/postuploader.dart';
import '../ProfileScreen/othersProfile.dart';

class Searchscreen2 extends StatefulWidget {
  const Searchscreen2({super.key});

  @override
  State<Searchscreen2> createState() => _Searchscreen2State();
}

class _Searchscreen2State extends State<Searchscreen2> {
  String searchText = '';
  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.spaceBtwItems),
            child: SizedBox(
              height: AppSizes.xl,
              child: TextFormField(
                showCursor: false,
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(AppSizes.xs),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    disabledBorder: border,
                    enabledBorder: border,
                    border: border,
                    focusedBorder: border,
                    filled: true,
                    fillColor: isDark ? AppColors.darkerGrey : Colors.grey[200],
                    prefixIcon:const Icon(
                      Icons.search,
                      size: AppSizes.iconXs,
                    ),
                    labelText: AppLocalizations.of(context).search),
              ),
            ),
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .orderBy("userName")
                  .startAt([searchText])
                  .endAt(['$searchText\uf8ff'])
                  .snapshots()
                  .map((users) => users.docs
                      .map((user) => UserModel.fromSnapshot(user))
                      .toList()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: AppShimmerEffect(width: AppHelperFunctions.screenWidth(context)*0.8, height: 50),
                  );
                }
                if (snapshot.hasError) {
                  return const Text("Error");
                }
                if (!snapshot.hasData) {
                  return const Text("no users");
                }
                return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final user = snapshot.data?[index];
                      return ListTile(
                        leading: PostUploader(size: 30, image: user!.photoUrl),
                        onTap: ()=>Get.to(Profile(userModel: user,)),
                        title: Text(user.name),
                        subtitle: Text(user.userName),
                      );
                    });
              })
        ],
      )),
    );
  }
}

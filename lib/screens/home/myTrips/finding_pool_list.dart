import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nfc_wallet/screens/home/myTrips/list_of_poolers_screen.dart';
import 'package:nfc_wallet/service/find_pool_service.dart';
import 'package:nfc_wallet/service/user_service.dart';
import 'package:nfc_wallet/theme/colors.dart';
import 'package:nfc_wallet/utils/utils.dart';

class FindingTab extends ConsumerWidget {
  const FindingTab({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = AppLocalizations.of(context);
    final findingdataStreams = ref.watch(FindPoolService.findingStreams);
    final userStreams = ref.watch(UserService.usersStream);
    final isLoading = findingdataStreams.isLoading || userStreams.isLoading;
    final findingsData = findingdataStreams.value ?? [];
    final userdata = userStreams.value ?? [];

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Container(
        decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(15)),
        child: FadedSlideAnimation(
          beginOffset: Offset(0.4, 0),
          endOffset: Offset(0, 0),
          slideCurve: Curves.linearToEaseOut,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (findingsData.isEmpty)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 200,
                      ),
                      Icon(
                        Icons.drive_eta_rounded,
                        size: 50,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 10),
                      Text(
                        'No Pool Found',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  itemCount: findingsData.length,
                  itemBuilder: (BuildContext context, int index) {
                    final pool = findingsData[index];
                    final acceptedUser = userdata.firstWhereOrNull((user) => user.id == pool.acceptedByDriver);
                    return GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => TripPoolerInfo(imgs[0],
                        //             "Sam Smith", index % 2 == 0 ? true : false)));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListOfPoolersScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(formatTime(pool.dateTime),
                                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 13.5)),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              formatDate(pool.dateTime),
                                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 10),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 4),
                                          child: Icon(
                                            Icons.circle,
                                            color: Colors.grey[300],
                                            size: 5,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(pool.pickupLocation.address,
                                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 10)),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 1),
                                      child: Icon(
                                        Icons.more_vert,
                                        color: Colors.grey[400],
                                        size: 10,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.grey[300],
                                          size: 12,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(pool.dropoffLocation.address,
                                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 10)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              color: Theme.of(context).dividerColor,
                              width: 1,
                              height: 130,
                            ),
                            Column(
                              children: [
                                SizedBox(height: 8),
                                SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (pool.pending == true)
                                        CircleAvatar(
                                          radius: 14,
                                          backgroundColor: Color(0xffd9e3ea),
                                          child: Icon(
                                            Icons.local_taxi,
                                            color: Theme.of(context).scaffoldBackgroundColor,
                                            size: 20,
                                          ),
                                        )
                                      else
                                        Stack(
                                          alignment: AlignmentDirectional.topEnd,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: ClipOval(
                                                  child: CachedNetworkImage(
                                                imageUrl: acceptedUser!.profilePicture ?? 'assets/1.png',
                                                fit: BoxFit.cover,
                                                progressIndicatorBuilder: (context, url, progress) => Center(
                                                  child: SizedBox(
                                                    height: 50,
                                                    width: 50,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      value: progress.progress,
                                                    ),
                                                  ),
                                                ),
                                                errorWidget: (context, url, error) => Image.asset(
                                                  'assets/1.png',
                                                ),
                                              )),
                                            ),
                                            Icon(
                                              Icons.check_circle,
                                              color: Theme.of(context).primaryColor,
                                              size: 14,
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12),
                                Container(
                                  height: 40,
                                  width: 80,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Color(0xffe3ac17).withOpacity(0.05),
                                    borderRadius: BorderRadiusDirectional.only(
                                      bottomEnd: Radius.circular(8),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                      end: 6.0,
                                      top: 2.0,
                                      start: 4.0,
                                    ),
                                    child: Text(
                                      '${pool.pending == true ? locale?.pending : locale?.accepted}',
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                            fontSize: 10,
                                            color: Color(0xffe3ac17),
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

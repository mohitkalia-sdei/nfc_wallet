import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nfc_wallet/screens/home/myTrips/pool_taker_request_screen.dart';
import 'package:nfc_wallet/service/offer_pool_service.dart';
import 'package:nfc_wallet/theme/colors.dart';
import 'package:nfc_wallet/utils/utils.dart';

class OfferingTab extends ConsumerWidget {
  const OfferingTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = AppLocalizations.of(context);
    final offersStreams = ref.watch(OfferPoolService.offeringStreams);
    final isLoading = offersStreams.isLoading;
    final offerdatas = offersStreams.value ?? [];
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Container(
        decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(15)),
        child: FadedSlideAnimation(
          beginOffset: Offset(0.4, 0),
          endOffset: Offset(0, 0),
          slideCurve: Curves.linearToEaseOut,
          child: Column(
            children: [
              // if (_anchoredBanner != null)
              //   Container(
              //     width: _anchoredBanner!.size.width.toDouble(),
              //     height: _anchoredBanner!.size.height.toDouble(),
              //     child: AdWidget(ad: _anchoredBanner!),
              //   ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  itemCount: offerdatas.length,
                  itemBuilder: (BuildContext context, int index) {
                    final offerData = offerdatas[index];
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
                            builder: (context) => PoolTakerRequestScreen(),
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
                                            Text(formatTime(offerData.dateTime),
                                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 13.5)),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              formatDate(offerData.dateTime),
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
                                        Text(offerData.pickupLocation.address,
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
                                        Text(offerData.dropoffLocation.address,
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
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    itemCount: 4,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 8,
                                      crossAxisSpacing: 8,
                                    ),
                                    itemBuilder: (context, gridIndex) {
                                      return Stack(
                                        alignment: AlignmentDirectional.topEnd,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: CircleAvatar(
                                              backgroundColor: Color(0xffd9e3ea),
                                              backgroundImage: index % 4 != 0 || gridIndex <= 1
                                                  ? AssetImage(
                                                      'assets/profiles/img${gridIndex + 1}.png',
                                                    )
                                                  : null,
                                              child: index % 4 == 0 && !(gridIndex <= 1)
                                                  ? Icon(
                                                      Icons.person,
                                                      color: Theme.of(context).scaffoldBackgroundColor,
                                                      size: 18,
                                                    )
                                                  : null,
                                            ),
                                          ),
                                          if (index % 4 != 0 || gridIndex <= 1)
                                            Icon(
                                              Icons.check_circle,
                                              color: Theme.of(context).primaryColor,
                                              size: 14,
                                            ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 12),
                                Container(
                                  height: 40,
                                  width: 80,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor.withOpacity(0.05),
                                    borderRadius: BorderRadiusDirectional.only(
                                      bottomEnd: Radius.circular(8),
                                    ),
                                  ),
                                  child: Stack(
                                    alignment: AlignmentDirectional.topEnd,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional.only(
                                          end: 6.0,
                                          top: 2.0,
                                          start: 4.0,
                                        ),
                                        child: Text(
                                          index % 4 == 0 ? locale?.requests ?? '' : locale?.passengers ?? '',
                                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                fontSize: 10,
                                                color: Theme.of(context).primaryColor,
                                              ),
                                        ),
                                      ),
                                      if (index % 4 == 0)
                                        CircleAvatar(
                                          backgroundColor: Colors.red,
                                          radius: 6,
                                          child: Text(
                                            '2',
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 8),
                                          ),
                                        ),
                                    ],
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

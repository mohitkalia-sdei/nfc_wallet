import 'package:animation_wrappers/Animations/faded_scale_animation.dart';
import 'package:animation_wrappers/Animations/faded_slide_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nfc_wallet/components/widgets/color_button.dart';
import 'package:nfc_wallet/components/widgets/text_field.dart';
import 'package:nfc_wallet/theme/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class Support extends StatelessWidget {
  Support({super.key});

  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: backgroundColor,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      locale.support,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 22),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      locale.connectUs,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  children: [
                    SizedBox(
                      height: 42,
                    ),
                    FadedScaleAnimation(
                      scaleDuration: const Duration(milliseconds: 600),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.width * 0.25,
                        child: Image.asset("assets/head_support.png"),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          FadedSlideAnimation(
            beginOffset: Offset(0, 0.4),
            endOffset: Offset(0, 0),
            slideCurve: Curves.linearToEaseOut,
            child: Stack(alignment: Alignment.bottomCenter, children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.71,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            locale.addIssueFeedback,
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14),
                          ),
                          SizedBox(
                            height: 0,
                          ),
                          EntryField(
                            locale.writeyourMessage,
                            locale.writeyourMessage,
                            false,
                            maxLines: 4,
                            controller: messageController,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              )
            ]),
          ),
          PositionedDirectional(
            bottom: 0,
            end: 0,
            start: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: GestureDetector(
                onTap: () {
                  String message = messageController.text.trim();
                  if (message.isNotEmpty) {
                    launchWhatsApp(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter a message')),
                    );
                  }
                },
                child: FadedScaleAnimation(
                  scaleDuration: const Duration(milliseconds: 600),
                  child: ColorButton(locale.submit),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> launchWhatsApp(BuildContext context) async {
    String message = messageController.text;
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a message')),
      );
      return;
    }

    const String phone = '+250780786039';
    final Uri url = Uri.parse(
      'https://wa.me/$phone?text=${Uri.encodeComponent(message)}',
    );

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch WhatsApp.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Fail')),
      );
    }
  }
}

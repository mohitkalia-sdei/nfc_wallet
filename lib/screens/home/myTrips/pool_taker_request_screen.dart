import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nfc_wallet/screens/home/myTrips/pool_taker_accepted_offer.dart';

class PoolTakerRequest {
  String image;
  String rating;
  String title;
  String subTitle;
  String seatCount;
  String amount;
  String pickup;
  String drop;

  PoolTakerRequest({
    required this.image,
    required this.rating,
    required this.title,
    required this.subTitle,
    required this.seatCount,
    required this.amount,
    required this.pickup,
    required this.drop,
    this.isAccepted,
  });

  bool? isAccepted;
}

class PoolTakerRequestScreen extends StatefulWidget {
  const PoolTakerRequestScreen({super.key});

  @override
  State<PoolTakerRequestScreen> createState() => _PoolTakerRequestScreenState();
}

class _PoolTakerRequestScreenState extends State<PoolTakerRequestScreen> {
  final List<PoolTakerRequest> _list = [
    PoolTakerRequest(
      image: 'assets/profiles/img1.png',
      rating: '4.5',
      title: 'George Enterson',
      subTitle: 'Bank of USA',
      seatCount: '1',
      amount: '\$3.50',
      pickup: 'Hemiltone Bridge',
      drop: 'World Trade Point',
    ),
    PoolTakerRequest(
      image: 'assets/profiles/img2.png',
      rating: '4.8',
      title: 'Samantha Smith',
      subTitle: 'Harvard law school',
      seatCount: '2',
      amount: '\$7.50',
      pickup: 'City Parle Point',
      drop: 'World Trade Point',
    ),
    PoolTakerRequest(
      image: 'assets/profiles/img3.png',
      rating: '4.7',
      title: 'Billie Anderson',
      subTitle: 'Florida University',
      seatCount: '1',
      amount: '\$5.50',
      pickup: 'Hemiltone Bridge',
      drop: 'World Trade Point',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          locale?.poolTakerRequest ?? '',
          style: theme.textTheme.titleSmall?.copyWith(fontSize: 16),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: ListView.separated(
          padding: EdgeInsets.all(15),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                if (!(_list[index].isAccepted ?? true)) {
                  buildShowModalBottomSheet(theme, context, index);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PoolTakerAcceptedOffer(),
                    ),
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: theme.scaffoldBackgroundColor,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Image.asset(
                            _list[index].image,
                            height: 44,
                            width: 44,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Color(0xff69ca2f),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Color(0xffffae22),
                                size: 12,
                              ),
                              SizedBox(width: 4),
                              Text(
                                _list[index].rating,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontSize: 8,
                                  color: theme.scaffoldBackgroundColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _list[index].title,
                                  style: theme.textTheme.titleSmall,
                                ),
                              ),
                              Text(
                                _list[index].amount,
                                style: theme.textTheme.titleSmall,
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.verified_user_sharp,
                                color: theme.primaryColor,
                                size: 12,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _list[index].subTitle,
                                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                                ),
                              ),
                              Text(
                                '${_list[index].seatCount} ${locale?.seat}',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                          SizedBox(height: 14),
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
                              Text(_list[index].pickup,
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
                              Text(_list[index].drop,
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 10)),
                            ],
                          ),
                          SizedBox(height: 14),
                          if (_list[index].isAccepted == null)
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _list[index].isAccepted = false;
                                      });
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Color(0xfffbe3e3),
                                      ),
                                      child: Center(
                                        child: Text(
                                          locale?.decline ?? '',
                                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                              fontSize: 10, color: Color(0xffdd142c), fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _list[index].isAccepted = true;
                                      });
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: Theme.of(context).primaryColor),
                                      child: Center(
                                        child: Text(
                                          locale?.accept ?? '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else if (_list[index].isAccepted ?? false)
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: theme.primaryColor,
                                  size: 18,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    locale?.accepted ?? '',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      color: theme.primaryColor,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: theme.primaryColor,
                                  child: Icon(
                                    Icons.mail,
                                    size: 20,
                                    color: theme.scaffoldBackgroundColor,
                                  ),
                                ),
                                SizedBox(width: 10),
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: theme.primaryColor,
                                  child: Icon(
                                    Icons.call,
                                    size: 20,
                                    color: theme.scaffoldBackgroundColor,
                                  ),
                                ),
                              ],
                            )
                          else
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Color(0xffdd142c),
                                  size: 18,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Text(
                                      locale?.rejected ?? '',
                                      style: theme.textTheme.titleSmall?.copyWith(
                                        color: Color(0xffdd142c),
                                        fontSize: 11,
                                      ),
                                    ),
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
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 10);
          },
          itemCount: _list.length,
        ),
      ),
    );
  }

  Future<dynamic> buildShowModalBottomSheet(ThemeData theme, BuildContext context, int index) {
    return showModalBottomSheet(
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 6),
          Center(
            child: Container(
              height: 4,
              width: 66,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: theme.dividerColor,
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  _list[index].image,
                  height: 44,
                  width: 44,
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _list[index].title,
                              style: theme.textTheme.titleSmall,
                            ),
                          ),
                          Text(
                            _list[index].amount,
                            style: theme.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.verified_user_sharp,
                            color: theme.primaryColor,
                            size: 12,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _list[index].subTitle,
                              style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                            ),
                          ),
                          Text(
                            '${_list[index].seatCount} ${AppLocalizations.of(context)?.seat}',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 34),
          Divider(
            thickness: 3,
            height: 3,
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)?.rating ?? '',
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xff69ca2f),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Color(0xffffae22),
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '4.5',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)?.rideWith ?? '',
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '314 ${AppLocalizations.of(context)?.people}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)?.joined ?? '',
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'in 2019',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Divider(
            thickness: 3,
            height: 3,
            color: theme.dividerColor,
          ),
          SizedBox(height: 30),
          buildColumn(
              theme, AppLocalizations.of(context)?.hobby ?? '', AppLocalizations.of(context)?.hobbyDetail ?? ''),
          SizedBox(height: 28),
          buildColumn(theme, AppLocalizations.of(context)?.bio ?? '', AppLocalizations.of(context)?.bioDetail ?? ''),
          SizedBox(height: 32),
        ],
      ),
    );
  }

  Column buildColumn(ThemeData theme, String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 14),
          ),
        ),
        SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Text(
            subtitle,
            style: theme.textTheme.titleSmall?.copyWith(
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Region {
  String code, currency;
  int pel;
  Map<String, dynamic> ussd;
  String? service;
  Region(
    this.code,
    this.currency,
    this.pel,
    this.ussd, {
    this.service,
  });

  factory Region.fromJSON(Map<String, dynamic> json) {
    return Region(
      json['code'],
      json['currency'],
      json['pel'],
      json['ussd'],
      service: json['service'],
    );
  }

  bool hasCode() {
    return ussd['code'] != null;
  }

  String accountName(AppLocalizations locale, String account) {
    if (service != null) {
      return locale.mobileAccount(service!);
    }
    return account;
  }

  String accountCode(AppLocalizations locale, String account) {
    if (service != null) {
      return locale.mobileCode(service!);
    }
    return account;
  }

    String paymentCode(String amount, String number) {
    if (number.length == 6 || number.length == 5) {
      String pCode = ussd['code'].replaceFirst('number', number);
      pCode = pCode.replaceFirst('amount', amount);
      return Uri.encodeComponent(pCode);
    }
    String pCode = ussd['mobile'].replaceFirst('number', number);
    pCode = pCode.replaceFirst('amount', amount);
    return Uri.encodeComponent(pCode);
  }

  @override
  String toString() {
    return '$code - $currency';
  }
}

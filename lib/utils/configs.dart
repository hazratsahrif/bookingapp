import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

const APP_NAME = 'T2';
const APP_NAME_TAG_LINE = 'طلب عامل او اكثر';
var defaultPrimaryColor = Color(0xFF020000);
var primaryColorDark = Colors.redAccent.shade400;

// var primaryColorDark = Colors.grey.shade700;

const DOMAIN_URL = 'https://t2jb.com';
// const DOMAIN_URL = 'https://accidentlawyersnearme.org';
const BASE_URL = '$DOMAIN_URL/api/';

const DEFAULT_LANGUAGE = 'ar';

/// You can change this to your Provider App package name
/// This will be used in Registered As Partner in Sign In Screen where your users can redirect to the Play/App Store for Provider App
/// You can specify in Admin Panel, These will be used if you don't specify in Admin Panel
const PROVIDER_PACKAGE_NAME = 'com.codearix.teto.provider';
const IOS_LINK_FOR_PARTNER =
    "https://apps.apple.com/in/app/handyman-provider-app/id1596025324";

const IOS_LINK_FOR_USER =
    'https://apps.apple.com/us/app/handyman-service-user/id1591427211';

const DASHBOARD_AUTO_SLIDER_SECOND = 5;

const TERMS_CONDITION_URL = 'https://t2jb.com/#/term-conditions';
const PRIVACY_POLICY_URL = 'https://t2jb.com/#/privacy-policy';
const INQUIRY_SUPPORT_EMAIL = 'info@t2jb.com';

/// You can add help line number here for contact. It's demo number
const HELP_LINE_NUMBER = '+15265897485';

/// STRIPE PAYMENT DETAIL
const STRIPE_MERCHANT_COUNTRY_CODE = 'EGY';
const STRIPE_CURRENCY_CODE = 'EGY';
DateTime todayDate = DateTime(2022, 8, 24);

/// SADAD PAYMENT DETAIL
const SADAD_API_URL = 'https://api-s.sadad.qa';
const SADAD_PAY_URL = "https://d.sadad.qa";

Country defaultCountry() {
  return Country(
    phoneCode: '20',
    countryCode: 'EGY',
    e164Sc: 20,
    geographic: true,
    level: 1,
    name: 'Egypt',
    example: '203007999662',
    displayName: 'Egypt (EGY) [+20]',
    displayNameNoCountryCode: 'Egypt (EGY)',
    e164Key: '20-EGY-0',
    fullExampleWithPlusSign: '+203007999662',
  );
}

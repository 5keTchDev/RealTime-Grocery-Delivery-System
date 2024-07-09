import 'dart:ui';

import 'package:flutter/material.dart';

import '../widgets/appbarCustom.dart';

class PrivacyPage extends StatelessWidget {
  static const routeName = '/privacy';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBarCustom(
            title: 'Privacy & Policy',
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: RichText(
                text: const TextSpan(
                    text: 'Terms & Conditions',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text:
                            '\n\nBy downloading or using the app, these terms will automatically '
                            'apply to you – you should make sure therefore that you read '
                            'them carefully before using the app. You’re not allowed to copy '
                            'or modify the app, any part of the app, or our trademarks in any way. '
                            'You’re not allowed to attempt to extract the source code of the app, '
                            'and you also shouldn’t try to translate the app into other languages or make'
                            ' derivative versions. The app itself, and all the trademarks, '
                            'copyright, database rights, and other '
                            'intellectual property rights related to it, still belong to Sabjitaja.\n'
                            'Sabjitaja is committed to ensuring that the app is as useful and efficient as possible. For that reason, we reserve the right to make changes to the app or to charge for its services, at any time and for any reason. We will never charge you for'
                            ' the app or its services without making '
                            'it very clear to you exactly what you’re paying for.\n'
                            'The Sabjitaja app stores and processes personal data that you have provided to us, to provide our Service. It’s your responsibility to keep your phone and access to the app secure. We therefore recommend that you do not jailbreak or root your phone, which is the process of removing software restrictions and limitations imposed by the official operating system of your device. It could make your phone vulnerable to malware/viruses/malicious programs, compromise your'
                            ' phone’s security features and it could mean '
                            'that the Sabjitaja app won’t work properly or at all.The app does use '
                            'third-party services that declare their Terms and Conditions. The app use services of firebase services.'
                            'You should be aware that there are certain things that Sabjitaja will not take responsibility for. Certain functions of the app will require the app to have an active internet connection. The connection can be Wi-Fi or provided by your mobile network provider, but Sabjitaja cannot take responsibility for the app not working at full functionality '
                            'if you don’t have access to Wi-Fi, and you don’t have any of your data allowance left.\n'
                            'If you’re using the app outside of an area with Wi-Fi, you should remember that the terms of the agreement with your mobile network provider will still apply. As a result, you may be charged by your mobile provider for the cost of data for the duration of the connection while accessing the app, or other third-party charges. In using the app, you’re accepting responsibility for any such charges, including roaming data charges if you use the app outside of your home territory (i.e. region or country) without turning off data roaming. If you are not the bill payer for the device on which you’re using the app, please be '
                            'aware that we assume that you have received '
                            'permission from the bill payer for using the app.'
                            'Along the same lines, Sabjitaja cannot always take responsibility for the way you use the app i.e. You need to make sure that your device stays charged – if it runs out of battery '
                            'and you can’t turn it on to avail the Service, Sabjitaja cannot accept responsibility.\n'
                            'With respect to Sabjitaja’s responsibility for your use of the app, when you’re using the app, it’s important to bear in mind that although we endeavor to ensure that it is updated and correct at all times, we do rely on third parties to provide information to us so that we can make it available to you. Sabjitaja accepts no liability for any loss, direct or '
                            'indirect, you experience as a result of relying wholly on this functionality of the app.\n'
                            'At some point, we may wish to update the app. The app is currently '
                            'available on Android – the requirements for the system(and for any'
                            ' additional systems we decide to extend the availability of the app to) '
                            'may change, and you’ll need to download the updates if you want to keep '
                            'using the app. Sabjitaja does not promise that it will always update the '
                            'app so that it is relevant to you and/or works with the Android version that you have installed on'
                            ' your device. However, you promise to always accept updates to '
                            'the application when offered to you, We may also wish to stop providing'
                            ' the app, and may terminate use of it at any time without giving notice '
                            'of termination to you. Unless we tell you otherwise, upon any termination, '
                            '(a) the rights and licenses granted to you in these terms will end;'
                            ' (b) you must stop using the app, and (if needed) delete it from your device.\n',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      TextSpan(
                        text: '\nChanges to This Terms and Conditions\n\n',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: 'We may update our Terms and Conditions '
                            'from time to time. Thus, you are'
                            ' advised to review this page periodically '
                            'for any changes. We will notify you of any changes '
                            'by posting the new Terms and Conditions on this page.'
                            'These terms and conditions are effective as of 2023-02-22',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      TextSpan(
                        text: '\n\nPrivacy Policy\n\n',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text:
                            'Sabjitaja built the Sabjitaja app as a Commercial app. This SERVICE is provided by Sabjitaja and is intended for use as is.'
                            'This page is used to inform visitors regarding our policies '
                            'with the collection, use, and disclosure of Personal Information if anyone decided to use our Service.'
                            'If you choose to use our Service, then you agree to the collection and '
                            'use of information in relation to this policy. The Personal Information that we collect is'
                            'used for providing and improving the Service. We will not use or '
                            'share your information with anyone except as described in this Privacy Policy.'
                            'The terms used in this Privacy Policy have the same meanings '
                            'as in our Terms and Conditions, which are accessible at '
                            'Sabjitaja unless otherwise defined in this Privacy Policy.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      TextSpan(
                        text: '\n\nInformation Collection and Use\n\n',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text:
                            'For a better experience, while using our Service, '
                            'we may require you to provide us with certain '
                            'personally identifiable information. The information that we '
                            'request will be retained by us and used as described in this privacy policy.'
                            'The app does use third-party services that may collect information used to identify you.\n'
                            'We value your trust in providing us your Personal Information, thus we are striving to use '
                            'commercially acceptable means of protecting it. But remember that no method of transmission over the internet,'
                            ' or method of electronic storage is 100% secure '
                            'and reliable, and we cannot guarantee its absolute security.\n'
                            'These Services do not address anyone under the age of 13. We do not knowingly collect '
                            'personally identifiable information from children under 13 years of age. '
                            'In the case we discover that a child under 13 has provided us with personal information,'
                            ' we immediately delete this from our servers. If you are a parent or guardian '
                            'and you are aware that your child has provided us '
                            'with personal information, please contact us so that we will be able to do the necessary actions.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      TextSpan(
                        text: '\n\nContact Us\n\n',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text:
                            'If you have any questions or suggestions about our Privacy Policy and terms,'
                            ' do not hesitate to contact us at sabjitaja23@gmail.com.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ]),
              )),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({
    super.key,
  });

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  Map<String, dynamic> myPackageData = {};

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((value) {
      myPackageData = value.data;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Center(
        child: Column(
          children: [
            // note for test
            // onLongPress: () async {
            //   final pending = await di<LocalNotificationService>().I.pendingNotificationRequests();
            //   final activate = await di<LocalNotificationService>().I.getActiveNotifications();

            //   testNotification(pending, activate);
            // },
            const Image(
              alignment: Alignment.center,
              image: AssetImage('assets/images/logo/logo_rmbg.png'),
              height: 64,
              semanticLabel: 'logo',
            ),
            Text(
              myPackageData['appName'] ?? '',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(myPackageData['version'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(myPackageData['packageName'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12.0),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Memo Planner is a simple and powerful application to manage your daily activities.',
                textAlign: TextAlign.center,
              ),
            ),
            // launch url button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Follow us on: '),
                IconButton(
                  icon: const Icon(
                    Icons.facebook,
                    color: Colors.blue,
                    size: 32.0,
                  ),
                  onPressed: () {
                    _launchUrl('https://www.facebook.com/page.MemoPlanner');
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Feedback: '),
                IconButton(
                  icon: const Icon(
                    Icons.email,
                    color: Colors.red,
                    size: 32.0,
                  ),
                  onPressed: () {
                    _mailTo();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> testNotification(
    List<PendingNotificationRequest> pending,
    List<ActiveNotification> activate,
  ) {
    return showDialog(
      context: context,
      builder: (_) {
        return SimpleDialog(
          children: [
            Text('pending: ${pending.length}'),
            for (int i = 0; i < pending.length; i++)
              Text(
                '${pending[i].id} - ${pending[i].title} - ${pending[i].body}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            Text('activate: ${activate.length}'),
            for (int i = 0; i < activate.length; i++)
              Text(
                '${activate[i].id} - ${activate[i].title} - ${activate[i].body}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        );
      },
    );
  }
}

Future<void> _launchUrl(String url) async {
  final Uri uri = Uri.parse(url);

  if (!await launchUrl(uri)) {
    throw Exception('Could not launch $uri');
  }
}

String? _encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

Future<void> _mailTo() async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'venh.ha@gmail.com',
    query: _encodeQueryParameters(<String, String>{
      'subject': '[Feedback] Memo Planner',
    }),
  );

  if (!await launchUrl(emailLaunchUri)) {
    throw Exception('Could not launch $emailLaunchUri');
  }
}

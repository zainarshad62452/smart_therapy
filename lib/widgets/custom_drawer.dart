import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_therapy/main.dart';
import '../providers/auth_provider.dart';
import '../screens/deprecated_user_account_screen.dart';
import '../screens/wip_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 200,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                // color: Theme.of(context).primaryColor,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    kMainColor,
                    kHintColor,
                  ],
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.accessibility_sharp,
                            size: 36,
                          ),
                          const SizedBox(width: 5.0),
                          Text(
                            'Smart Therapy',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        Provider.of<AuthProvider>(context).currentUser != null
                            ? '${Provider.of<AuthProvider>(context).currentUser!.displayName}!'
                            : 'Version 1.0.0',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // ListTile(
          //   onTap: () => {
          //
          //   },
          //   leading: const Icon(Icons.home, size: 24),
          //   title: Text(
          //     'Search',
          //     style: Theme.of(context).textTheme.bodyMedium,
          //   ),
          // ),
          ListTile(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserAccountScreen(),
                ),
              ),
            },
            leading: const Icon(Icons.accessibility, size: 24.0),
            title: Text(
              'My Exercises',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          ListTile(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WipScreen(
                    screenName: 'Settings Screen',
                  ),
                ),
              ),
            },
            leading: const Icon(Icons.settings, size: 24.0),
            title: Text(
              'Settings',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          ListTile(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WipScreen(
                    screenName: 'About Screen',
                  ),
                ),
              ),
            },
            leading: const Icon(Icons.info_outlined, size: 24.0),
            title: Text(
              'About',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

// import '../widgets/custom_text_button.dart';

class WipScreen extends StatefulWidget {
  final String screenName;

  const WipScreen({Key? key, required this.screenName}) : super(key: key);

  @override
  State<WipScreen> createState() => _WipScreenState();
}

class _WipScreenState extends State<WipScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Row(
                //   children: [
                //     CustomTextButton(
                //       onPressed: () => {
                //         Navigator.pop(context),
                //       },
                //       padding: const EdgeInsets.all(6.0),
                //       icon: Icons.arrow_back,
                //       iconSize: 28,
                //       borderRadius: 50,
                //     ),
                //   ],
                // ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.screenName,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No Data Available',
                      style: TextStyle(fontSize: 22),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

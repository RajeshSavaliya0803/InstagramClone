import 'package:flutter/material.dart';
import 'package:instragram_app/resources/auth_methods.dart';
import 'package:instragram_app/screens/login_screen.dart';
import 'package:instragram_app/utils/colors.dart';
import 'package:instragram_app/utils/utils.dart';
import 'package:instragram_app/widgets/text_field_input.dart';

class SettingsAndPrivacyScreen extends StatefulWidget {
  const SettingsAndPrivacyScreen({super.key});

  @override
  State<SettingsAndPrivacyScreen> createState() =>
      _SettingsAndPrivacyScreenState();
}

class _SettingsAndPrivacyScreenState extends State<SettingsAndPrivacyScreen> {
  @override
  void dispose() {
    _searchcontroller.dispose();
    super.dispose();
  }

  final TextEditingController _searchcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Settings and Privacy',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldInput(
                prefixIcon: const Icon(Icons.search, color: secondaryColor),
                hintText: 'Search',
                textInputType: TextInputType.text,
                textEditingController: _searchcontroller,
              ),
              const SizedBox(height: 15),
              const Text(
                "Your account",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: secondaryColor),
              ),
              const SizedBox(height: 10),
              accontcenter(),
              const SizedBox(height: 10),
              lernmoretxt(),
              const SizedBox(height: 10),
              const Text(
                "How you user Instagram",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: secondaryColor),
              ),
              const SizedBox(height: 10),
              notification(),
              const SizedBox(height: 10),
              const Text(
                "what you see",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: secondaryColor),
              ),
              const SizedBox(height: 10),
              whatyousee(),
              const SizedBox(height: 10),
              contentt(),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  await AuthMethods().signOut();
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  }
                },
                child: const Text(
                  "Sign Out",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: secondaryColor),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget accontcenter() {
    return Row(
      children: [
        const Icon(
          Icons.account_circle_outlined,
          color: primaryColor,
          size: 30,
        ),
        const SizedBox(width: 15),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Your account",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: primaryColor),
            ),
            Text(
              "password sedcurity,personal details,ads",
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w300,
                  color: secondaryColor),
            ),
          ],
        ),
        const Spacer(),
        const Icon(
          Icons.arrow_forward_ios_outlined,
          color: secondaryColor,
          size: 25,
        ),
      ],
    );
  }

  Widget lernmoretxt() {
    return RichText(
      text: const TextSpan(
        text: ' ',
        children: <TextSpan>[
          TextSpan(
            text:
                'Mange yourconnected experiences and account settings across Meta texhnologies',
            style:
                TextStyle(fontWeight: FontWeight.w300, color: secondaryColor),
          ),
          TextSpan(
            text: ' Learn more',
            style: TextStyle(fontWeight: FontWeight.w500, color: primaryColor),
          ),
        ],
      ),
    );
  }

  Widget notification() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: instgram.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Icon(instgram[index], color: primaryColor, size: 30),
              const SizedBox(width: 15),
              Text(
                instgramtext[index],
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: primaryColor),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios_outlined,
                color: secondaryColor,
                size: 25,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget whatyousee() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: whatyou.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Icon(whatyou[index], color: primaryColor, size: 30),
              const SizedBox(width: 15),
              Text(
                whatyoutext[index],
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: primaryColor),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios_outlined,
                color: secondaryColor,
                size: 25,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget contentt() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: content.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Icon(content[index], color: primaryColor, size: 30),
              const SizedBox(width: 15),
              Text(
                contenttext[index],
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: primaryColor),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios_outlined,
                color: secondaryColor,
                size: 25,
              ),
            ],
          ),
        );
      },
    );
  }
}

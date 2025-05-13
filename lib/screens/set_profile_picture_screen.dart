import 'package:flutter/material.dart';
import 'package:on_the_spot/providers/picture_provider.dart';
import 'package:provider/provider.dart';
import 'package:on_the_spot/models/message.dart';
import 'package:on_the_spot/models/profile_picture.dart';
import 'package:on_the_spot/providers/message_provider.dart';
import 'package:on_the_spot/providers/user_provider.dart';
import 'package:on_the_spot/widgets/text/body_text.dart';
import 'package:on_the_spot/widgets/buttons/button.dart';
import '/theme/app_colors.dart';
import 'base_screen.dart';

class SetProfilePictureScreen extends StatefulWidget {
  const SetProfilePictureScreen({super.key});

  @override
  SetProfilePictureScreenState createState() => SetProfilePictureScreenState();
}

class SetProfilePictureScreenState extends State<SetProfilePictureScreen> {
  List<ProfilePicture> _pictures = [];
  String? _selectedUrl;

  @override
  void initState() {
    super.initState();
    _loadPictures();
  }

  Future<void> _loadPictures() async {
    try {
      final pictureProvider = Provider.of<PictureProvider>(context, listen: false);
      await pictureProvider.fetchPictures();
      setState(() => _pictures = pictureProvider.pictures);
    } catch (e) {
      if (!mounted) return;
      final messageProvider = Provider.of<MessageProvider>(context, listen: false);
      messageProvider.addMessage(
        Message(
          content: e.toString(),
          type: MessageType.error,
        ),
      );
    }
  }

  Future<void> _setPicture() async {
    final messageProvider =
        Provider.of<MessageProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (_selectedUrl == null) return;
    try {
      await userProvider.updateProfile(profilePic: _selectedUrl!);
      messageProvider.addMessage(
        Message(
          content: 'Profile picture updated successfully!',
          type: MessageType.success,
        ),
      );

      userProvider.fetchProfile();
      if (userProvider.user?.name == null) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/set_name');
      } else {
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      messageProvider.addMessage(
        Message(
          content: e.toString(),
          type: MessageType.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      resizeToAvoidBottomInset: false,
      leading: null,
      actions: null,
      columnWidgets: [
        const Spacer(flex: 1),
        Expanded(
          flex: 3,
          child: LayoutBuilder(
            builder: (context, constraints) {
              double width = constraints.maxWidth;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 24),
                    child: BodyText(text: 'Choose a profile picture'),
                  ),
                  SizedBox(
                    width: width,
                    height: width,
                    child: GridView.builder(
                      itemCount: _pictures.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemBuilder: (context, index) {
                        final pic = _pictures[index];
                        final selected = pic.url == _selectedUrl;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedUrl = pic.url),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selected
                                    ? AppColors.lightGrey
                                    : Colors.transparent,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(90),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.network(
                                pic.url,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        Button(
          text: 'CONTINUE >',
          onPressed: _setPicture,
          backgroundColor: AppColors.primaryColor,
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

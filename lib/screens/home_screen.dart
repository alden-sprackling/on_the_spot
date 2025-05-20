import 'package:flutter/material.dart';
import 'package:on_the_spot/providers/tier_provider.dart';
import 'package:on_the_spot/providers/user_provider.dart';
import 'package:on_the_spot/theme/app_colors.dart';
import 'package:on_the_spot/widgets/bottom_popup.dart';
import 'package:on_the_spot/widgets/icons/user_icon_button.dart';
import 'package:on_the_spot/widgets/text/body_text.dart';
import 'package:on_the_spot/widgets/user_widget.dart';
import 'package:provider/provider.dart';
import 'base_screen.dart';
import 'play_screen.dart';
import 'rankings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  // Your two pages
  final List<Widget> _pages = [
    const PlayScreen(),
    ChangeNotifierProvider(
      create: (_) {
        final prov = TierProvider();
        prov.fetchTierStats();
        return prov;
      },
      child: const RankingsScreen(),
    ),
  ];

  void _onTap(int idx) => setState(() => _currentIndex = idx);

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      leadingWidth: 200,
      actions: [],
      leading: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          final user = userProvider.user;
          if (user == null) {
            return const SizedBox.shrink();
          }
          return UserIconButton(
            profilePic: user.profilePic!,
            name: user.name!,
            iq: user.iq,
            onPressed: () {
              BottomPopup.show(
                context: context,
                children: [
                  UserWidget(
                    onPictureTap: () => Navigator.pushNamed(
                      context,
                      '/set_profile_picture',
                      arguments: {'isEditing': true},
                    ),
                    onTextTap: () => Navigator.pushNamed(
                      context,
                      '/set_name',
                      arguments: {'isEditing': true},
                    ),
                  ),
                  BodyText(
                    text: 'Tap field to edit',
                    color: AppColors.lightGrey,
                  )
                ],
              );
            },
          );
        },
      ),
      // inject the current page’s content directly into BaseScreen’s body
      columnWidgets: [
        Expanded(child: _pages[_currentIndex]),
      ],
      mainAxisAlignment: MainAxisAlignment.start,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTap,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Play',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard),
              label: 'Rankings',
            ),
          ],
        ),
      ),
    );
  }
}

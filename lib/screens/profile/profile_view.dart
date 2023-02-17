import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/model/customer_profile.dart';
import 'package:wooapp/screens/auth/login.dart';
import 'package:wooapp/screens/auth/no_auth_screen.dart';
import 'package:wooapp/screens/gallery/gallery.dart';
import 'package:wooapp/screens/help/help_screen.dart';
import 'package:wooapp/screens/map/shop_map_screen.dart';
import 'package:wooapp/screens/orders/orders_screen.dart';
import 'package:wooapp/screens/profile/edit/profile_edit_screen.dart';
import 'package:wooapp/screens/profile/profile_cubit.dart';
import 'package:wooapp/screens/profile/profile_state.dart';
import 'package:wooapp/screens/profile/shipping/shipping_edit_screen.dart';
import 'package:wooapp/screens/settings/settings.dart';
import 'package:wooapp/screens/wishlist/wishlist_screen.dart';
import 'package:wooapp/widget/shimmer.dart';
import 'package:wooapp/widget/stateful_wrapper.dart';
import 'package:wooapp/widget/widget_woo_section.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StatefulWrapper(
      onInit: () {
        context.read<ProfileCubit>().getProfile();
      },
      child: Scaffold(
        backgroundColor: WooAppTheme.colorCommonBackground,
        body: BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            switch (state.runtimeType) {
              //ToDo ...
            }
          },
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              switch (state.runtimeType) {
                case InitialProfileState:
                  return _loadingState(context);
                case LoadingProfileState:
                  return _loadingState(context);
                case ContentProfileState:
                  return _contentState(context, (state as ContentProfileState).profile);
                case ErrorProfileState:
                  return _errorState();
                case NoAuthProfileState:
                  return _noAuth(context);
                default:
                  return _loadingState(context);
              }
            },
          ),
        ),
      ),
  );

  Widget _noAuth(BuildContext context) => NoAuthScreen(
        title: tr('tab_profile'),
        appBar: AppBar(
          title: Text(
            'tab_profile',
            style: TextStyle(
              color: WooAppTheme.colorToolbarForeground,
            ),
          ).tr(),
          leading: Icon(
            Icons.person,
            color: WooAppTheme.colorToolbarForeground,
          ),
          backgroundColor: WooAppTheme.colorToolbarBackground,
        ),
        onRefresh: () {
          Future.delayed(Duration(milliseconds: 200), () {
            context.read<ProfileCubit>().getProfile();
          });
        },
      );

  Widget _contentState(
    BuildContext context,
    CustomerProfile profile,
  ) => Scaffold(
    appBar: AppBar(
      title: Text(
        'tab_profile',
        style: TextStyle(
          color: WooAppTheme.colorToolbarForeground,
        ),
      ).tr(),
      leading: Icon(
        Icons.person,
        color: WooAppTheme.colorToolbarForeground,
      ),
      backgroundColor: WooAppTheme.colorToolbarBackground,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () {
            Navigator
              .push(context, MaterialPageRoute(builder: (_) => ProfileEditScreen()))
              .then((value) {
                if (value) {
                  context.read<ProfileCubit>().getProfile();
                }
                print('back, context = $context');
              });
          },
          icon: Icon(
            Icons.edit,
            color: WooAppTheme.colorToolbarForeground,
          ),
        ),
      ],
    ),
    backgroundColor: WooAppTheme.colorCommonBackground,
    body: SafeArea(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: WooAppTheme.colorToolbarBackground,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: [
                      Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.blueGrey,
                          radius: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            child: InkWell(
                              onTap: () => Navigator
                                  .of(context)
                                  .push(MaterialPageRoute(builder: (_) => GalleryScreen([profile.avatar]))),
                              child: CachedNetworkImage(
                                imageUrl: profile.avatar,
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => Shimmer(
                                  duration: Duration(seconds: 1),
                                  enabled: true,
                                  direction: ShimmerDirection.fromLTRB(),
                                  color: WooAppTheme.colorShimmerForeground,
                                  child: Container(
                                    color: WooAppTheme.colorShimmerBackground,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '${profile.username}',
                        style: TextStyle(
                          fontSize: 24,
                          color: WooAppTheme.colorToolbarForeground,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(height: 6),
                      Text(
                        '${profile.firstName} ${profile.lastName}',
                        style: TextStyle(
                          fontSize: 16,
                          color: WooAppTheme.colorToolbarForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ..._profileSections(context),
            ],
          ),
        ),
      ),
    )
  );

  Widget _loadingState(BuildContext context) =>
      ProfileShimmer(_profileSections(context));

  Widget _errorState() => Center(
        child: Text("Error"),
      );

  List<Widget> _profileSections(BuildContext context) => [
        SizedBox(height: 8),
        WooSection(
          icon: FaIcon(
            FontAwesomeIcons.locationDot,
            color: WooAppTheme.colorCommonSectionForeground,
          ),
          text: tr('shipping'),
          action: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ShippingEditScreen()),
          ).then((value) {
            if (value) {
              context.read<ProfileCubit>().getProfile();
            }
            print('back, context = $context');
          }),
        ),
        WooSection(
          icon: FaIcon(
            FontAwesomeIcons.gear,
            color: WooAppTheme.colorCommonSectionForeground,
          ),
          text: tr('settings'),
          action: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SettingsScreen()),
          ).then((value) {
            print('back, context = $context');
          }),
        ),
        SizedBox(height: 8),
        WooSection(
          icon: FaIcon(
            FontAwesomeIcons.heart,
            color: WooAppTheme.colorCommonSectionForeground,
          ),
          text: tr('wish_list'),
          action: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => WishListScreen()),
          ),
        ),
        WooSection(
          icon: FaIcon(
            FontAwesomeIcons.bagShopping,
            color: WooAppTheme.colorCommonSectionForeground,
          ),
          text: tr('orders'),
          action: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => OrdersScreen()),
          ),
        ),
        WooSection(
          icon: FaIcon(
            FontAwesomeIcons.ticketSimple,
            color: WooAppTheme.colorCommonSectionForeground,
          ),
          text: tr('coupons'),
          action: () {},
        ),
        SizedBox(height: 8),
        WooSection(
          icon: FaIcon(
            FontAwesomeIcons.map,
            color: WooAppTheme.colorCommonSectionForeground,
          ),
          text: tr('shops'),
          action: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ShopMap()),
          ),
        ),
        WooSection(
          icon: FaIcon(
            FontAwesomeIcons.circleQuestion,
            color: WooAppTheme.colorCommonSectionForeground,
          ),
          text: tr('help'),
          action: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => HelpScreen())),
        ),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            context.read<ProfileCubit>().logout();
          },
          child: Container(
            width: 90,
            alignment: Alignment.center,
            child: Text(
              'logout',
              style: TextStyle(
                fontSize: 16,
                color: WooAppTheme.colorDangerActionForeground,
              ),
            ).tr(),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              WooAppTheme.colorDangerActionBackground,
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(36.0),
                side: BorderSide(
                  color: WooAppTheme.colorDangerActionBackground,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
      ];
}

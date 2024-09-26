import 'package:flutter/material.dart';
import 'package:money_lover/common_widget/custom_arc_painter.dart';
import 'package:money_lover/common_widget/segment_button.dart';
import 'package:money_lover/common_widget/status_button.dart';
import 'package:money_lover/common_widget/subcription_home_row.dart';
import 'package:money_lover/common_widget/upcoming_view_row.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeViewState();
  }
}

class _HomeViewState extends State<HomeView> {
  int _currentPage = 0;
  final List<Widget> pages = [];

  bool isSubscription = true; // Trạng thái cho "Đăng Ký"
  bool isInvoice = false; // Trạng thái cho "Hóa Đơn"
  var media;
  List subArr = [
    {"Tên": "Spotify", "icon": "assets/img/spotify_logo.png", "Giá": "200"},
    {"Tên": "Youtube Pre", "icon": "assets/img/youtube_logo.png", "Giá": "200"},
    {"Tên": "OneDrive", "icon": "assets/img/onedrive_logo.png", "Giá": "200"},
    {"Tên": "Netflix", "icon": "assets/img/netflix_logo.png", "Giá": "200"},
  ];

  List bilArr = [
    {"Tên": "Spotify", "date": DateTime(2024, 08, 23), "Tổng": "200"},
    {"Tên": "Youtube Pre", "date": DateTime(2024, 08, 23), "Tổng": "200"},
    {"Tên": "OneDrive", "date": DateTime(2024, 08, 23), "Tổng": "200"},
    {"Tên": "Netflix", "date": DateTime(2024, 08, 23), "Tổng": "200"},
  ];

  @override
  Widget build(BuildContext context) {
    media = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _homeHeader(),
            _navBar(),
            if (isSubscription)
              ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: subArr.length,
                itemBuilder: (context, index) {
                  var sub = subArr[index] as Map? ?? {};

                  return SubScriptionHomeRow(
                    sub: sub,
                    onPressed: () {},
                  );
                },
              ),
            if (!isSubscription)
              ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: bilArr.length,
                itemBuilder: (context, index) {
                  var bil = bilArr[index] as Map? ?? {};

                  return UpcomingBillRow(
                    sub: bil,
                    onPressed: () {},
                  );
                },
              ),
            const SizedBox(
              height: 150,
            ),
          ],
        ),
      ),
    );
  }

  Widget _homeHeader() {
    final theme = Theme.of(context);
    return Container(
      height: media.width * 1.1,
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withOpacity(0.5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset("assets/img/home_bg.png"),
          Container(
            padding: EdgeInsets.only(bottom: media.width * 0.05),
            width: media.width * 0.7,
            height: media.width * 0.7,
            child: CustomPaint(
              painter: CustomArcPanter(),
            ),
          ),
          _spendingView(),
          _activeSub(),
        ],
      ),
    );
  }

  Widget _spendingView() {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          "assets/img/app_logo.png",
          width: media.width * 0.30,
          fit: BoxFit.contain,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          "\$1000",
          style: TextStyle(
            color: theme.textTheme.headlineLarge?.color,
            fontSize: 40,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.monthlySpending,
          style: TextStyle(
            color: theme.textTheme.bodyMedium?.color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.onSecondary.withOpacity(0.15),
              ),
              color: theme.colorScheme.secondary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              AppLocalizations.of(context)!.spendingView,
              style: TextStyle(
                color: theme.textTheme.bodyLarge?.color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _activeSub() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: StatusButton(
                  title: AppLocalizations.of(context)!.activeSubs,
                  value: "12",
                  statusColor: theme.colorScheme.primary,
                  onPressed: () {},
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: StatusButton(
                  title: AppLocalizations.of(context)!.lowestSubs,
                  value: "\$12",
                  statusColor: theme.colorScheme.secondary,
                  onPressed: () {},
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: StatusButton(
                  title: AppLocalizations.of(context)!.highestSubs,
                  value: "\$12",
                  statusColor: theme.colorScheme.tertiary,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navBar() {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      height: 50,
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: SegmentButton(
              title: AppLocalizations.of(context)!.subscription,
              isAcitive: isSubscription,
              onPressed: () {
                setState(() {
                  isSubscription = !isSubscription;
                  isInvoice = !isInvoice;
                });
              },
            ),
          ),
          Expanded(
            child: SegmentButton(
              title: AppLocalizations.of(context)!.invoice,
              isAcitive: isInvoice,
              onPressed: () {
                setState(() {
                  isSubscription = false;
                  isInvoice = true;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

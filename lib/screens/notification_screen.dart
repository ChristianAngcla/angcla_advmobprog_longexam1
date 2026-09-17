import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/notification.dart' as notif;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      width: ScreenUtil().screenWidth,
      child: ListView(
        padding: EdgeInsets.all(ScreenUtil().setSp(10)),
        children: const [
          notif.NotificationItem(
            name: 'Kaedehara Kazuha',
            post: 'LF MEMBERS FOR BOYHOOD',
            description:
                'Hello, Guys! Join kayo gc, lf members kami! Kulang pa 5 Boys',
            date: 'Just now',
            numOfLikes: 12,
            profileImageAsset: 'assets/images/kazuhaprofilepic.jpg',
          ),
          Divider(),

          notif.NotificationItem(
            name: 'Selena Quipao',
            post: 'LF MEMBERS FOR GirlHood',
            description: 'Where are the ladies, lf 7 girls',
            date: '5m ago',
            numOfLikes: 3,
            profileImageAsset: 'assets/images/selenaprofilepic.jpg',
          ),
          Divider(),

          notif.NotificationItem(
            name: 'Kite Kite',
            post: 'Happy Birthday, Ethan!',
            description:
                'Sorry bhie eff eff, hindi nakapuntaa! video call na lang gow',
            date: '10m ago',
            numOfLikes: 8,
            profileImageAsset: 'assets/images/kiteprofilepic.jpg',
          ),
          Divider(),

          notif.NotificationItem(
            name: 'Ovi Whamoz',
            post: 'LF Clients',
            description: 'Pa-henna na kau!!! ANO AYAW? TAPON KO TO!',
            date: '20m ago',
            numOfLikes: 21,
            profileImageAsset: 'assets/images/oviprofilepic.jpg',
          ),
          Divider(),

          notif.NotificationItem(
            name: 'DJ MOD KALKAL',
            post: 'ML +1 Mage',
            description:
                '+1 mage yung malakas tapos bonus kapag maganda tapos singkit na goth baddie',
            date: '30m ago',
            numOfLikes: 15,
            profileImageAsset: 'assets/images/dannielprofilepic.jpg',
          ),
          Divider(),

          notif.NotificationItem(
            name: 'Lizbeth ng Antipolo',
            post: 'Ano po pwedeng sakyan?',
            description:
                'HI PO GALING PO KASI AKONG ANTIPOLO, MAY SAKAYAN PO BA PA LEGARDA...',
            date: '1h ago',
            numOfLikes: 5,
            profileImageAsset: 'assets/images/lizbethprofilepic.jpg',
          ),
          Divider(),

          notif.NotificationItem(
            name: 'Daisy Anak ni Daisy',
            post: 'GUYS HINDI TO PYRAMIDING',
            description:
                'May 5k ka ba diyan? if meron, yang 5k mo gawin nating 5k ko.',
            date: '2h ago',
            numOfLikes: 42,
            profileImageAsset: 'assets/images/daisyprofilepic.jpg',
          ),
          Divider(),

          notif.NotificationItem(
            name: 'Lance Derek',
            post: 'Just Thinking',
            description:
                'Kung ang araw ay bilog, bakit siya ang isda...',
            date: '3h ago',
            numOfLikes: 6,
            profileImageAsset: 'assets/images/lanceprofilepic.jpg',
          ),
          Divider(),

          notif.NotificationItem(
            name: 'Leovik Samor',
            post: 'GACAD ASAN KA NA',
            description:
                'GACAD MAG ON KA NA, KANINA PA KAMI NASA LOBBY',
            date: '4h ago',
            numOfLikes: 9,
            profileImageAsset: 'assets/images/lanceprofilepic.jpg',
          ),
          Divider(),

          notif.NotificationItem(
            name: 'Rye David',
            post: 'I AM WRITING A NEW STORY',
            description:
                'Guys support my new story, if you like horror sci-fi genre...',
            date: 'Yesterday',
            numOfLikes: 18,
            profileImageAsset: 'assets/images/ryeprofilepic.jpg',
          ),
          Divider(),

          notif.NotificationItem(
            name: 'Dyan K',
            post: 'Akin lahat to?',
            description:
                'Shems sobrang ganda ng gf ko, akin lahat to?',
            date: 'Yesterday',
            numOfLikes: 11,
            profileImageAsset: 'assets/images/dyanprofilepic.jpg',
          ),
          Divider(),

          notif.NotificationItem(
            name: 'Julia Koi Fish Sa Kanal Ng Japan',
            post: 'Palarong Pambansa Appreciation',
            description:
                'Ako lang ba yung babaeng sobrang proud...',
            date: '2 days ago',
            numOfLikes: 27,
            profileImageAsset: 'assets/images/juliaprofilepic.jpg',
          ),
          Divider(),

          notif.NotificationItem(
            name: 'Ethan Angcla',
            post: 'To be loved, not to be lusted upon',
            description:
                'Not for desire that fades with night...',
            date: '2 days ago',
            numOfLikes: 33,
            profileImageAsset: 'assets/images/ethanprofilepic.jpg',
          ),
          Divider(),

          notif.NotificationItem(
            name: 'Mace Palakan',
            post: 'Kelan ba titigil tong ulan',
            description:
                'Guys kung sino man kumakanta pls pastop na...',
            date: '3 days ago',
            numOfLikes: 7,
            profileImageAsset: 'assets/images/mace_beastboy.jpg',
          ),
          Divider(),

          notif.NotificationItem(
            name: 'Caurie Sinaunang Hater ng Taga CAVSU',
            post: 'BAKIT MALI ANG MAGMAHAL NG TAGA CAVSU?',
            description:
                'Kasi parang instant noodles na walang itlog...',
            date: 'Last week',
            numOfLikes: 99,
            profileImageAsset: 'assets/images/caurieprofilepic.jpg',
          ),
          Divider(),
        ],
      ),
    );
  }
}

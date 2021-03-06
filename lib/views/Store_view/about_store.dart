import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/navigation_bloc.dart';
import 'package:locie/bloc/navigation_event.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/models/store.dart';
import 'package:locie/workers/sharing_wrokers.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreAboutWidget extends StatelessWidget {
  final Store store;
  final bool isEditable;
  StoreAboutWidget(this.store, {this.isEditable = false});

  void onEditClick(BuildContext context) {
    //(store.toString() + "as");
    BlocProvider.of<NavigationBloc>(context).push(NavigateToEditStore(store));
  }

  Icon ratingIcon(double rating) {
    if (rating >= 0 && rating <= 1.0) {
      return Icon(
        Icons.sentiment_very_dissatisfied,
        color: Colors.red,
      );
    } else if (rating >= 1 && rating <= 2) {
      return Icon(
        Icons.sentiment_dissatisfied,
        color: Colors.redAccent,
      );
    } else if (rating >= 3 && rating <= 4) {
      return Icon(
        Icons.sentiment_neutral,
        color: Colors.amber,
      );
    } else if (rating >= 4 && rating <= 5) {
      return Icon(
        Icons.sentiment_satisfied,
        color: Colors.lightGreen,
      );
    } else {
      return Icon(
        Icons.sentiment_very_satisfied,
        color: Colors.green,
      );
    }
  }

  Future<void> callStore() async {
    if (await canLaunch("tel:${store.contact}")) {
      await launch("tel:${store.contact}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screen = Scale(context);
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: screen.horizontal(4), vertical: screen.vertical(5)),
      child: ListView(
        shrinkWrap: true,
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Wrap(
                children: [
                  IconButton(
                      splashRadius: 4,
                      icon: Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        SharingWorkers().shareStore(store);
                      }),
                  if (isEditable)
                    IconButton(
                        splashRadius: 4,
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          onEditClick(context);
                        })
                ],
              )
            ],
          ),
          SizedBox(
            height: 8,
          ),
          LatoText(
            store.name,
            size: 28,
            style: FontStyle.normal,
            weight: FontWeight.w900,
          ),
          SizedBox(
            height: screen.vertical(20),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            ratingIcon(store.rating),
            SizedBox(
              width: screen.horizontal(2),
            ),
            LatoText('${store.rating.toStringAsFixed(1)} Rating', size: 18)
          ]),
          SizedBox(
            height: screen.vertical(20),
          ),
          RailwayText(
            store.description,
            size: 18,
          ),
          SizedBox(
            height: screen.vertical(30),
          ),
          LatoText(
            'Contact',
            size: 28,
            style: FontStyle.normal,
            weight: FontWeight.w900,
          ),
          SizedBox(
            height: screen.vertical(25),
          ),
          LatoText(
            store.address.body +
                ", " +
                store.address.city +
                "\n" +
                store.address.pinCode,
            size: 18,
          ),
          SizedBox(
            height: screen.vertical(25),
          ),
          InkWell(
            onTap: () {
              callStore();
            },
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                height: 26,
                width: 26,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/whatsapp_icon.png'))),
              ),
              SizedBox(
                width: screen.horizontal(2),
              ),
              LatoText(store.contact, size: 20)
            ]),
          ),
        ],
      ),
    );
  }
}

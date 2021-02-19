import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:locie/bloc/navigation_event.dart';
import 'package:locie/bloc/store_view_bloc.dart';
import 'package:locie/pages/navigation_track.dart';
import 'package:locie/pages/store_bloc_view.dart';
import 'package:locie/views/Store_view/store_widget.dart';

class DynamicLinksService {
  Uri generateLink({String store, String listing}) {
    var link = "https://tigrislocie/store?";
    if (store != null) {
      link += "storeId=$store";
    }
    if (listing != null) {
      link += "listingId=$listing";
    }
    return Uri.parse(link);
  }

  Future<Uri> createDynamicLink({String store, String listing}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://locie.page.link',
        link: generateLink(store: store, listing: listing),
        androidParameters: AndroidParameters(
            packageName: "com.bytatigris.locie", minimumVersion: 1));
    return await parameters.buildUrl();
  }

  Future<void> handleDynamicLink(BuildContext context) async {
    // await Firebase.initializeApp();
    final PendingDynamicLinkData dynamicLinkData =
        await FirebaseDynamicLinks.instance.getInitialLink();
    //(dynamicLinkData);
    if (dynamicLinkData != null) {
      await _handleDynamicLink(dynamicLinkData, context);
    }

    // Into foreground process
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      if (dynamicLink != null) {
        // //(object)
        await _handleDynamicLink(dynamicLink, context);
      }
    }, onError: (OnLinkErrorException e) async {
      //(e.message);
    });
  }

  Future<void> _handleDynamicLink(
      PendingDynamicLinkData data, BuildContext context) async {
    // Dynamic Link must should check for store, and product coded as(storeId and listingId)
    NavigationEvent event;
    bool storeIdInPath = data.link.query.contains("storeId");
    if (storeIdInPath) {
      String sid = data.link.queryParameters["storeId"];
      event = MaterialProviderRoute<StoreWidgetProvider>(
          route: StoreWidgetProvider(
        sid: sid,
      ));
      //(sid);
    } else if (data.link.query.contains("listingId")) {
      String lid = data.link.queryParameters['listingId'];
      event = LaunchItemView(lid);
    }
    if (event != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NavigationProvider(
                event: event,
              )));
    }
  }

  static Future<Uri> generateListingLink(String lid) async {
    DynamicLinksService service = DynamicLinksService();
    return await service.createDynamicLink(listing: lid);
  }

  static Future<Uri> generateStoreLink(String sid) async {
    DynamicLinksService service = DynamicLinksService();
    return await service.createDynamicLink(store: sid);
  }

  static String generateInvoiceLink(String sid) {
    String urlPrefix = "https://locie.page.link/jofZ";
    return urlPrefix + "?invoice=1";
  }
}

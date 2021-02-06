import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:locie/bloc/navigation_event.dart';
import 'package:locie/views/Store_view/store_view.dart';
import 'package:locie/views/Store_view/store_widget.dart';

class DynamicLinksService {
  NavigationEvent event = NavigateToHome();

  Future<void> handleDynamicLink() async {
    final PendingDynamicLinkData dynamicLinkData =
        await FirebaseDynamicLinks.instance.getInitialLink();

    if (dynamicLinkData != null) {
      await _handleDynamicLink(dynamicLinkData);
    }

    // Into foreground process
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      if (dynamicLink != null) {
        // print(object)
        await _handleDynamicLink(dynamicLink);
      }
    }, onError: (OnLinkErrorException e) async {
      print(e.message);
    });
  }

  Future<void> _handleDynamicLink(PendingDynamicLinkData data) async {
    // Dynamic Link must should check for store, and product coded as(storeId and listingId)

    bool storeIdInPath = data.link.pathSegments.contains("storeId");
    if (storeIdInPath) {
      String sid = data.link.queryParameters["storeId"];
      event = MaterialProviderRoute(route: StoreViewWidget(sid: sid));
      print(sid);
    } else if (data.link.pathSegments.contains("listingId")) {
      String lid = data.link.queryParameters['listingId'];
      event = MaterialProviderRoute(route: LaunchItemView(lid));
    }
  }

  Future<NavigationEvent> getDynamicEvent() async {
    await handleDynamicLink();
    return event;
  }

  static String generateListingLink(String lid) {
    String urlPrefix = "https://locie.page.link/jofZ";
    return urlPrefix + "?listingId=$lid";
  }

  static String generateStoreLink(String sid) {
    String urlPrefix = "https://locie.page.link/jofZ";
    return urlPrefix + "?storeId=$sid";
  }

  static String generateInvoiceLink(String sid) {
    String urlPrefix = "https://locie.page.link/jofZ";
    return urlPrefix + "?invoice=1";
  }
}

import 'package:locie/helper/dynamic_link_service.dart';
import 'package:locie/models/listing.dart';
import 'package:locie/models/store.dart';
import 'package:share/share.dart';

class SharingWorkers {
  Future<void> shareListing(Listing listing) async {
    String link =
        (await DynamicLinksService.generateListingLink(listing.id)).toString();
    String text =
        "${listing.storeName}'s product ${listing.name} can be found on\n $link";
    return Share.share(text, subject: listing.name + "- Shared");
  }

  Future<void> shareStore(Store store) async {
    String link =
        (await DynamicLinksService.generateStoreLink(store.id)).toString();
    String text = "${store.name} can be found easily on $link";
    return Share.share(text, subject: store.name + "- Shared");
  }

  Future<void> sendQuotation(Listing lid) async {}
}

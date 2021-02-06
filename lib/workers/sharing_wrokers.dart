import 'package:locie/helper/dynamic_link_service.dart';
import 'package:locie/models/invoice.dart';
import 'package:locie/models/listing.dart';
import 'package:locie/models/store.dart';
import 'package:share/share.dart';

class SharingWorkers {
  Future<void> shareListing(Listing listing) async {
    String link = DynamicLinksService.generateListingLink(listing.id);
    String text =
        "${listing.storeName}'s product ${listing.name} can be found on\n $link";
    return Share.share(text, subject: listing.name + "- Shared");
  }

  Future<void> shareStore(Store store) async {
    String link = DynamicLinksService.generateStoreLink(store.id);
    String text = "${store.name} can be found easily on $link";
    return Share.share(text, subject: store.name + "- Shared");
  }

  Future<void> sendQuotation(Listing lid) async {}
}

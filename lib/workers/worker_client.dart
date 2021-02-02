import 'package:url_launcher/url_launcher.dart';

class WorkerClient{

  Future<void> sendMessage(String phoneNumber, String data) async {
    String encoded = Uri.encodeFull(data);
    String url = "https://wa.me/${phoneNumber}?text=$encoded";
    if(await canLaunch(url)){
      await launch(url);
    }
  }
}
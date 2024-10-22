
import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils._();
  static Future<void> openMap(String location) async {
    String googleMapUrl =
        "https://www.google.com/maps/search/?api=1&query=$location";

    if (await launch(googleMapUrl)) {
      await launch(googleMapUrl);
    } else {
      throw 'Could not open the Maps';
    }
  }
}

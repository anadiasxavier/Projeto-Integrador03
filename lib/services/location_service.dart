import 'package:geolocator/geolocator.dart';

class LocationService {

  static Future<Position> getCurrentLocation() async {

    bool serviceEnabled;
    LocationPermission permission;

    // Verifica se GPS está ligado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('GPS desligado');
    }

    // Verifica permissão
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Permissão negada permanentemente');
    }

    return await Geolocator.getCurrentPosition();
  }
}
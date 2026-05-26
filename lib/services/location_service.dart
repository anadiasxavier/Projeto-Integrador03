import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // verifica se GPS está ligado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception('GPS desligado');
    }

    // verifica permissão atual
    permission = await Geolocator.checkPermission();

    // pede permissão se negada
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // usuário negou
    if (permission == LocationPermission.denied) {
      throw Exception('Permissão negada');
    }

    // negada permanentemente
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Permissão negada permanentemente');
    }

    // pega localização
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }
}

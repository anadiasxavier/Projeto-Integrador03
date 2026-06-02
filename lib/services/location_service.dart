import 'package:geolocator/geolocator.dart';

class LocationService {
  // localização única (mantém o que você já tinha)
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

    // pede permissão
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

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  // NOVO: localização em tempo real
  static Stream<Position> locationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // atualiza a cada 5 metros
      ),
    );
  }
}

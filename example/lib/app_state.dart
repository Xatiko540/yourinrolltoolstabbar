import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/lat_lng.dart';

class FFAppState {
  static final FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal() {
    initializePersistedState();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
  }

  late SharedPreferences prefs;

  DateTime? FechaNacimientoCero =
      DateTime.fromMillisecondsSinceEpoch(1649106000000);

  String GeneroVariableEstatica = '';

  String NumeroTelefonoVariableEstatica = '';

  String NumeroContactoVariableEstatica = '';

  String NombresVariableEstatica = '';

  String MarcaToyota = 'Toyota';

  List<String> MarcaAutomovil = ['Toyota', 'Chevrolet', 'Kia', 'Hyundai'];

  int Estrellas = 3;

  bool BanderaConductor = false;

  double BanderaSobreUsted = 0;

  double BanderaPreferenciasNecesidades = 0;

  double BanderaVerificacionIdentidad = 0;

  double BanderaNumeroTelefono = 1;

  double BanderaVerificacionCorreo = 1;

  double BanderaContactoEmergencia = 0;

  bool mostrarTodaLista = true;

  String DeDondeDescripcionLocalState = '';

  String HaciaDondeDescripcionLocalState = '';

  String DeDondeDireccionLocalState = '';

  String HaciaDondeDireccionLocalState = '';

  double BanderaAutomovilBuenasCondiciones = 0;

  double DeDondeLtLocalState = 0.0;

  double DeDondeLnLocalState = 0.0;

  double HaciaDondeLtLocalState = 0.0;

  double HaciaDondeLnLocalState = 0.0;

  String DeDondePiLocalState = '';

  String HaciaDondePiLocalState = '';

  String DeDondeDireccionPiLocalState = '';

  String HaciaDondeDireccionPiLocalState = '';

  DateTime? FechaViajeLocalState;

  double NumeroAsientosLocalState = 0.0;

  String MascotaLocalState = '';

  String FiestaLocalState = '';

  bool MascotaBLocalState = false;

  bool FiestaBLocalState = false;

  DateTime? FechaFilHoyLocalState;

  DateTime? FechaFilMananaLocalState;

  bool ManejoConMascotaLocalState = false;

  bool BanderaPasajero = false;

  double BanderaPrefConductor = 0.0;

  int CVOtraFormaLlegarLS = 0;

  int CVNoContactoConductorLS = 0;

  int CVCambioLugarEncuentroLS = 0;

  int SVConductorCanceloLS = 0;

  int CVOtroLS = 0;

  int CVCambioFechaHoraLS = 0;

  int CVErrorReservaLS = 0;

  bool BandeApagardeDonde = false;

  bool BandeApagarHaciaDonde = false;

  bool BanderaParaGuardarFotografia = false;

  bool BanderaEscogerManana = false;

  String CorreoConductorAceptarViaje = '';

  bool BanderaPagoTarjetaLS = false;

  DateTime? FechaOfertarViajeLS;

  double AsientosDisponiblesOfertarLS = 0.0;

  String CorreoPasajero1LS = 'null';

  String CorreoPasajero2LS = 'null';

  String CorreoPasajero3LS = 'null';

  DateTime? VLTLS = DateTime.fromMillisecondsSinceEpoch(1653820200000);

  String ParaBusquedaAlgolia = '';

  String FechaOfertarViajeStrLS = '';

  String FechaBuscarViajeStringLS = '';

  String ManejoConMascotaStrLS = '';

  String VoyConMascotaStrLS = '';

  double AsientosDisponiblesLS = 0.0;

  String MicorreoLS = '';

  String DisponibilidadAsientosLS = '';

  double AsientoqueNecesito = 1;

  String NombrePasajeroAd1LS = 'null';

  String ApellidoPasajeroAd1LS = 'null';

  DateTime? FNacimientoPasajeroAd1LS;

  String NEspecialesPasajeroAd1LS = 'null';

  String CorreoResponsablePasAd1LS = '';

  double CedulaPasajeroAdicional1LS = 1;

  String NombrePasajeroAd2LS = 'null';

  String ApellidoPasajeroAd2LS = 'null';

  DateTime? FNacimientoPasajeroAd2LS;

  String NEspecialesPasajeroAd2LS = 'null';

  String CorreoResponsablePasajeroAd2LS = 'null';

  double CedulaPasajeroAd2LS = 1;

  String TiempoActualString = '';

  int TiempoactualInt = 0;

  int FechaOfertarViajeIntLS = 0;

  String FechaMananaString = '';

  String VideoVerificacionIdentidadLS = '';

  double PrecioSistemaLS = 1;

  DateTime? FechayHoraFinalLS =
      DateTime.fromMillisecondsSinceEpoch(1656854040000);

  DateTime? TiempoEstimadoViajeLS =
      DateTime.fromMillisecondsSinceEpoch(1656854100000);

  int TiempoViajeIntLS = 0;

  double PrecioSugeridoLS = 0;

  double CalificacionUsuario1LS = 0.0;

  double NumeroUsoPasajero1LS = 0.0;

  bool BanderaViajeRegresoLS = false;

  DateTime? FechaHoraRegresoLS;

  double PrecioRegresoLS = 0.0;

  bool PermitirReservaDirectaLS = false;

  bool BanderaModoFiesta = true;

  bool BandejaPrimerUsoLS = true;

  String ComentarioPasajeroLS = '';

  bool BandCalifCondLS = false;

  String TelefonoEmergenciaLS = '';

  String MensajeEmergenciaLS = '';

  String EmergenciaWspConductor = '';

  String EmergenciaWspUsuario = '';

  String TelefonoPasajero1LS = '';

  String TelefonoPasajero2LS = '';

  String TelefonoPasajero3LS = '';

  String NombreCPasajero1LS = '';

  String NombreCPasajero2LS = '';

  String NombreCPAsajero3LS = '';

  String MiNombreCompletoLS = '';

  String MITelefonoLS = '';

  bool BanderaCalificacionPasajero = false;

  bool BanderaCalificacionConductor = false;

  DateTime? fechaparademo = DateTime.fromMillisecondsSinceEpoch(1660752000000);

  int fechaparademoint = 0;

  bool banderaDemo = false;

  LatLng? UbicacionActualLS;

  bool BanderaBusquedaManana = false;

  String DeDondeDescripcionRLS = '';

  String HaciaDondeDescripcionRLS = '';
}

LatLng? _latLngFromString(String? val) {
  if (val == null) {
    return null;
  }
  final split = val.split(',');
  final lat = double.parse(split.first);
  final lng = double.parse(split.last);
  return LatLng(lat, lng);
}

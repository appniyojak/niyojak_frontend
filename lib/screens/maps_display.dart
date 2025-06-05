import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../helpers/static_data.dart' as Statics;

class MapDisplay extends StatefulWidget {
  static const String routeName = '/view-shaakhaa-location';
  @override
  _MapDisplayState createState() => _MapDisplayState();
}

class _MapDisplayState extends State<MapDisplay> {
  bool _isfetingData = false;
  LatLng? CurLatLng;
  Set<Marker> _marker = {};
  BitmapDescriptor? mapMarkerFlag;
  BitmapDescriptor? mapMarkerPin;
  List<Statics.cLatLong> _latLong = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setIcon();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _latLong = ModalRoute.of(context)!.settings.arguments as List<Statics.cLatLong>;
    _populateMarkers();
  }

  void setIcon() async {
    var data = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'lib/assets/images/flag-20.png');
    var data1 = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'lib/assets/images/pin-20.png');
    setState(() {
      mapMarkerFlag = data;
      mapMarkerPin = data1;
    });
  }

  getUserLocation() async {
    if (await Permission.location.request().isGranted) {
      var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      if (!mounted) return;
      setState(() {
        CurLatLng = LatLng(position.latitude, position.longitude);
      });
    } else {
      if (!mounted) return;
      setState(() {
        CurLatLng = LatLng(19.115090744602714, 72.84809340602807);
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) async {
    await _populateMarkers();
  }

  _populateMarkers() async {
    _marker = {};
    await getUserLocation();
    Set<Marker> _mrkr = {};
    _mrkr.add(Marker(
        markerId: MarkerId('M-001'),
        icon: mapMarkerPin!,
        position: CurLatLng!,
        infoWindow: InfoWindow(title: Statics.userDetails["FullName"], snippet: 'Current Location')));

    if (_latLong.length > 0) {
      for (Statics.cLatLong latlng in _latLong) {
        _mrkr.add(Marker(
            markerId: MarkerId('M-' + latlng.shaakhaID.toString()),
            icon: mapMarkerFlag!,
            position: latlng.latlng,
            infoWindow: InfoWindow(title: latlng.shaakhaaName, snippet: latlng.description)));
      }
    }
    if (_mrkr.length > 0) {
      setState(() {
        _marker = _mrkr;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(Statics.getLabel('MapView')),
          ],
        ),
      ),
      body: CurLatLng != null ? GoogleMap(
        onMapCreated: _onMapCreated,
        markers: _marker,
        initialCameraPosition: CameraPosition(
          target: CurLatLng!,
          zoom: 15,
        ),
      ) : SizedBox(),
    );
  }
}

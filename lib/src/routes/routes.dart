// Autor: Javier Claros javiclaros@gmail.com

import 'package:flutter/material.dart';
import 'package:flutter_camera_hive/src/ui/form_ui.dart';
import 'package:flutter_camera_hive/src/ui/home_ui.dart';

Map<String, WidgetBuilder> getAppicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (_) => const MyHomePage(),
    'formulario': (_) => FormUi(),
    // 'notificationes-detalle': (_) => const NotificacionDetalle(),
  };
}

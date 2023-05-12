// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class AppLocalizations {
  AppLocalizations();

  static AppLocalizations? _current;

  static AppLocalizations get current {
    assert(_current != null,
        'No instance of AppLocalizations was loaded. Try to initialize the AppLocalizations delegate before accessing AppLocalizations.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<AppLocalizations> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = AppLocalizations();
      AppLocalizations._current = instance;

      return instance;
    });
  }

  static AppLocalizations of(BuildContext context) {
    final instance = AppLocalizations.maybeOf(context);
    assert(instance != null,
        'No instance of AppLocalizations present in the widget tree. Did you add AppLocalizations.delegate in localizationsDelegates?');
    return instance!;
  }

  static AppLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// `Administrador`
  String get admin {
    return Intl.message(
      'Administrador',
      name: 'admin',
      desc: '',
      args: [],
    );
  }

  /// `Error obteniendo los datos del administrador`
  String get adminRetrivingdataError {
    return Intl.message(
      'Error obteniendo los datos del administrador',
      name: 'adminRetrivingdataError',
      desc: '',
      args: [],
    );
  }

  /// `Cita almacenada exitosamente`
  String get appointmentStored {
    return Intl.message(
      'Cita almacenada exitosamente',
      name: 'appointmentStored',
      desc: '',
      args: [],
    );
  }

  /// `Disponible`
  String get avaliable {
    return Intl.message(
      'Disponible',
      name: 'avaliable',
      desc: '',
      args: [],
    );
  }

  /// `Cámara`
  String get camera {
    return Intl.message(
      'Cámara',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Cancelar`
  String get cancel {
    return Intl.message(
      'Cancelar',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Cancelar cita`
  String get cancelDate {
    return Intl.message(
      'Cancelar cita',
      name: 'cancelDate',
      desc: '',
      args: [],
    );
  }

  /// `Cambiar contraseña`
  String get changePassword {
    return Intl.message(
      'Cambiar contraseña',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Cambiar de estudio`
  String get changePlace {
    return Intl.message(
      'Cambiar de estudio',
      name: 'changePlace',
      desc: '',
      args: [],
    );
  }

  /// `Cambiar espacios`
  String get changePlacesQuantity {
    return Intl.message(
      'Cambiar espacios',
      name: 'changePlacesQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Cambiar de estudio`
  String get changesStudio {
    return Intl.message(
      'Cambiar de estudio',
      name: 'changesStudio',
      desc: '',
      args: [],
    );
  }

  /// `Nombre del cliente`
  String get clientName {
    return Intl.message(
      'Nombre del cliente',
      name: 'clientName',
      desc: '',
      args: [],
    );
  }

  /// `Teléfono del cliente`
  String get clientPhone {
    return Intl.message(
      'Teléfono del cliente',
      name: 'clientPhone',
      desc: '',
      args: [],
    );
  }

  /// `Confirmar`
  String get confirm {
    return Intl.message(
      'Confirmar',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Agendar`
  String get confirmDate {
    return Intl.message(
      'Agendar',
      name: 'confirmDate',
      desc: '',
      args: [],
    );
  }

  /// `Correo electrónico`
  String get email {
    return Intl.message(
      'Correo electrónico',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Tu correo electrónico ya se encuentra en uso`
  String get emailAlreadyInUse {
    return Intl.message(
      'Tu correo electrónico ya se encuentra en uso',
      name: 'emailAlreadyInUse',
      desc: '',
      args: [],
    );
  }

  /// `Hora de finalización`
  String get endHour {
    return Intl.message(
      'Hora de finalización',
      name: 'endHour',
      desc: '',
      args: [],
    );
  }

  /// `Ink Date {environment} {version}`
  String environment(String environment, String version) {
    return Intl.message(
      'Ink Date $environment $version',
      name: 'environment',
      desc: 'Information about App and Version',
      args: [environment, version],
    );
  }

  /// `Error al guardar datos de la cita.`
  String get errorStore {
    return Intl.message(
      'Error al guardar datos de la cita.',
      name: 'errorStore',
      desc: '',
      args: [],
    );
  }

  /// `Nombre completo`
  String get fullName {
    return Intl.message(
      'Nombre completo',
      name: 'fullName',
      desc: '',
      args: [],
    );
  }

  /// `Galería`
  String get gallery {
    return Intl.message(
      'Galería',
      name: 'gallery',
      desc: '',
      args: [],
    );
  }

  /// `¿Ya tienes una cuenta?`
  String get haveAnAccount {
    return Intl.message(
      '¿Ya tienes una cuenta?',
      name: 'haveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Aqui el nombre de tu cliente`
  String get hintClientName {
    return Intl.message(
      'Aqui el nombre de tu cliente',
      name: 'hintClientName',
      desc: '',
      args: [],
    );
  }

  /// `1234567890`
  String get hintClientPhone {
    return Intl.message(
      '1234567890',
      name: 'hintClientPhone',
      desc: '',
      args: [],
    );
  }

  /// `tuemail@email.com`
  String get hintEmail {
    return Intl.message(
      'tuemail@email.com',
      name: 'hintEmail',
      desc: '',
      args: [],
    );
  }

  /// `Aquí tu nombre`
  String get hintFullName {
    return Intl.message(
      'Aquí tu nombre',
      name: 'hintFullName',
      desc: '',
      args: [],
    );
  }

  /// `******`
  String get hintPassword {
    return Intl.message(
      '******',
      name: 'hintPassword',
      desc: '',
      args: [],
    );
  }

  /// `Estudio Best`
  String get hintPlaceName {
    return Intl.message(
      'Estudio Best',
      name: 'hintPlaceName',
      desc: '',
      args: [],
    );
  }

  /// `tu_estudio@gmail.com`
  String get hintStudioEmail {
    return Intl.message(
      'tu_estudio@gmail.com',
      name: 'hintStudioEmail',
      desc: '',
      args: [],
    );
  }

  /// `Imagen no seleccionada`
  String get imageNotPicked {
    return Intl.message(
      'Imagen no seleccionada',
      name: 'imageNotPicked',
      desc: '',
      args: [],
    );
  }

  /// `Iniciar sesión`
  String get login {
    return Intl.message(
      'Iniciar sesión',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Cerrar sesión`
  String get logout {
    return Intl.message(
      'Cerrar sesión',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Campo obligatorio`
  String get mandatoryField {
    return Intl.message(
      'Campo obligatorio',
      name: 'mandatoryField',
      desc: '',
      args: [],
    );
  }

  /// `Observaciones:`
  String get moreDetails {
    return Intl.message(
      'Observaciones:',
      name: 'moreDetails',
      desc: '',
      args: [],
    );
  }

  /// `* No hay observaciones adicionales`
  String get noAdditionalComments {
    return Intl.message(
      '* No hay observaciones adicionales',
      name: 'noAdditionalComments',
      desc: '',
      args: [],
    );
  }

  /// `Las contraseñas no coinciden`
  String get notMatchPassword {
    return Intl.message(
      'Las contraseñas no coinciden',
      name: 'notMatchPassword',
      desc: '',
      args: [],
    );
  }

  /// `Email no válido`
  String get notValidEmail {
    return Intl.message(
      'Email no válido',
      name: 'notValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Contraseña inválida`
  String get notValidPassword {
    return Intl.message(
      'Contraseña inválida',
      name: 'notValidPassword',
      desc: '',
      args: [],
    );
  }

  /// `Número de teléfono incorrecto`
  String get notValidPhone {
    return Intl.message(
      'Número de teléfono incorrecto',
      name: 'notValidPhone',
      desc: '',
      args: [],
    );
  }

  /// `Contraseña`
  String get password {
    return Intl.message(
      'Contraseña',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Tu contraseña debe tener 8 caracteres, mínimo 1 mayúscula, 1 minúscula y 1 número`
  String get passwordConditions {
    return Intl.message(
      'Tu contraseña debe tener 8 caracteres, mínimo 1 mayúscula, 1 minúscula y 1 número',
      name: 'passwordConditions',
      desc: '',
      args: [],
    );
  }

  /// `Seleccionar un horario`
  String get pickAnHour {
    return Intl.message(
      'Seleccionar un horario',
      name: 'pickAnHour',
      desc: '',
      args: [],
    );
  }

  /// `Seleccionar un espacio`
  String get pickAPlace {
    return Intl.message(
      'Seleccionar un espacio',
      name: 'pickAPlace',
      desc: '',
      args: [],
    );
  }

  /// `Elegir fecha`
  String get pickDate {
    return Intl.message(
      'Elegir fecha',
      name: 'pickDate',
      desc: '',
      args: [],
    );
  }

  /// `Elegir hora`
  String get pickHour {
    return Intl.message(
      'Elegir hora',
      name: 'pickHour',
      desc: '',
      args: [],
    );
  }

  /// `Elegir espacio de trabajo`
  String get pickPlace {
    return Intl.message(
      'Elegir espacio de trabajo',
      name: 'pickPlace',
      desc: '',
      args: [],
    );
  }

  /// `Foto`
  String get picture {
    return Intl.message(
      'Foto',
      name: 'picture',
      desc: '',
      args: [],
    );
  }

  /// `Nombre del estudio`
  String get placeName {
    return Intl.message(
      'Nombre del estudio',
      name: 'placeName',
      desc: '',
      args: [],
    );
  }

  /// `Espacios:`
  String get places {
    return Intl.message(
      'Espacios:',
      name: 'places',
      desc: '',
      args: [],
    );
  }

  /// `Recuperar contraseña`
  String get recoverPassword {
    return Intl.message(
      'Recuperar contraseña',
      name: 'recoverPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enviaremos un correo electrónico para el cambio de la contraseña`
  String get recoveryPasswordDescription {
    return Intl.message(
      'Enviaremos un correo electrónico para el cambio de la contraseña',
      name: 'recoveryPasswordDescription',
      desc: '',
      args: [],
    );
  }

  /// `Revisar Espacio`
  String get reviewSpace {
    return Intl.message(
      'Revisar Espacio',
      name: 'reviewSpace',
      desc: '',
      args: [],
    );
  }

  /// `Elegir fecha`
  String get selectDate {
    return Intl.message(
      'Elegir fecha',
      name: 'selectDate',
      desc: '',
      args: [],
    );
  }

  /// `Enviar`
  String get send {
    return Intl.message(
      'Enviar',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Enviaremos un correo electronico para la recuperacion de tu contrasena`
  String get sendEmailChangesPassword {
    return Intl.message(
      'Enviaremos un correo electronico para la recuperacion de tu contrasena',
      name: 'sendEmailChangesPassword',
      desc: '',
      args: [],
    );
  }

  /// `Registrarse`
  String get signUp {
    return Intl.message(
      'Registrarse',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Espacio`
  String get space {
    return Intl.message(
      'Espacio',
      name: 'space',
      desc: '',
      args: [],
    );
  }

  /// `Espacio no permitido, se encuentra ocupado`
  String get spaceIsOccupied {
    return Intl.message(
      'Espacio no permitido, se encuentra ocupado',
      name: 'spaceIsOccupied',
      desc: '',
      args: [],
    );
  }

  /// `Hora de inicio`
  String get startHour {
    return Intl.message(
      'Hora de inicio',
      name: 'startHour',
      desc: '',
      args: [],
    );
  }

  /// `Email del estudio asociado`
  String get studioEmail {
    return Intl.message(
      'Email del estudio asociado',
      name: 'studioEmail',
      desc: '',
      args: [],
    );
  }

  /// `Email de estudio no existe`
  String get studioEmailNotExist {
    return Intl.message(
      'Email de estudio no existe',
      name: 'studioEmailNotExist',
      desc: '',
      args: [],
    );
  }

  /// `¡Registro exitoso!`
  String get succesfullSignUp {
    return Intl.message(
      '¡Registro exitoso!',
      name: 'succesfullSignUp',
      desc: '',
      args: [],
    );
  }

  /// `Tu registro ha sido exitoso, te invitamos a ingresar a la App con tu correo y contraseña`
  String get succesfullSignUpMessage {
    return Intl.message(
      'Tu registro ha sido exitoso, te invitamos a ingresar a la App con tu correo y contraseña',
      name: 'succesfullSignUpMessage',
      desc: '',
      args: [],
    );
  }

  /// `Tatuador`
  String get tatooist {
    return Intl.message(
      'Tatuador',
      name: 'tatooist',
      desc: '',
      args: [],
    );
  }

  /// `Actualizar datos`
  String get updateData {
    return Intl.message(
      'Actualizar datos',
      name: 'updateData',
      desc: '',
      args: [],
    );
  }

  /// `Subir foto`
  String get uploadPicture {
    return Intl.message(
      'Subir foto',
      name: 'uploadPicture',
      desc: '',
      args: [],
    );
  }

  /// `Subir foto de perfil`
  String get uploadProfilePicture {
    return Intl.message(
      'Subir foto de perfil',
      name: 'uploadProfilePicture',
      desc: '',
      args: [],
    );
  }

  /// `Debes escoger mínimo una hora de diferencia.`
  String get validateDate {
    return Intl.message(
      'Debes escoger mínimo una hora de diferencia.',
      name: 'validateDate',
      desc: '',
      args: [],
    );
  }

  /// `La hora de finalización tiene que ser por lo menos una hora mayor a la hora de inicio.`
  String get validateHour {
    return Intl.message(
      'La hora de finalización tiene que ser por lo menos una hora mayor a la hora de inicio.',
      name: 'validateHour',
      desc: '',
      args: [],
    );
  }

  /// `Debes elegir un espacio para confirmar la cita.`
  String get validatePickPlace {
    return Intl.message(
      'Debes elegir un espacio para confirmar la cita.',
      name: 'validatePickPlace',
      desc: '',
      args: [],
    );
  }

  /// `Verificar contraseña`
  String get verifyPassword {
    return Intl.message(
      'Verificar contraseña',
      name: 'verifyPassword',
      desc: '',
      args: [],
    );
  }

  /// `Usuario y/o contraseña incorrectos`
  String get wrongUserOrPassword {
    return Intl.message(
      'Usuario y/o contraseña incorrectos',
      name: 'wrongUserOrPassword',
      desc: '',
      args: [],
    );
  }

  /// `Tu cita se ha agendado exitosamente.`
  String get yourAppointment {
    return Intl.message(
      'Tu cita se ha agendado exitosamente.',
      name: 'yourAppointment',
      desc: '',
      args: [],
    );
  }

  /// `Tus citas`
  String get yourDates {
    return Intl.message(
      'Tus citas',
      name: 'yourDates',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'es', countryCode: 'CO'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}

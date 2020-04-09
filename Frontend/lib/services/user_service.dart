import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:strongr/utils/global.dart' as global;

class UserService {
  /// [POST] /checkEmail
  ///
  /// Vérifie la disponibilité de l'e-mail [email].
  static Future<int> postCheckEmail({@required String email}) async {
    try {
      Response response = await http.post(
          Uri.encodeFull(
            global.SERVER_URL + '/checkEmail',
          ),
          body: {
            'email': email,
          });
      return response.statusCode;
    } catch (e) {
      return 503;
    }
  }

  /// [POST] /user/add
  ///
  /// Crée l'utilisateur avec les attributs [email], [password], [firstname], [lastname], [birthdate], [phonenumber] et [username].
  static Future<int> postSignIn({
    @required String email,
    @required String password,
    @required String firstname,
    @required String lastname,
    @required String birthdate,
    @required String phonenumber,
    @required String username,
  }) async {
    try {
      Response response = await http.post(
          Uri.encodeFull(
            global.SERVER_URL + '/user/add',
          ),
          body: {
            'email': email,
            'password': password,
            'firstname': firstname,
            'lastname': lastname,
            'birthdate': birthdate,
            'phonenumber': phonenumber,
            'username': username,
          });
      return response.statusCode;
    } catch (e) {
      return 503;
    }
  }

  /// [GET] /user/[id] - TODO
  ///
  /// Retourne l'utilisateur [id].
  static Future<dynamic> getUser({@required int id}) async {
    Response response = await http.get(
      Uri.encodeFull(
        global.SERVER_URL + '/user/' + id.toString(),
      ),
    );
    if (response.statusCode == 200) {
      return '';
    } else
      throw HttpException('');
  }

  /// [PUT] /user/update/[id] - TODO
  ///
  /// Modifie l'utilisateur [id].
  static Future<int> putUser({@required int id}) async {
    Response response = await http.put(
        Uri.encodeFull(
          global.SERVER_URL + '/user/update/' + id.toString(),
        ),
        body: {
          '': '',
        });
    if (response.statusCode == 200) {
      return 0;
    } else
      throw HttpException('');
  }

  /// [DELETE] /user/delete/[id] - TODO
  ///
  /// Supprime l'utilisateur [id].
  static Future<int> deleteUser({@required int id}) async {
    Response response = await http.delete(
      Uri.encodeFull(
        global.SERVER_URL + '/user/delete/' + id.toString(),
      ),
    );
    if (response.statusCode == 200) {
      return 0;
    } else
      throw HttpException('');
  }

  /// [POST] /login
  ///
  /// Demande la connexion de l'utilisateur [connectId] avec le mot de passe [password].
  static Future<int> postLogIn({
    @required String connectId,
    @required String password,
  }) async {
    try {
      Response response = await http.post(
          Uri.encodeFull(
            global.SERVER_URL + '/login',
          ),
          body: {
            'connectId': connectId,
            'password': password,
          });
      if (response.statusCode == 200)
        // global.token = response.headers['authorization'];
        global.token = response.body;
      return response.statusCode;
    } catch (e) {
      return 503;
    }
  }

  /// [POST] /logout - TODO
  ///
  /// Demande la déconnexion d'un utilisateur.
  static Future<int> postLogOut() async {
    Response response = await http.post(
        Uri.encodeFull(
          global.SERVER_URL + '/logout',
        ),
        body: {
          '': '',
        });
    if (response.statusCode == 200) {
      return 0;
    } else
      throw HttpException('');
  }

  /// [POST] /sendCode - TODO
  ///
  /// Envoie le code à l'adresse [email].
  static Future<int> postSendCode({@required String email}) async {
    Response response = await http.post(
        Uri.encodeFull(
          global.SERVER_URL + '/sendCode',
        ),
        body: {
          '': '',
        });
    if (response.statusCode == 200) {
      return 0;
    } else
      throw HttpException('');
  }

  /// [POST] /checkCode - TODO
  ///
  /// Envoie le code [code].
  static Future<int> postCheckCode({@required String code}) async {
    Response response = await http.post(
        Uri.encodeFull(
          global.SERVER_URL + '/checkCode',
        ),
        body: {
          '': '',
        });
    if (response.statusCode == 200) {
      return 0;
    } else
      throw HttpException('');
  }

  /// [PUT] /resetPassword - TODO
  ///
  /// Modifie le mot de passe de l'utilisateur [email] avec le nouveau mot de passe [password].
  static Future<int> putResetPassword(
      {@required String email, String password}) async {
    Response response = await http.put(
        Uri.encodeFull(
          global.SERVER_URL + '/resetPassword',
        ),
        body: {
          '': '',
        });
    if (response.statusCode == 200) {
      return 0;
    } else
      throw HttpException('');
  }
}
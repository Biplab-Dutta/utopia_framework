// import 'dart:io';
import 'dart:io';

import 'package:utopia_dart_framework/src/validation_exception.dart';
import 'package:utopia_dart_framework/src/validators/text.dart';
import 'package:utopia_dart_framework/utopia_dart_framework.dart';

void initApp(App app) {
  app.error().inject('error').inject('response').action((params) {
    final error = params['error'];
    final response = params['response'];
    if (error is ValidationException) {
      response.status = 400;
      response.body = error.message;
    }
    return response;
  });
  app.get('/hello').inject('request').inject('response').action((params) {
    params['response'].text('Hello World!');
    return params['response'];
  });

  app
      .get('/users/:userId')
      .param(
          key: 'userId',
          validator: Text(length: 10),
          defaultValue: '',
          description: 'Users unique ID')
      .inject('response')
      .action((params) {
    params['response'].text(params['userId']);
    return params['response'];
  });

  app
      .post('/users')
      .param(key: 'userId')
      .param(key: 'name')
      .param(key: 'email')
      .inject('response')
      .inject('request')
      .action((params) {
    params['response'].json({
      "userId": params['userId'],
      "email": params['email'],
      "name": params['name']
    });
    return params['response'];
  });
}

Future<HttpServer> defaultServer() async {
  final app = App();
  initApp(app);
  return app.serve(DefaultServer('localhost', 3030));
}

Future<HttpServer> shelfServer() async {
  final app = App();
  initApp(app);
  return app.serve(ShelfServer('localhost', 3030));
}

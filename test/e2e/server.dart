// import 'dart:io';
import 'package:utopia_dart_framework/src/validation_exception.dart';
import 'package:utopia_dart_framework/src/validators/text.dart';
import 'package:utopia_dart_framework/utopia_dart_framework.dart';

void main() async {
  App.error(
      callback: (params) {
        final error = params['error'];
        final response = params['response'];
        if (error is ValidationException) {
          response.status = 400;
          response.body = error.message;
        }
        return response;
      },
      resources: ['response']);
  App.get('/hello').inject('request').inject('response').action((params) {
    params['response'].text('Hello World!');
    return params['response'];
  });

  App.get('/users/:userId')
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

  App.post('/users')
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

  final app = App.serve(ShelfServer('localhost', 3030));

  // final server = await HttpServer.bind('localhost', 3030);
  // await server.forEach((HttpRequest request) async {
  //   final headers = <String, String>{};
  //   final headersAll = <String, List<String>>{};
  //   request.headers.forEach((name, values) {
  //     headersAll[name] = values;
  //     headers[name] = values.join(',');
  //   });
  //   final req = Request(request.method, request.uri,
  //       headers: headers,
  //       headersAll: headersAll,
  //       contentType: request.headers.value(HttpHeaders.contentTypeHeader),
  //       body: request);
  //   final res = await App().run(req);
  //   request.response.statusCode = res.status;
  //   res.headers.forEach((name, value) {
  //     request.response.headers.set(name, value);
  //   });
  //   request.response.write(res.body);
  //   request.response.close();
  // });
}

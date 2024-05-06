import 'package:dio/dio.dart';
import 'package:sharara_apps_building_helpers/src/Functions/helper.dart';

class ShararaHttp {
  static Future<Response?> get({required final String url,
    final Map<String,String>? headers,
    final Options? options,
    Object? data,
    final Function(int,int)? onReceiveProgress,
    CancelToken? cancelToken,
    Map<String, dynamic>? queryParameters,
    final Function(dynamic)? onError,
  })async {
    final Dio dio = Dio();
    final Response? response = await FunctionHelpers.tryFuture<Response>(dio.get(url,
        options: options ?? Options(
          headers:headers
        ),
        data:data,
        queryParameters:queryParameters,
        cancelToken:cancelToken,
        onReceiveProgress:onReceiveProgress,
    ),
      onError:onError
    );
    return response;
  }


  static Future<Response?> post({required final String url,
    final Map<String,String>? headers,
    final Options? options,
    Object? body,
    final Function(int,int)? onReceiveProgress,
    CancelToken? cancelToken,
    Map<String, dynamic>? queryParameters,
    final Function(dynamic)? onError,
  })async {
    final Dio dio = Dio();
    final Response? response = await FunctionHelpers.tryFuture<Response>(dio.post(url,
      options: options ?? Options(
          headers:headers,
      ),
      queryParameters:queryParameters,
      cancelToken:cancelToken,
      data:body,
      onReceiveProgress:onReceiveProgress,
    ),
        onError:onError
    );
    return response;
  }
}
import 'package:dio/dio.dart';
import 'package:sharara_apps_building_helpers/src/Functions/helper.dart';
export 'package:dio/dio.dart' show Options,Dio,Response,CancelToken,ProgressCallback,FormData,MultipartFile;

class ShararaHttp {
   static Map<String,dynamic> _defaultHeaders =  {};
   static Future<Map<String,dynamic>> Function(Map<String,dynamic>)? queryMapFilter;
   static Future<Object> Function(Object)? dataMapFilter;
   static Map<String,dynamic>? Function(Map<String,dynamic>)? onGetHeadersInvoked;
   static Map<String,dynamic> get defaultHeaders {
     if(onGetHeadersInvoked!=null){
       final Map<String,dynamic>? headers = onGetHeadersInvoked!(_defaultHeaders);
       if(headers!=null)return headers;
     }
     return _defaultHeaders;
   }
   static set defaultHeaders(final Map<String,dynamic> value){
     _defaultHeaders = value;
   }

   Future<T?> Function<T>(Response)? onResponseReady;

   ShararaHttp({this.onResponseReady});
   Future<T?> get<T>({required final String url,
    final Map<String,String>? headers,
    final Options? options,
    Object? data,
    final Function(int,int)? onReceiveProgress,
    CancelToken? cancelToken,
    Map<String, dynamic>? queryParameters,
    final Function(dynamic)? onError,
    final T? Function(Response)? resultBuilder,
    final bool withLoading = false,
  })async {
    final Dio dio = Dio();
    final Response? response = await FunctionHelpers.tryFuture<Response>(dio.get(url,
        options: options ?? Options(
          headers:headers??defaultHeaders
        ),
        data:data,
        queryParameters:queryParameters,
        cancelToken:cancelToken,
        onReceiveProgress:onReceiveProgress,
    ),
      withLoading:withLoading,
      onError:onError
    );
    if(response!=null && onResponseReady!=null && response is! T){
      return onResponseReady!(response);
    }
    return response as T?;
  }


   Future<T?> post<T>({required final String url,
    final Map<String,String>? headers,
    final Options? options,
    Object? data,
    final Function(int,int)? onReceiveProgress,
    CancelToken? cancelToken,
    Map<String, dynamic>? queryParameters,
    final Function(dynamic)? onError,
    final T? Function(Response)? responseBuilder,
    final bool withLoading = false,
  })async {
    final Dio dio = Dio();
    if (queryParameters!=null && queryMapFilter!=null) {
      queryParameters = await queryMapFilter!(queryParameters!);
    }
    if( data != null && dataMapFilter!=null){
      data = await dataMapFilter!(data!);
    }
    final Response? response = await FunctionHelpers.tryFuture<Response>(dio.post(url,
      options: options ?? Options(headers:headers??defaultHeaders),
      queryParameters:queryParameters,
      cancelToken:cancelToken,
      data:data,
      onReceiveProgress:onReceiveProgress,
    ),
        withLoading:withLoading,
        onError:onError
    );

    if(response!=null ){
      if(responseBuilder!=null)responseBuilder(response);
      if( onResponseReady!=null && response is! T) return onResponseReady!(response);
    }
    return response as T?;
  }
}
import 'package:dio/dio.dart';

class HttpTools {
  static HttpTools instance = new HttpTools();

  late BaseOptions _options;

  late Dio _dio;

  String baseUrl = "http://192.168.4.1";

  CancelToken cancelToken = new CancelToken();

  // static HttpTools getInstance() {
  //   if (null == instance) instance = new HttpTools();
  //   return instance;
  // }

  /*
   * config it and create
   */
  HttpTools(){
    //BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    _options = new BaseOptions(
      //请求基地址,可以包含子路径
      baseUrl: "http://192.168.4.1",
      //连接服务器超时时间，单位是毫秒.
      connectTimeout: 10000,
      //响应流上前后两次接受到数据的间隔，单位为毫秒。
      receiveTimeout: 10000,
      //Http请求头.
      headers: {
      },
      //请求的Content-Type，默认值是[ContentType.json]. 也可以用ContentType.parse("application/x-www-form-urlencoded")
      contentType: 'json',
      //表示期望以那种格式(方式)接受响应数据。接受4种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
      responseType: ResponseType.json,
    );

    _dio = new Dio(_options);

    //Cookie管理
//    Api.cookieJar.then((data){
//      dio.interceptors.add(CookieManager(data));
//    });

    //添加拦截器
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
      print("请求之前");
      print("请求的路径:"+options.path);

      // Api.cookieJar.then((data){
      //   var xsrfToken = data.loadForRequest(Uri.parse("https://cangku.one"));
      //   if(xsrfToken.length != 0){
      //     options.headers['cookie'] = getCookies(xsrfToken);
      //     for(var item in xsrfToken){
      //       if(item.name == 'XSRF-TOKEN'){
      //         options.headers['x-xsrf-token'] = Uri.decodeComponent(item.value);
      //         print('当前请求的xsrf-token======'+options.headers['x-xsrf-token']);
      //
      //       }
      //     }
      //   }
      //   print('当前请求的xsrf-token======000000000000');
      //   return options;
      // });
      //continue
    }, onResponse: (Response response, ResponseInterceptorHandler handler) {
      print("响应之前");

      // Api.cookieJar.then((data){
      //   _saveCookies(response, data);
      // });


      // return response; // continue
    }, onError: (DioError e, ErrorInterceptorHandler handler) {
      print("错误之前");
      // Do something with response error
      // return e; //continue
    }));


  }

  /*
   * get请求
   */
  get(url, {data, options, cancelToken}) async {
    Response response;
    try {
      response = await _dio.get(baseUrl+url, queryParameters: data, options: options, cancelToken: cancelToken);
      print('get success---------${response.data}');
      return response.data;

    } on DioError catch (e) {
      print('get error---------$e');
//      formatError(e);
      return null;
    }


  }

  /*
   * post请求
   */
  post(url, {data, options, cancelToken}) async {
    late Response response;
    try {
      response = await _dio.post(baseUrl+url, queryParameters: data, options: options, cancelToken: cancelToken);
      print('post success---------${response.data}');
    } on DioError catch (e) {
      print('post error---------$e');
      formatError(e);
    }

    if(response.data != null && response.data['status_code'] == 200){
      return response.data['data'];
    }else{
      return {};
    }
  }


  /*
   * error统一处理
   */
  void formatError(DioError e) {
    if (e.type == DioErrorType.connectTimeout) {
      // It occurs when url is opened timeout.
      print("连接超时");
    } else if (e.type == DioErrorType.sendTimeout) {
      // It occurs when url is sent timeout.
      print("请求超时");
    } else if (e.type == DioErrorType.receiveTimeout) {
      //It occurs when receiving timeout
      print("响应超时");
    } else if (e.type == DioErrorType.response) {
      // When the server response, but with a incorrect status, such as 404, 503...
      print("出现异常");
    } else if (e.type == DioErrorType.cancel) {
      // When the request is cancelled, dio will throw a error with this type.
      print("请求取消");
    } else {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      print("未知错误===="+e.toString());
    }
  }

  /*
   * 取消请求
   *
   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }

  /**
   * 保存cookie
   */
  // _saveCookies(Response response, CookieJar cookieJar) {
  //   if (response != null && response.headers != null) {
  //     List<String> cookies = response.headers[HttpHeaders.setCookieHeader];
  //     if (cookies != null) {
  //       cookieJar.saveFromResponse(
  //         response.request.uri,
  //         cookies.map((str) => Cookie.fromSetCookieValue(str)).toList(),
  //       );
  //     }
  //   }
  // }


  /**
   *  获取cookie
   */
  // getCookies(List<Cookie> cookies) {
  //   return cookies.map((cookie) => "${cookie.name}=${cookie.value}").join('; ');
  // }

}
import 'dart:convert';

Result resultFromJson(String str) => Result.fromJson(json.decode(str));

String resultToJson(Result data) => json.encode(data.toJson());

class Result {
  Result({
    required this.code,
    required this.message,
    required this.result,
  });

  int code;
  String message;
  Map result;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    result: json["result"] == null ? {} : json["result"],
  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "message": message == null ? null : message,
    "result": result == null ? null : result,
  };
}

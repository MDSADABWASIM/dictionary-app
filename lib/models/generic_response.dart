import 'dart:convert';

GenericResponse genericResponseFromMap(String str) => GenericResponse.fromMap(json.decode(str));

String genericResponseToMap(GenericResponse data) => json.encode(data.toMap());

class GenericResponse<T>{
    GenericResponse({
        this.results,
        this.success,
        this.message,
    });

    T? results;
    bool? success;
    String? message;

    factory GenericResponse.fromMap(Map<String, dynamic> json) => GenericResponse(
        results: json["results"],
        success: json["success"],
        message: json["message"],
    );

    Map<String, dynamic> toMap() => {
        "results": results,
        "success": success,
        "message": message,
    };
}

class ApiResponse{
  final bool hasError;
  final int statusCode;
  final dynamic data;
  final String errorMessage;
  ApiResponse({this.data,this.statusCode,this.hasError,this.errorMessage});
}
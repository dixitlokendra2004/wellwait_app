class Success {
  int code;
  Object response;

  Success(this.code, this.response);
}

class Failure {
  int code;
  String errorResponse;

  Failure(this.code, this.errorResponse);
}

class InsertExceprion implements Exception {
  String insertTarget;
  String errorInfo;

  InsertExceprion(this.insertTarget, this.errorInfo);
}

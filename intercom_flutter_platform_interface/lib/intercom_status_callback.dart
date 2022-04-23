class IntercomStatusCallback {
  /// callback when intercom operation is failed.
  /// will contain the error information.
  final Function(IntercomError error)? onFailure;

  /// callback when intercom operation is success.
  final Function()? onSuccess;

  /// class for intercom status to check if the operation is success or failure.
  /// if the operation failed then [onFailure] callback will be executed with
  /// [IntercomError] details.
  ///
  IntercomStatusCallback({
    this.onSuccess,
    this.onFailure,
  });
}

class IntercomError {
  /// error code
  final int errorCode;

  /// error message
  final String errorMessage;

  /// class for the Intercom error data.
  IntercomError(this.errorCode, this.errorMessage);

  @override
  String toString() {
    return ("errorCode: $errorCode, errorMessage: $errorMessage");
  }
}

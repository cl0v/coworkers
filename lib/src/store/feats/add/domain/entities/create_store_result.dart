enum StoreCreationStatus {
  created,
  duplicated,
  error;
}

class CreateStoreResult {
  final StoreCreationStatus status;
  final dynamic value;
  final String? message;

  CreateStoreResult({
    required this.value,
    required this.status,
    this.message,
  });
}
class ServerException implements Exception {
  final String message;
  const ServerException({this.message = 'A server error occurred.'});

  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {
  final String message;
  const CacheException({this.message = 'A cache error occurred.'});

  @override
  String toString() => 'CacheException: $message';
}

class LocalDatabaseException implements Exception {
  final String message;
  const LocalDatabaseException({this.message = 'A local database error occurred.'});

  @override
  String toString() => 'LocalDatabaseException: $message';
}

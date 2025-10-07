abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  // ignore: use_super_parameters
  const ServerFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  // ignore: use_super_parameters
  const CacheFailure(String message) : super(message);
}
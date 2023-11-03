/// - [T] is the wanted return type of the use case.
/// - [Params] is the parameters that the use case needs to run.
abstract class UseCaseWithParams<T, Params> {
  T call(Params params);
}

/// [T] is the return type of the use case.
abstract class UseCaseNoParam<T> {
  T call();
}

//! Why use extend instead of implements?
// - Must follow the interface of the implemented class
// - Cannot access and extend private properties

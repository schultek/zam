
extension PropertyCompare<T> on Set<T> {

  bool containsAllBy<U>(Iterable<T> other, U Function(T object) propertyGetter) {
    return this.map(propertyGetter).toSet().containsAll(other.map(propertyGetter));
  }

  Set<U> intersectionBy<U>(Iterable<T> other, U Function(T object) propertyGetter) {
    return this.map(propertyGetter).toSet().intersection(other.map(propertyGetter).toSet());
  }

}
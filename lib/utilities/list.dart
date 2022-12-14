typedef RefractTo<T, S> = S Function(T value);
typedef Retain<T> = bool Function(T value);

List<S> copyWhereRefract<T, S>(
    {required List<T> list,
    required Retain<T> retain,
    required RefractTo<T, S> refractTo}) {
  List<S> copy = [];

  for (T l in list) {
    if (retain(l)) {
      copy.add(refractTo(l));
    }
  }
  return copy;
}

List<T> copyWhere<T>({required List<T> list, required Retain<T> retain}) {
  List<T> copy = [];

  for (T l in list) {
    if (retain(l)) {
      copy.add(l);
    }
  }
  return copy;
}

use Set;

proc argmax(array: []) {
  var imax = array.domain.first;

  for i in array.domain {
    if array(i) > array(imax) {
      imax = i;
    }
  }

  return imax;
}

proc argmin(array: []) {
  var imin = array.domain.first;

  for i in array.domain {
    if array(i) < array(imin) {
      imin = i;
    }
  }

  return imin;
}

proc unique(array: [] ?T) {
  const s = new set(T, array);
  return s.toArray();
}

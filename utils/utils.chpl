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

proc mean(array: []) {
  var s = 0.0;
  forall a in array with (+reduce s) {
    s += a/array.size;
  }
  return s;
}

proc variance(array: []) {
  var m = mean(array);
  var s = 0.0;
  forall a in array with (+reduce s) {
    s += (a-m)**2 / array.size;
  }
  return s;
}

proc stdDev(array: []) {
  return sqrt(variance(array));
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

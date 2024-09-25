use Set;
private use Time;

var profileKeys: domain(string, parSafe=true);
var profiler: [profileKeys] stopwatch;

proc tic(tag: string = "Profiler") {
    var t: stopwatch;
    profileKeys += tag;
    profiler[tag].start();
}

proc toc(tag: string = "Profiler") {
    profiler[tag].stop();
    writeln(tag, " => ", profiler[tag].elapsed());
    profileKeys -= tag;
}

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

proc reverse(ref array: []) {
    var st = array.domain.low;
    var en = array.domain.high;
    while st < en {
        array(st) <=> array(en);
        st += 1;
        en -= 1;
    }
}



enum Policy {min, max};

proc heapify(ref data: [], i = 0, policy = Policy.min) {
  if policy == Policy.min {
    minHeapify(data, i);
  } else {
    maxHeapify(data, i);
  }
}

proc buildHeap(ref data: [], policy = Policy.min) {
    const last = data.size / 2 - 1; // ignore leaf nodes
    for i in 0..last by -1 {
        heapify(data, i, policy);
    }
}

proc minHeapify(ref data: [], i = 0) {
  var l = left(i);
  var r = right(i);
  var top = i;

  if l < data.size && data(l) < data(top) {
    top = l;
  }
  if r < data.size && data(r) < data(top) {
    top = r;
  }

  if top != i {
    data(top) <=> data(i);
    minHeapify(data, top);
  }
}

proc maxHeapify(ref data: [] ?T, i = 0) {
  var l = left(i);
  var r = right(i);
  var top = i;

  if l < data.size && data(l) > data(top) {
    top = l;
  }
  if r < data.size && data(r) > data(top) {
    top = r;
  }

  if top != i {
    data(top) <=> data(i);
    maxHeapify(data, top);
  }
}

inline proc parent(i) { return (i-1) / 2; }
inline proc left(i) { return (2*i) + 1; }
inline proc right(i) { return (2*i) + 2; }

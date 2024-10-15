enum Policy {min, max};

class Heap {
    type dtype;
    const size: int;
    var data: [0..#size] dtype;
}

proc Heap.heapify(i, policy = Policy.min) {
  if policy == Policy.min {
    minHeapify(i);
  } else {
    maxHeapify(i);
  }
}

proc Heap.buildHeap(policy = Policy.min) {
    const last = data.size / 2 - 1; // ignore leaf nodes
    for i in 0..last by -1 {
        heapify(i, policy);
    }
}

proc Heap.minHeapify(i) {
  const l = left(i);
  const r = right(i);
  var top = i;

  if l < data.size && data(l) < data(top) {
    top = l;
  }
  if r < data.size && data(r) < data(top) {
    top = r;
  }

  if top != i {
    data(top) <=> data(i);
    minHeapify(top);
  }
}

proc Heap.maxHeapify(i = 0) {
  const l = left(i);
  const r = right(i);
  var top = i;

  if l < data.size && data(l) > data(top) {
    top = l;
  }
  if r < data.size && data(r) > data(top) {
    top = r;
  }

  if top != i {
    data(top) <=> data(i);
    maxHeapify(top);
  }
}

inline proc parent(i) { return (i-1) / 2; }
inline proc left(i) { return (2*i) + 1; }
inline proc right(i) { return (2*i) + 2; }

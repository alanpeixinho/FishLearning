enum Policy {min, max};

class MyHeap {

    var policy: Policy.min;
    type eltType;
    var heap_domain: domain(1);
    var array: [heap_domain] eltType;

    proc init(data: [?D] ?T) {
       policy = Policy.min;
       eltType = T;
       heap_domain = D;
       array = data;
    }

    proc heapify() {
      if policy == Policy.min {
        minHeapify(0);
      } else {
        maxHeapify(0);
      }
    }

    proc heap_size {
      return heap_domain(1);
    }

    proc minHeapify(i: int) {
      var l = left(i);
      var r = right(i);
      var top = i;

      if l < heap_size && data(l) < data(top) {
        top = l;
      } else if r < heap_size && data(r) < data(top) {
        top = r;
      }

      if top != i {
        data(top) <=> data(i);
        minHeapify(top);
      }

    }

    proc maxHeapify(i: int) {
      var l = left(i);
      var r = right(i);
      var top = i;

      if l < heap_size && data(l) > data(top) {
        top = l;
      } else if r < heap_size && data(r) > data(top) {
        top = r;
      }

      if top != i {
        data(top) <=> data(i);
        maxHeapify(top);
      }

    }

    inline proc parent(i: int) { return i/2; }
    inline proc left(i: int) { return (2*i); }
    inline proc right(i: int) { return (2*i + 1); }
}

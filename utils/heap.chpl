
class Heap {

    enum Policy {min, max};

    var policy: Policy = min;
    var arrayDomain: domain(1);
    var array: [arrayDomain] T;
    var heapSize: int = 0;

    proc init(T, array: [?D]) where rank(D)==1 {
      arrayDomain = D;
      array = 0;
      heapSize = array.shape(1);
    }

    proc heapify() {
      if policy == min {
        minHeapify(0);
      } else {
        maxHeapify(0);
      }
    }

    proc minHeapify(i: int) {
      var l = left(i);
      var r = right(i);
      var top = i;
      
      if l < heapSize && array(l) < array(top) {
        top = l;
      } else if r < heapSize && array(r) < array(top) {
        top = r;
      }

      if top != i {
        array(top) <=> array(i);
        minHeapify(top);
      }

    }

    proc maxHeapify(i: int) {
      var l = left(i);
      var r = right(i);
      var top = i;

      if l < heapSize && array(l) > array(top) {
        top = l;
      } else if r < heapSize && array(r) > array(top) {
        top = r;
      }

      if top != i {
        array(top) <=> array(i);
        maxHeapify(top);
      }

    }

    inline proc int parent(i: int) { return i/2; }
    inline proc left(i: int) { return (2*i); }
    inline proc right(i: int) { return (2*i + 1); }
}

private use heap;
private use utils;
private use Random;

proc heapSort(ref data: [?d] ?T) {
    buildHeap(data, Policy.max);
    var last = data.domain.high;
    while last > 0 {
        maxHeapify(data[..last]);
        data(0) <=> data(last);
        last -= 1;
    }
}

proc insertionSort(ref data: []) {
    for i in data.domain[1..] {
        for j in data.domain[1..i] by -1 {
            if data(j-1) <= data(j) then break;
            data(j-1) <=> data(j);
        }
    }
}

proc isSorted(ref data: []) {
    for i in data.domain[1..] {
        if data(i-1) > data(i) then return false;
    }
    return true;
}


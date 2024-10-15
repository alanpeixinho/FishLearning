
class Queue {
    type dtype;
    const max_size: int = 40960;
    var data: [0..#max_size] int;

    var elems: int = 0;
    var head: int = 0;
    var tail: int = 0;
}


proc Queue.enqueue(val: dtype) {
    if elems >= max_size then halt("Queue has surpassed its limit");

    data[tail] = val;
    tail = (tail + 1) % max_size;
    elems += 1;
}

proc Queue.front(): ref dtype {
    if elems <= 0 then halt("Queue is empty");
    return data[head];
}

proc Queue.dequeue(): dtype {
    const val = front();
    head = (head + 1) % max_size;
    elems -= 1;
    return val;
}

proc Queue.isEmpty : bool {
    return elems <= 0;
}

proc Queue.size: int {
    return elems;
}

iter Queue.these() ref dtype {
    if isEmpty then return;
    if head < tail {
        for i in head..#elems do yield data[i];
    } else {
        for i in head..<max_size do yield data[i];
        for i in 0..<tail do yield data[i];
    }
}

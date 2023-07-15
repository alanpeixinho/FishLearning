
class Queue {
    type dtype;
    const QUEUE_MAX_SIZE: int = 40960;
    var data: [0..#QUEUE_MAX_SIZE] int;
    var elems: int = 0;
    var head: int = 0;
    var tail: int = 0;

    proc enqueue(val: dtype) {
        if elems >= QUEUE_MAX_SIZE then halt("Queue has surpassed its limit");

        data[tail] = val;
        tail = (tail + 1) % QUEUE_MAX_SIZE;
        elems += 1;
    }

    proc dequeue(): dtype {
        if elems <= 0 then halt("Queue has no more elements");

        var val = data[head];
        head = (head + 1) % QUEUE_MAX_SIZE;
        elems -= 1;
        return val;
    }

    proc isEmpty : bool {
        return elems == 0;
    }

    proc size: int {
        return elems;
    }

    iter these() {
        if isEmpty then return;
        if head < tail {
            for i in head..#elems do yield data[i];
        } else {
            for i in head..QUEUE_MAX_SIZE-1 do yield data[i];
            for i in 0..tail-1 do yield data[i];
        }
    }
}

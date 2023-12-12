
proc threshold(ref data, minimum, maximum) {
    for val in data {
        val = max(min(val, maximum), minimum);
    }
}


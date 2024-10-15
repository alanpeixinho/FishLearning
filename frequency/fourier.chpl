private use math;
private use IO.FormattedIO;

proc dft(const ref data: [?ddomain], direction=1) {
    var freq: [ddomain] complex(64) = 0;
    dft(data, freq);
    return freq;
}

proc fft(const ref data: [?ddomain], direction=1) {
    var freq: [ddomain] complex(64) = 0;
    fft(data, freq);
    return freq;
}

proc fft(const ref data: [?ddomain], ref freq: [ddomain] ?ftype, direction=1)
    where ddomain.rank == 3 {
        const (depth, height, width) = data.shape;

        //intermediate dfts and idfts should be complex to not loose information
        var freqTemp: [ddomain] complex(64) = data: complex(64);

        forall (z, y) in ddomain(.., .., 0) {
            fft1(freqTemp[z, y, ..], direction);
        }
        forall (z, x) in ddomain(.., 0, ..) {
            fft1(freqTemp[z, .., x], direction);
        }
        forall (y, x) in ddomain(0, .., ..) {
            fft1(freqTemp[.., y, x], direction);
        }

        freq = freqTemp : ftype;
}

proc dft(const ref data: [?ddomain], ref freq: [ddomain] ?ftype, direction=1)
    where ddomain.rank == 3 {
        const (depth, height, width) = data.shape;

        //intermediate dfts and idfts should be complex to not loose information
        var freqTemp1: [ddomain] complex(64) = data: complex(64);
        var freqTemp2: [ddomain] complex(64);

        forall (z, y) in ddomain(.., .., 0) {
            dft1(freqTemp1[z, y, ..], freqTemp2[z, y, ..], direction);
        }
        forall (z, x) in ddomain(.., 0, ..) {
            dft1(freqTemp2[z, .., x], freqTemp1[z, .., x], direction);
        }
        forall (y, x) in ddomain(0, .., ..) {
            dft1(freqTemp1[.., y, x], freqTemp2[.., y, x], direction);
        }

        freq = freqTemp2 : ftype;
}

proc dft1(const ref data: [?ddomain] ?ftype, ref freq: [ddomain] ftype, direction=1)
    where ddomain.rank == 1 && isComplexType(ftype) {
    const N = ddomain.shape[0];
    for n in data.domain {
        freq[n] = 0;
        for k in 0..#N {
            const angle = -direction * 2 * pi * k * n / N;
            freq[n] += (data[k] * exp(angle * 1i)): ftype;
        }
    }

    if direction < 0 {
        freq /= freq.size;
    }
}


/*Cooley-Tukey FFT */
proc fft1(ref x: [?ddomain] ?ftype, direction=1) throws
    where ddomain.rank == 1 && isComplexType(ftype) {
    const N = ddomain.shape[0];
    if N == 1 {
        return;
    }

    if !isPowerOf2(N) {
        throw new IllegalArgumentError(
                "Length of input sequence must be a power of 2. Value: %i".format(N));
    }

    // Bit-reversal permutation
    const nbits = log2(N): int;
    for i in 0..#N {
        var j = 0;
        var k = i;
        // bit-reversal of index i
        for b in 0..#nbits {
            j = (j * 2) + (k % 2);
            k /= 2;
        }
        if i < j {
            x[i] <=> x[j];
        }
    }

    // FFT computation
    var len = 2;
    while len <= N {
        const angle = (-direction * 2 * pi / len);
        const wlen = exp(angle * 1i);
        for i in 0..(N-len) by len {
            var w = 1.0: complex;
            for j in 0..len/2-1 {
                const u = x[i + j];
                const t = w * x[i + j + len/2];
                x[i + j] = (u + t): ftype;
                x[i + j + len/2] = (u - t): ftype;
                w *= wlen;
            }
        }
        len *= 2;
    }

    if direction < 0 {
        x /= x.size;
    }
}

proc shift(ref data: [?ddomain]) where ddomain.rank == 1 {
    const n = data.size;

    forall i in 0..#(n/2) {
        const si = (i + (n / 2)): int;
        data[i: int] <=> data[si: int];
    }
}

proc shift(ref data: [?ddomain]) where ddomain.rank == 2 {
    const (m, n) = data.shape;

    for i in 0..#(n/2) {
        const si = (i + (n / 2)): int;
        data[.., i: int] <=> data[.., si: int];
    }
    for i in 0..#(m/2) {
        const si = (i + (m / 2)): int;
        data[i: int, ..] <=> data[si: int, ..];
    }
}


proc shift(ref data: [?ddomain]) where ddomain.rank == 3 {
    const (l, m, n) = data.shape;

    for i in 0..#(n/2) {
        const si = (i + (n / 2)): int;
        data[.., .., i: int] <=> data[.., .., si: int];
    }
    for i in 0..#(m/2) {
        const si = (i + (m / 2)): int;
        data[.., i: int, ..] <=> data[.., si: int, ..];
    }
    for i in 0..#(l/2) {
        const si = (i + (l / 2)): int;
        data[i: int, .., ..] <=> data[si: int, .., ..];
    }
}


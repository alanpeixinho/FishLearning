private use math;
private use IO.FormattedIO;

proc dft(ref data: [?ddomain]) {
    var freq: [ddomain] complex(64) = 0;
    dft(data, freq);
    return freq;
}

proc dft(ref data: [?ddomain], ref freq: [ddomain] ?ftype)
    where ddomain.rank == 3 {
        const (depth, height, width) = data.shape;

        /*var freqTemp: [ddomain] ftype;*/
        freq = data: complex(64);

        for (z, y) in ddomain(.., .., 0) {
            /*dft1(data[z, y, ..], freq[z, y, ..]);*/

            fft1(freq[z, y, ..]);
        }

        for (z, x) in ddomain(.., 0, ..) {
            /*dft1(freq[z, .., x], freqTemp[z, .., x]);*/
            fft1(freq[z, .., x]);
        }

        for (y, x) in ddomain(0, .., ..) {
            /*dft1(freqTemp[.., y, x], freq[.., y, x]);*/
            fft1(freq[.., y, x]);
        }
    }

proc dft1(ref data: [?ddomain], ref freq: [ddomain] ?ftype) {
    const N = ddomain.shape[0];
    for n in data.domain {
        freq[n] = 0;
        for k in data.domain {
            const angle = -2i * pi * k * n / N;
            freq[n] += (data[k] * exp(angle)): ftype;
        }
    }
}


/*Cooley-Tukey FFT */
proc fft1(ref x: [?ddomain]) throws where ddomain.rank == 1 {
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
            j = (j << 1) | (k & 1);
            k >>= 1;
        }
        if i < j {
            x[i] <=> x[j];
        }
    }

    // FFT computation
    var len = 2;
    while len <= N {
        const angle = (-2i * pi / len): complex(64);
        const wlen = exp(angle);
        for i in 0..(N-len) by len {
            var w = 1.0: complex(64);
            for j in 0..len/2-1 {
                const u = x[i + j];
                const t = w * x[i + j + len/2];
                x[i + j] = u + t;
                x[i + j + len/2] = u - t;
                w *= wlen;
            }
        }
        len *= 2;
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


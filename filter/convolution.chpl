proc convolution(data, kernel) {
    forall (z, y, x) in data.domain {
        var sum = 0.0;
        const n = kernel.size;
        for (kz, ky, kx) in kernel.domain {
            if data.domain.contains(z + kz, y + ky, x + kx) {
                sum += data[z + kz, y + ky, x + kx];
            }
        }
        data[z, y, x] = sum / n;
    }
}


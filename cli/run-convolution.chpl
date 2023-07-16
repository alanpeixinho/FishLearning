use image;
use kernel;
use convolution;

config const input: string;
config const output: string;
config const kernelSize: int;

proc main() {
    var img = image.readImage(input);
    const avgKernel = squareKernel(kernelSize, 2.2);

    writef("Img { min: %r, max: %r }\n",
            min reduce img.l, max reduce img.l);
    convolution(img, avgKernel);
    writef("Img { min: %r, max: %r }\n",
            min reduce img.l, max reduce img.l);

    image.writeImage(output, img);
}

use image;
use kernel;
use convolution;

config const input: string;
config const output: string;
config const kernelSize: int;

proc main() {
    var img = image.readImage(input);
    const kernel = crossKernel(kernelSize, 1.0);

    /*const kernel = laplacianKernel();*/

    writef("Img { min: %r, max: %r }\n",
            min reduce img.l, max reduce img.l);
    convolution(img, kernel);
    writef("Img { min: %r, max: %r }\n",
            min reduce img.l, max reduce img.l);

    image.writeImage(output, img);
}

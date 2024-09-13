use fourier;
use image;
use math;

config const input: string;
config const output: string;

proc main() {
    var img = image.readImage(input);
    var freq = dft(img.l);
    /*writeln(">> ", max reduce (img.l));*/
    img.l = log(abs(freq) + 1) * 9;
    img.a = 0;
    img.b = 0;

    shift(img.l);

    /*writeln(">> ", max reduce (img.l));*/
    image.writeImage(output, img);
}

use image;
use threshold;

config const input: string;
config const output: string;

config const minimum: real = 0.0;
config const maximum: real = 100.0;

proc main() {
    var img = image.readImage(input);
    threshold(img.l, minimum, maximum);
    writef("Img { min: %r, max: %r }\n",
            min reduce img.l, max reduce img.l);

    image.writeImage(output, img);
}

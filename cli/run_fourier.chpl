use fourier;
use image;
use math;

config const input: string;
config const output: string;

proc main() {
    var img = image.readImage(input);
    var fourier: [img.l.domain] complex(64);
    dft(img.l, fourier);
    writeln(">> ", max reduce (img.l));
    shift(fourier);

    /*logabs(fourier, img);*/

    /*img.l = log(abs(fourier) + 1) * 10;*/


    forall f in fourier {
        if abs(f) > 1e7 {
            f = 0+0i;
        }
    }

    fourier *= 4;

    shift(fourier);

    img.l = 0;
    img.a = 0;
    img.b = 0;
    dft(fourier, img.l, -1);

    writeln(">> ", max reduce (img.l));
    image.writeImage(output, img);
}


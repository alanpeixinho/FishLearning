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

    img.l = log(abs(fourier) + 1) * 5;
    img.a = 0;
    img.b = 0;

    /*const (cz,cy,cx) = img.l.shape / 2;*/

    /*forall (z,y,x) in fourier.domain {*/
        /*if sqrt((cx - x)**2 + (cy - y)**2) < 1 {*/
            /*fourier[z,y,x] = 0+0i;*/
        /*}*/
    /*}*/

    /*fourier *= 4;*/

    writeImage("hue.png", img);

    shift(fourier);

    img.l = 0;
    /*img.a = 0;*/
    /*img.b = 0;*/
    fft(fourier, img.l, -1);

    writeln(">> ", max reduce (img.l));
    image.writeImage(output, img);
}


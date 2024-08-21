private use draw;
private use IO;
private use CTypes;
private use math;

proc main() {
    const screenWidth: int(32) = 800;
    const screenHeight: int(32) = 600;

    const frequency: real(32) = 10.0 / 2.0 * pi;
    const amplitude: real(32) = 0.2;

    const npoints = 2000;
    const step = 1.0 / npoints;

    const fps: int(32) = 30;
    const speed: real(32) = 0.1;

    var time: real(32) = 0.0;

    for frame in Window(screenWidth, screenHeight, "Sin Wave", fps) {

        time += GetFrameTime();

        manage Draw {

            ClearBackground(WHITE);

            DrawText("FPS %i Time: %0.01drs".format(GetFPS(), time).c_str(),
                    20, 20, 20, BLACK);
            DrawLine(18, 42, screenWidth - 18, 42, BLACK);

            for i in 0..#npoints {
                const x0: real(32) = i: real(32) / npoints;
                const x1: real(32) = x0 + step: real(32);
                const y0: real(32) = amplitude * sin(frequency * (x0 + time * speed));
                const y1: real(32) = amplitude * sin(frequency * (x1 + time * speed));
                DrawLine((x0*screenWidth): int(32), ((0.5 + y0) * screenHeight): int(32),
                         (x1*screenWidth): int(32), ((0.5 + y1) * screenHeight): int(32),
                         BLACK);
            }
        }
    }
}

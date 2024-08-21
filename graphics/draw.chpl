extern {
#include <raylib.h>
}

const BLACK = new Color(0, 0, 0, 255);
const WHITE = new Color(255, 255, 255, 255);
const RED = new Color(255, 0, 0, 255);
const GREEN = new Color(0, 255, 0, 255);
const BLUE = new Color(0, 0, 255, 255);
const CYAN = new Color(0, 255, 255, 255);

operator :(from: (?dtype1, ?dtype2), type toType: Vector2) {
    return new Vector2(from[0]: real(32), from[1]: real(32));
}

class DrawContext: contextManager {
    proc enterContext() {
        BeginDrawing();
    }
    proc exitContext(in err: owned Error?) {
        EndDrawing();
    }
}

class WindowContext: contextManager {
    const width: int(32);
    const height: int(32);
    const title: string;
    const fps: int(32);
    proc enterContext() {
        InitWindow(width, height, title.c_str());
        SetTargetFPS(fps);
    }
    proc exitContext(in err: owned Error?) {
        CloseWindow();
    }
    iter these() {
        while(!WindowShouldClose()) {
            yield this;
        }
    }
}

proc Draw {
    return new owned DrawContext();
}

iter Window(width: int(32), height: int(32),
        title: string = "Fish Learning", fps: int(32) = 60) {
    InitWindow(width, height, title.c_str());
    SetTargetFPS(fps);

    var frame: int(64) = 0;
    while !WindowShouldClose() {
        yield frame;
        frame += 1;
    }

    CloseWindow();
}

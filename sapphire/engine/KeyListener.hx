package engine;

import glfw.GLFW.GLFWwindow;
import glfw.GLFW.*;
import cpp.Pointer;

class KeyListener {
    private static var instance: KeyListener;
    var keyPressed: Array<Bool> = [for (i in 0...350) false];
    
    private function new() {
        
    }

    public static function get(): KeyListener {
        if (instance == null) {
            instance = new KeyListener();
        }

        return instance;
    }

    public static function keyCallback(window: Pointer<GLFWwindow>, key, scancode, action, mods: Int) {
        if (action == GLFW_PRESS) {
            get().keyPressed[key] = true;
        }
        else if (action == GLFW_RELEASE) {
            get().keyPressed[key] = false;
        }
    }

    public static function isKeyPressed(keyCode: Int): Bool {
        return get().keyPressed[keyCode];
    }
}
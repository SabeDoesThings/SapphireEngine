package engine;

import cpp.Reference;
import glfw.GLFW.GLFWmouseposcb;
import glfw.GLFW.*;
import glfw.GLFW.GLFWwindow;
import cpp.Pointer;

class MouseListener {
    private static var instance: MouseListener;
    private var scrollX: Float;
    private var scrollY: Float;
    private var xPos: Float;
    private var yPos: Float;
    private var lastX: Float;
    private var lastY: Float;
    private var mouseButtonPressed: Array<Bool> = [false, false, false];
    private var isDragging: Bool;

    private function new() {
        this.scrollX = 0.0;
        this.scrollY = 0.0;
        this.xPos = 0.0;
        this.yPos = 0.0;
        this.lastX = 0.0;
        this.lastY = 0.0;
    }

    public static function get(): MouseListener {
        if (instance == null) {
            instance = new MouseListener();
        }

        return instance;
    }

    public static function mousePositionCallback(window: Pointer<GLFWwindow>, xpos, ypos: Float) {
        get().lastX = get().xPos;
        get().lastY = get().yPos;
        get().xPos = xpos;
        get().yPos = ypos;
        get().isDragging = get().mouseButtonPressed[0] || get().mouseButtonPressed[1] || get().mouseButtonPressed[2];
    }

    public static function mouseButtonCallback(window: Pointer<GLFWwindow>, button, action, mods: Int) {
        if (action == GLFW_PRESS) {
            if (button < get().mouseButtonPressed.length) {
                get().mouseButtonPressed[button] = true;
            }
        }
        else if (action == GLFW_RELEASE) {
            if (button < get().mouseButtonPressed.length) {
                get().mouseButtonPressed[button] = false;
                get().isDragging = false;
            }
        }
    }

    public static function mouseScrollCallback(window: Pointer<GLFWwindow>, xOffset, yOffset: Float) {
        get().scrollX = xOffset;
        get().scrollY = yOffset;
    }

    public static function endFrame() {
        get().scrollX = 0;
        get().scrollY = 0;
        get().lastX = get().xPos;
        get().lastY = get().yPos;
    }

    public static function getX(): Float { return get().xPos; }

    public static function getY(): Float { return get().yPos; }

    public static function getDx(): Float { return get().lastX - get().xPos; }

    public static function getDy(): Float { return get().lastY - get().yPos; }

    public static function getScrollX(): Float { return get().scrollX; }

    public static function getScrollY(): Float { return get().scrollY; }

    public static function getIsDragging(): Bool { return get().isDragging; }

    public static function mouseButtonDown(button: Int): Bool {
        if (button < get().mouseButtonPressed.length) {
            return get().mouseButtonPressed[button];
        }
        else {
            return false;
        }
    }
}
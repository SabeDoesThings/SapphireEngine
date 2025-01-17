package engine;

import glfw.GLFW.GLFWmouseposcb;
import glfw.GLFW.GLFWwindow;
import cpp.Pointer;
import opengl.GL.*;
import haxe.Exception;
import glfw.GLFW.*;

class Window {
    private var width: Int;
    private var height: Int;
    private var title: String;
    private var glfwWindow: Pointer<GLFWwindow>;

    public var r: Float;
    public var g: Float;
    public var b: Float;
    public var a: Float;

    private static var window: Window = null;

    private static var currentScene: Scene = null;

    private function new() {
        this.width = 1280;
        this.height = 720;
        this.title = "Sapphire Engine";

        r = 1.0;
        g = 1.0;
        b = 1.0;
        a = 1.0;
    }

    public static function changeScene(newScene: Int) {
        switch (newScene) {
            case 0:
                currentScene = new LevelEditorScene();
                currentScene.init();
                currentScene.start();
            case 1:
                currentScene = new LevelScene();
                currentScene.init();
                currentScene.start();
            default:
                throw "Unknown scene '" + newScene + "'";
        }
    }

    public static function get(): Window {
        if (window == null) {
            window = new Window();
        }
        return window;
    }

    public static function getScene(): Scene {
        return currentScene;
    }

    public function run() {
        Sys.println("Hello GLFW " + GLFW_VERSION_MAJOR + "." + GLFW_VERSION_MINOR + "!");

        init();
        loop();

        glfwDestroyWindow(glfwWindow);

        glfwTerminate();
        glfwSetErrorCallback(null);
    }

    public function init() {
        if (glfwInit() == 0) {
            throw new Exception("Unable to initialize GLFW");
        }

        glfwDefaultWindowHints();
        glfwWindowHint(GLFW_OPENGL_DEBUG_CONTEXT, GLFW_TRUE);
        glfwWindowHint(GLFW_VISIBLE, GLFW_FALSE);
        glfwWindowHint(GLFW_RESIZABLE, GLFW_TRUE);
        glfwWindowHint(GLFW_MAXIMIZED, GLFW_TRUE);

        glfwWindow = glfwCreateWindow(this.width, this.height, this.title, null, null);
        if (glfwWindow == null) {
            throw new Exception("Failed to create the GLFW window");
        }

        glfwSetCursorPosCallback(glfwWindow, cast MouseListener.mousePositionCallback);
        glfwSetMouseButtonCallback(glfwWindow, cast MouseListener.mouseButtonCallback);
        glfwSetScrollCallback(glfwWindow, cast MouseListener.mouseScrollCallback);
        glfwSetKeyCallback(glfwWindow, cast KeyListener.keyCallback);

        glfwMakeContextCurrent(glfwWindow);

        glfwSwapInterval(1);

        glfwShowWindow(glfwWindow);

        glEnable(GL_BLEND);
        glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);

        changeScene(0);
    }

    public function loop() {
        var beginTime = glfwGetTime();
        var endTime;
        var dt = -1.0;

        while (glfwWindowShouldClose(glfwWindow) != GLFW_TRUE) {
            glfwPollEvents();

            glClearColor(r, g, b, a);
            glClear(GL_COLOR_BUFFER_BIT);

            if (dt >= 0) {
                currentScene.update(dt);
            }

            glfwSwapBuffers(glfwWindow);

            endTime = glfwGetTime();
            dt = endTime - beginTime;
            beginTime = endTime;
        }
    }
}
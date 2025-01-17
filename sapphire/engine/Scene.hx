package engine;

import renderer.Renderer;

abstract class Scene {
    private var renderer: Renderer = new Renderer();
    public var camera: Camera;
    private var isRunning: Bool = false;
    private var gameObjects: Array<GameObject> = new Array<GameObject>();

    public function new() {
        
    }

    public function init() {
        
    }

    public function start() {
        for (go in gameObjects) {
            go.start();
            this.renderer.add(go);
        }
        isRunning = true;
    }

    public function addGameObjectToScene(go: GameObject) {
        if (!isRunning) {
            gameObjects.push(go);
        }
        else {
            gameObjects.push(go);
            go.start();
            this.renderer.add(go);
        }
    }

    public abstract function update(dt: Float): Void;

    public function getCamera(): Camera {
        return this.camera;
    }
}
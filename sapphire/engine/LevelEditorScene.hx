package engine;

import components.SpriteRenderer;
import util.AssetPool;
import components.Spritesheet;
import components.Sprite;
import glm.Vec2;

class LevelEditorScene extends Scene {
    private var obj1: GameObject;
    private var sprites: Spritesheet;

    public function new() {
        super();
    }

    public override function init() {
        loadResources();

        this.camera = new Camera(new Vec2(-250, 0));

        sprites = AssetPool.getSpritesheet("assets/images/spritesheet.png");

        obj1 = new GameObject("Object1", 
            new Transform(new Vec2(200, 100), new Vec2(256, 256)), 2);
        obj1.addComponent(new SpriteRenderer(new Sprite(
            AssetPool.getTexture("assets/images/blendImage1.png")
        )));

        var obj2: GameObject = new GameObject("Object1",
            new Transform(new Vec2(400, 100), new Vec2(256, 256)), 1);
        obj2.addComponent(new SpriteRenderer(new Sprite(
            AssetPool.getTexture("assets/images/blendImage2.png")
        )));
        this.addGameObjectToScene(obj2);
    }

    private function loadResources() {
        AssetPool.getShader("assets/shader/default.glsl");

        AssetPool.addSpritesheet("asset/images/spritesheet.png",
            new Spritesheet(AssetPool.getTexture("assets/images/spritesheet.png"),
                16, 16, 26, 0));
    }

    public function update(dt:Float) {
        for (go in this.gameObjects) {
            go.update(dt);
        }

        this.renderer.render();
    }
}
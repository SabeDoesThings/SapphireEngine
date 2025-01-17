package components;

import glm.Vec2;
import renderer.Texture;

class Sprite {
    private var texture: Texture;
    private var texCoords: Array<Vec2>;

    public function new(texture: Texture, texCoords:Array<Vec2> = null) {
        this.texture = texture;
        this.texCoords = texCoords != null ? texCoords : [
            new Vec2(1, 1),
            new Vec2(1, 0),
            new Vec2(0, 0),
            new Vec2(0, 1)
        ];
    }

    public function getTexture(): Texture {
        return this.texture;
    }

    public function getTexCoords(): Array<Vec2> {
        return this.texCoords;
    }
}
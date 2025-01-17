package components;

import glm.Vec2;
import renderer.Texture;
import engine.Transform;
import glm.Vec4;
import engine.Component;

class SpriteRenderer extends Component {
    private var color: Vec4;
    private var sprite: Sprite;

    private var lastTransform: Transform;
    private var isDirty: Bool = false;

    public function new(sprite: Sprite = null, color: Vec4 = null) {
        this.sprite = sprite != null ? sprite : new Sprite(null);
        this.color = color != null ? color : new Vec4(1, 1, 1, 1);
        this.isDirty = true;
    }

    public override function start() {
        this.lastTransform = gameObject.transform.copy();
    }

    public function update(dt: Float) {
        if (!this.lastTransform.equals(this.gameObject.transform)) {
            this.gameObject.transform.copyTo(this.lastTransform);
            isDirty = true;
        }
    }

    public function getColor(): Vec4 {
        return this.color;
    }

    public function getTexture(): Texture {
        return sprite.getTexture();
    }

    public function getTexCoords(): Array<Vec2> {
        return sprite.getTexCoords();
    }

    public function setSprite(sprite: Sprite) {
        if (this.color.equals(color)) {
            this.isDirty = true;
        }
    }

    public function getIsDirty(): Bool {
        return this.isDirty;
    }

    public function setClean() {
        this.isDirty = true;
    }
}
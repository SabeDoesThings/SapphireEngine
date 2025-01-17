package components;

import engine.Component;
import glm.Vec2;
import renderer.Texture;

class Spritesheet extends Component {
    private var texture: Texture;
    private var sprites: Array<Sprite>;

    public function new(texture: Texture, spriteWidth, spriteHeight, numSprites, spacing: Int) {
        this.sprites = [];
        this.texture = texture;

        var currentX: Int = 0;
        var currentY: Int = texture.getHeight() - spriteHeight;
        for (i in 0...numSprites) {
            var topY = (currentY + spriteHeight) / texture.getHeight();
            var rightX = (currentX + spriteWidth) / texture.getWidth();
            var leftX = currentX / texture.getWidth();
            var bottomY = currentY / texture.getHeight();

            var texCoords: Array<Vec2> = [
                new Vec2(rightX, topY),
                new Vec2(rightX, bottomY),
                new Vec2(leftX, bottomY),
                new Vec2(leftX, topY)
            ];

            var sprite: Sprite = new Sprite(this.texture, texCoords);
            this.sprites.push(sprite);

            currentX += spriteWidth + spacing;
            if (currentX >= texture.getWidth()) {
                currentX = 0;
                currentY -= spriteHeight + spacing;
            }
        }
    }

    public function getSprite(index:Int):Sprite {
        return this.sprites[index];
    }

    public function update(dt:Float) {}
}
package renderer;

import components.SpriteRenderer;
import engine.GameObject;

class Renderer {
    private final MAX_BATCH_SIZE = 1000;
    private var batches: Array<RenderBatch>;

    public function new() {
        this.batches = [];
    }

    public function add(go: GameObject) {
        var spr: SpriteRenderer = go.getComponent(SpriteRenderer);
        if (spr != null) {
            addSpriteRenderer(spr);
        }
    }

    private function addSpriteRenderer(sprite: SpriteRenderer) {
        var added: Bool = false;
        for (batch in batches) {
            if (batch.getHasRoom() && batch.getZIndex() == sprite.gameObject.getZIndex()) {
                var tex: Texture = sprite.getTexture();
                if (tex == null || (batch.getHasTexture(tex) || batch.getHasTextureRoom())) {
                    batch.addSprite(sprite);
                    added = true;
                    break;
                }
            }

            if (!added) {
                var newBatch: RenderBatch = new RenderBatch(MAX_BATCH_SIZE, sprite.gameObject.getZIndex());
                newBatch.start();
                batches.push(newBatch);
                newBatch.addSprite(sprite);

                batches.sort((a: RenderBatch, b: RenderBatch) -> {
                    return a.getZIndex() - b.getZIndex();
                });
            }
        }
    }

    public function render() {
        for (batch in batches) {
            batch.render();
        }
    }
}
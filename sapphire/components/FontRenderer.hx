package components;

import engine.Component;

class FontRenderer extends Component {
    public override function start() {
        if (gameObject.getComponent(SpriteRenderer) != null) {
            Sys.println("Found font renderer!");
        }
    }

    public function update(dt: Float) {}
}
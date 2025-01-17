package engine;

import glm.Vec2;

class Transform {
    public var position: Vec2;
    public var scale: Vec2;

    public function new(?position:Vec2 = null, ?scale:Vec2 = null) {
        init(position == null ? new Vec2() : position, scale == null ? new Vec2() : scale);
    }

    public function init(position, scale: Vec2) {
        this.position = position;
        this.scale = scale;
    }

    public function copy(): Transform {
        return new Transform(new Vec2(this.position.x, this.position.y), new Vec2(this.scale.x, this.scale.y));
    }

    public function copyTo(to: Transform) {
        to.position.set(0, this.position.x);
        to.position.set(1, this.position.y);

        to.scale.set(0, this.scale.x);
        to.scale.set(1, this.scale.y);
    }

    public function equals(o: Dynamic): Bool {
        if (o == null) {
            return false;
        }
        if (!(o is Transform)) {
            return false;
        }
        var t:Transform = cast o;
        return t.position.equals(this.position) && t.scale.equals(this.scale);
    }
}
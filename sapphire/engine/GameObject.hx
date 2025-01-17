package engine;

class GameObject {
    private var name: String;
    private var components: Array<Component>;
    public var transform: Transform;
    private var zIndex: Int;

    public function new(name: String, ?transform: Transform, ?zIndex: Int = 0) {
        this.name = name;
        this.components = [];
        this.transform = transform != null ? transform : new Transform();
        this.zIndex = zIndex;
    }

    public function getComponent<T: Component>(componentClass: Class<T>): Null<T> {
        for (c in components) {
            if (Std.isOfType(c, componentClass)) {
                return cast c;
            }
        }
        return null;
    }

    public function removeComponent<T: Component>(componentClass: Class<T>) {
        for (i in 0...components.length) {
            var c = components[i];
            if (Std.isOfType(c, componentClass)) {
                components.splice(i, 1);
                return;
            }
        }
    }

    public function addComponent(c: Component) {
        components.push(c);
        c.gameObject = this;
    }

    public function update(dt: Float) {
        for (c in components) {
            c.update(dt);
        }
    }

    public function start() {
        for (c in components) {
            c.start();
        }
    }

    public function getZIndex(): Int {
        return this.zIndex;
    }
}
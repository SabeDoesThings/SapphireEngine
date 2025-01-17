package engine;

import engine.GameObject;

abstract class Component {
    public var gameObject: GameObject = null;

    public function start() {
        
    }

    public abstract function update(dt: Float): Void;
}
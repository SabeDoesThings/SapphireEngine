package engine;

import glm.Vec3;
import glm.GLM;
import glm.Vec2;
import glm.Mat4;

class Camera {
    private var projectionMatrix: Mat4;
    private var viewMatrix: Mat4;
    private var position: Vec2;

    public function new(position: Vec2) {
        this.position = position;
        this.projectionMatrix = new Mat4();
        this.viewMatrix = new Mat4();
        adjustProjection();
    }

    public function adjustProjection() {
        GLM.orthographic(0.0, 32.0 * 40.0, 0.0, 32.0 * 21.0, 0.0, 100.0, projectionMatrix);
    }

    public function getViewMatrix(): Mat4 {
        var cameraFront: Vec3 = new Vec3(0.0, 0.0, -1.0);
        var cameraUp: Vec3 = new Vec3(0.0, 1.0, 0.0);
        GLM.lookAt(
            new Vec3(position.x, position.y, 20.0),
            new Vec3(position.x, position.y, 0.0) + cameraFront,
            cameraUp,
            this.viewMatrix
        );

        return this.viewMatrix;
    }

    public function getProjectionMatrix(): Mat4 {
        return projectionMatrix;
    }
}
package renderer;

import glm.Vec2;
import glm.Vec4;
import engine.Window;
import cpp.UInt8;
import util.AssetPool;
import components.SpriteRenderer;
import opengl.GL.*;

class RenderBatch {
    private static final POS_SIZE: Int = 2;
    private static final COLOR_SIZE: Int = 4;
    private static final TEX_COORDS_SIZE: Int = 2;
    private static final TEX_ID_SIZE: Int = 1;

    private static final POS_OFFSET: Array<UInt8> = [0];
    private static final COLOR_OFFSET: Array<UInt8> = [POS_OFFSET[0] + POS_SIZE * Std.int(4)];
    private static final TEX_COORDS_OFFSET: Array<UInt8> = [COLOR_OFFSET[0] + COLOR_SIZE * Std.int(4)];
    private static final TEX_ID_OFFSET: Array<UInt8> = [TEX_COORDS_OFFSET[0] + TEX_COORDS_SIZE * Std.int(4)];
    private static final VERTEX_SIZE = 9;
    private static final VERTEX_SIZE_BYTES = VERTEX_SIZE * Std.int(4);

    private var sprites: Array<SpriteRenderer>;
    private var numSprites: Int;
    private var hasRoom: Bool;
    private var vertices: Array<Float>;
    private var texSlots: Array<Int> = [0, 1, 2, 3, 4, 5, 6, 7];

    private var textures: Array<Texture>;
    private var vaoID: Array<Int>;
    private var vboID: Array<Int>;
    private var eboID: Array<Int>;
    private var maxBatchSize: Int;
    private var shader: Shader;
    private var zIndex: Int;

    public function new(maxBatchSize, zIndex: Int) {
        this.zIndex = zIndex;
        shader = AssetPool.getShader("assets/shaders/default.glsl");
        this.sprites = [for (i in 0...maxBatchSize) new SpriteRenderer()];
        this.maxBatchSize = maxBatchSize;

        vertices = [for (i in 0...maxBatchSize * 4 * VERTEX_SIZE) 0];
        
        this.numSprites = 0;
        this.hasRoom = true;
        this.textures = [];
    }

    public function start() {
        glGenVertexArrays(1, vaoID);
        glBindVertexArray(vaoID[0]);

        glGenBuffers(1, vboID);
        glBindBuffer(GL_ARRAY_BUFFER, vboID[0]);
        glBufferData(GL_ARRAY_BUFFER, vertices.length * Std.int(4), null, GL_DYNAMIC_DRAW);

        glGenBuffers(1, eboID);
        var indices = generateIndices();
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, eboID[0]);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices[0], null, GL_STATIC_DRAW);

        glVertexAttribPointer(0, POS_SIZE, GL_FLOAT, false, VERTEX_SIZE_BYTES, POS_OFFSET);
        glEnableVertexArrayAttrib(vaoID[0], 0);

        glVertexAttribPointer(1, COLOR_SIZE, GL_FLOAT, false, VERTEX_SIZE_BYTES, COLOR_OFFSET);
        glEnableVertexArrayAttrib(vaoID[0], 1);

        glVertexAttribPointer(2, TEX_COORDS_SIZE, GL_FLOAT, false, VERTEX_SIZE_BYTES, TEX_COORDS_OFFSET);
        glEnableVertexArrayAttrib(vaoID[0], 2);

        glVertexAttribPointer(3, TEX_ID_SIZE, GL_FLOAT, false, VERTEX_SIZE_BYTES, TEX_ID_OFFSET);
        glEnableVertexArrayAttrib(vaoID[0], 3);
    }

    public function addSprite(spr: SpriteRenderer) {
        var index = this.numSprites;
        this.sprites[index] = spr;
        this.numSprites++;

        if (spr.getTexture() != null) {
            if (!textures.contains(spr.getTexture())) {
                textures.push(spr.getTexture());
            }
        }

        loadVertexProperties(index);

        if (numSprites >= this.maxBatchSize) {
            this.hasRoom = false;
        }
    }

    public function render() {
        var rebufferData = false;
        for (i in 0...numSprites) {
            var sprRenderer: SpriteRenderer = sprites[i];
            if (sprRenderer.getIsDirty()) {
                loadVertexProperties(i);
                sprRenderer.setClean();
                rebufferData = true;
            }
        }

        if (rebufferData) {
            glBindBuffer(GL_ARRAY_BUFFER, vboID[0]);
            glBufferSubData(GL_ARRAY_BUFFER, 0, vertices.length, null);
        }

        shader.use();
        shader.uploadMat4f("uProjection", Window.getScene().getCamera().getProjectionMatrix());
        shader.uploadMat4f("uView", Window.getScene().getCamera().getViewMatrix());
        for (i in 0...textures.length) {
            glActiveTexture(GL_TEXTURE0 + i + 1);
            textures[i].bind();
        }
        shader.uploadIntArray("uTextures", texSlots);

        glBindVertexArray(vaoID[0]);
        glEnableVertexArrayAttrib(vaoID[0], 0);
        glEnableVertexArrayAttrib(vaoID[0], 1);

        glDrawElements(GL_TRIANGLES, this.numSprites * 6, GL_UNSIGNED_INT, null);

        glDisableVertexArrayAttrib(vaoID[0], 0);
        glDisableVertexArrayAttrib(vaoID[0], 1);
        glBindVertexArray(0);

        for (i in 0...textures.length) {
            textures[i].unbind();
        }

        shader.detach();
    }

    private function loadVertexProperties(index: Int) {
        var sprite: SpriteRenderer = this.sprites[index];

        var offset: Int = index * 4 * VERTEX_SIZE;

        var color: Vec4 = sprite.getColor();
        var texCoords: Array<Vec2> = sprite.getTexCoords();

        var texID: Int = 0;
        if (sprite.getTexture() != null) {
            for (i in 0...textures.length) {
                texID = i + 1;
                break;
            }
        }

        var xAdd: Float = 1.0;
        var yAdd: Float = 1.0;
        for (i in 0...4) {
            if (i == 1) {
                yAdd = 0.0;
            }
            else if (i == 2) {
                xAdd = 0.0;
            }
            else if (i == 3) {
                yAdd = 1.0;
            }

            vertices[offset] = sprite.gameObject.transform.position.x + (xAdd * sprite.gameObject.transform.scale.x);
            vertices[offset + 1] = sprite.gameObject.transform.position.y + (yAdd * sprite.gameObject.transform.scale.y);

            vertices[offset + 2]  = color.x;
            vertices[offset + 3]  = color.y;
            vertices[offset + 4]  = color.z;
            vertices[offset + 5]  = color.w;

            vertices[offset + 6]  = texCoords[i].x;
            vertices[offset + 7]  = texCoords[i].y;

            vertices[offset + 8] = texID;

            offset += VERTEX_SIZE;
        }
    }

    private function generateIndices(): Array<Int> {
        var elements: Array<Int> = [6 * maxBatchSize];
        for (i in 0...maxBatchSize) {
            loadElementIndices(elements, i);
        }

        return elements;
    }

    private function loadElementIndices(elements: Array<Int>, index: Int) {
        var offsetArrayIndex: Int = 6 * index;
        var offset: Int = 4 * index;

        elements[offsetArrayIndex] = offset + 3;
        elements[offsetArrayIndex + 1] = offset + 2;
        elements[offsetArrayIndex + 2] = offset + 0;

        elements[offsetArrayIndex + 3] = offset + 0;
        elements[offsetArrayIndex + 4] = offset + 2;
        elements[offsetArrayIndex + 5] = offset + 1;
    }

    public function getHasRoom(): Bool {
        return this.hasRoom;
    }

    public function getHasTextureRoom(): Bool {
        return this.textures.length < 8;
    }

    public function getHasTexture(tex: Texture): Bool {
        return this.textures.contains(tex);
    }

    public function getZIndex() {
        return this.zIndex;
    }
}
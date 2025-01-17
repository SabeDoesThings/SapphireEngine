package renderer;

import stb.Image;
import opengl.GL.*;

class Texture {
    private var filepath: String;
    private var texID: Int;
    private var width: Int;
    private var height: Int;

    public function new(filepath: String) {
        this.filepath = filepath;

        var textures: Array<Int> = [0];
        glGenTextures(1, textures);
        texID = textures[0];
        glBindTexture(GL_TEXTURE_2D, texID);

        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);

        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);

        var image = Image.load(filepath, GL_TRUE);
        if (image != null) {
            this.width = image.w;
            this.height = image.h;

            var format: Int = if (image.comp == 3) GL_RGB else if (image.comp == 4) GL_RGB else -1;

            if (format != -1) {
                glTexImage2D(GL_TEXTURE_2D, 0, format, image.w, image.h, 0, format, GL_UNSIGNED_BYTE, image.bytes);
            }
            else {
                throw "Error: (Texture) unknown number of channels '" + image.comp + "'";
            }
        }
        else {
            throw "Error: (Texture) Could not load image '" + filepath + "'";
        }
    }

    public function bind() {
        glBindTexture(GL_TEXTURE_2D, texID);
    }

    public function unbind() {
        glBindTexture(GL_TEXTURE_2D, 0);
    }

    public function getWidth(): Int {
        return this.width;
    }

    public function getHeight(): Int {
        return this.height;
    }
}
package util;

import components.Spritesheet;
import renderer.Texture;
import renderer.Shader;

class AssetPool {
    private static var shaders:Map<String, Shader> = new Map<String, Shader>();
    private static var textures:Map<String, Texture> = new Map<String, Texture>();
    private static var spritesheets:Map<String, Spritesheet> = new Map<String, Spritesheet>();

    public static function getShader(resourceName: String): Shader {
        if (shaders.exists(resourceName)) {
            return shaders.get(resourceName);
        } else {
            var shader = new Shader(resourceName);
            shader.compile();
            shaders.set(resourceName, shader);
            return shader;
        }
    }

    public static function getTexture(resourceName: String): Texture {
        if (textures.exists(resourceName)) {
            return textures.get(resourceName);
        } else {
            var texture = new Texture(resourceName);
            textures.set(resourceName, texture);
            return texture;
        }
    }

    public static function addSpritesheet(resourceName: String, spritesheet: Spritesheet) {
        if (!spritesheets.exists(resourceName)) {
            spritesheets.set(resourceName, spritesheet);
        }
    }

    public static function getSpritesheet(resourceName: String):Spritesheet {
        if (!spritesheets.exists(resourceName)) {
            throw "Error: tried to access spritesheet '" + resourceName + "' and it has not been added to asset pool";
        }
        return spritesheets.get(resourceName);
    }
}
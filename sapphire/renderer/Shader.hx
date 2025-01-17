package renderer;

import cpp.NativeString;
import cpp.Float32;
import glm.*;
import haxe.Exception;
import sys.io.File;
import opengl.GL.*;

class Shader {
    private var shaderProgramID: Int;
    private var beingUsed: Bool = false;

    private var vertexSource: NativeString;
    private var fragmentSource: String;
    private var filepath: String;
    private var success: Array<Int>;

    public function new(filepath: String) {
        this.filepath = filepath;

        try {
            var source: String = File.getContent(filepath);
            var splitString = source.split("(#type)( )+([a-zA-Z]+)");

            var index: Int = source.indexOf("#type") + 6;
            var eol: Int = source.indexOf("\r\n", index);
            var firstPattern: String = StringTools.trim(source.substring(index, eol));

            // Second pattern
            index = source.indexOf("#type", eol) + 6;
            eol = source.indexOf("\r\n", index);
            var secondPattern: String = StringTools.trim(source.substring(index, eol));

            if (firstPattern == "vertex") {
                vertexSource = cast splitString[1];
            }
            else if (firstPattern == "fragment") {
                fragmentSource = splitString[1];
            }
            else {
                throw new Exception("Unexpected token '" + firstPattern + "'");
            }

            if (secondPattern == "vertex") {
                vertexSource = cast splitString[1];
            }
            else if (secondPattern == "fragment") {
                fragmentSource = splitString[1];
            }
            else {
                throw new Exception("Unexpected token '" + secondPattern + "'");
            }
        }
        catch (e: Exception) {
            trace(e);
            throw "Error: Could not open file for shader: '" + filepath + "'";
        }
    }

    public function compile() {
        var vertexID: Int;
        var fragmentID: Int;

        vertexID = glCreateShader(GL_VERTEX_SHADER);
        glGetShaderSource(vertexID, 1, null, cast vertexSource);
        glCompileShader(vertexID);

        var infoLog: String = "";
        glGetShaderiv(vertexID, GL_COMPILE_STATUS, success);
        if (success[0] != 0) {
            glGetShaderInfoLog(vertexID, 512, null, infoLog);
            Sys.println("ERROR: '" + filepath + "'\n\tVertex shader compilation failed.");
            throw "Shader compilation failed.";
        }

        fragmentID = glCreateShader(GL_FRAGMENT_SHADER);
        glGetShaderSource(fragmentID, 1, null, fragmentSource);
        glCompileShader(fragmentID);

        glGetShaderiv(fragmentID, GL_COMPILE_STATUS, success);
        if (success[0] != 0) {
            glGetShaderInfoLog(fragmentID, 512, null, infoLog);
            Sys.println("ERROR: '" + filepath + "'\n\tFragment shader compilation failed.");
            throw "Shader compilation failed.";
        }

        shaderProgramID = glCreateProgram();
        glAttachShader(shaderProgramID, vertexID);
        glAttachShader(shaderProgramID, fragmentID);
        glLinkProgram(shaderProgramID);

        glGetProgramiv(shaderProgramID, GL_LINK_STATUS, success);
        if (success[0] != 0) {
            glGetProgramInfoLog(shaderProgramID, 512, null, infoLog);
        }
    }

    public function use() {
        if (!beingUsed) {
            glUseProgram(shaderProgramID);
            beingUsed = true;
        }
    }

    public function detach() {
        glUseProgram(0);
        beingUsed = false;
    }

    public function uploadMat4f(varName: String, mat4: Mat4) {
        var varLocation = glGetUniformLocation(shaderProgramID, varName);
        use();
        var matBuffer:Array<Float32> = [];
        for (i in 0...9) {
            matBuffer.push(mat4.get(i));
        }
        glUniformMatrix4fv(varLocation, 1, false, matBuffer);
    }

    public function uploadMat3f(varName: String, mat3: Mat3) {
        var varLocation = glGetUniformLocation(shaderProgramID, varName);
        use();
        var matBuffer:Array<Float32> = [];
        for (i in 0...9) {
            matBuffer.push(mat3.get(i));
        }
        glUniformMatrix4fv(varLocation, 1, false, matBuffer);
    }

    public function uploadVec4f(varName: String, vec: Vec4) {
        var varLocation = glGetUniformLocation(shaderProgramID, varName);
        use();
        glUniform4f(varLocation, vec.x, vec.y, vec.z, vec.w);
    }

    public function uploadVec3f(varName: String, vec: Vec3) {
        var varLocation = glGetUniformLocation(shaderProgramID, varName);
        use();
        glUniform3f(varLocation, vec.x, vec.y, vec.z);
    }

    public function uploadVec2f(varName: String, vec: Vec2) {
        var varLocation = glGetUniformLocation(shaderProgramID, varName);
        use();
        glUniform2f(varLocation, vec.x, vec.y);
    }

    public function uploadFloat(varName: String, val: Float) {
        var varLocation = glGetUniformLocation(shaderProgramID, varName);
        use();
        glUniform1f(varLocation, val);
    }

    public function uploadInt(varName: String, val: Int) {
        var varLocation = glGetUniformLocation(shaderProgramID, varName);
        use();
        glUniform1i(varLocation, val);
    }

    public function uploadTexture(varName: String, slot: Int) {
        var varLocation = glGetUniformLocation(shaderProgramID, varName);
        use();
        glUniform1i(varLocation, slot);
    }

    public function uploadIntArray(varName: String, array: Array<Int>) {
        var varLocation = glGetUniformLocation(shaderProgramID, varName);
        use();
        glUniform1iv(varLocation, 1, array);
    }
}
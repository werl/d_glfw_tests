module helpers.camera

import gl3n.linalg:

alias Vector!(real, 3) vec3r;

struct Camera {
    vec3 position = vec3(0.0f, 0.0f, 0.0f);
    vec3r rot = vec3r(0.0f, 0.0f, 0.0f);
    
    Camera rotatex(real alpha) {
        rot.x = rot.x + alpha;
        return this;
    }
    
    Camera rotatey(real alpha) {
        // do degrees radians conversion at compiletime!
        rot.y = clamp(rot.y + alpha, cradians!(-80.0f), cradians!(80.0f));
        return this;
    }
    
    Camera rotatez(real alpha) {
        rot.z = rot.z + alpha;
        return this;
    }
    
    Camera move(float x, float y, float z) {
        position += vec3(x, y, z);
        return this;
    }
    Camera move(vec3 s) {
        position += s;
        return this;
    }
    
    @property camera() {
        // gl3n allows chaining of matrix (also quaternion) operations 
        return mat4.identity.translate(-position.x, -position.y, -position.z)
                            .rotatex(rot.x)
                            .rotatey(rot.y);
    }
}

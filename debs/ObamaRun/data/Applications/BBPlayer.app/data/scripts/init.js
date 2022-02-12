// *********
// Mouse Buttons
// *********

const MOUSE_BUTTON_LEFT = 0;
const MOUSE_BUTTON_RIGHT = 1;
const MOUSE_BUTTON_MIDDLE = 2;
const MOUSE_BUTTON_4 = 3;
const MOUSE_BUTTON_5 = 4;
const MOUSE_BUTTON_6 = 5;
const MOUSE_BUTTON_7 = 6;
const MOUSE_BUTTON_8 = 7;

// *********
// Settings
// *********
class SettingsClass {
    constructor() {

    }
}
var Settings = new SettingsClass();

function SettingsToJSON() {
    return JSON.stringify(Settings);
}

function JSONToSettings(json) {
    Settings = JSON.parse(json);
}

function ResetSettings() {
    Settings = new SettingsClass();
}

// *********
// Vec2
// *********
class Vec2 {
    constructor(x, y) {
        this.x = x;
        this.y = y;
    }
    
    normalize() {
        var n = this.length();
        if (n == 0) {
            return new Vec2(0, 0);
        }
        n = 1.0 / n;
        return new Vec2(this.x * n, this.y * n);
    }

    length() {
        return Math.sqrt(this.x * this.x + this.y * this.y);
    }

    sqrLength() {
        return this.x * this.x + this.y * this.y;
    }

    add(v) {
        return new Vec2(this.x + v.x, this.y + v.y);
    }

    sub(v) {
        return new Vec2(this.x - v.x, this.y - v.y);
    }
    get(n) {
        if (n == 0) return this.x;
        if (n == 1) return this.y;
    }
    set(n, val) {
        /**/ if (n == 0) this.x = val;
        else if (n == 1) this.y = val;
    }

    dot(v) {
        return this.x * v.x + this.y * v.y;
    }
    crossZ(v) {
        return this.x * v.y - this.y * v.x;
    }
    toArray() {
        return [this.x, this.y]
    }
    distance(target) {
        var v = this.sub(target);
        return v.length();
    }

    scale(factor) {
        return new Vec2(this.x * factor, this.y * factor);
    }

    lerp(target, alpha) {
        var a = this.scale(1 - alpha);
        var b = target.scale(alpha);
        return a.add(b);
    }

    static forAngle(angle) {
        return new Vec2(Math.cos(angle), Math.sin(angle));
    }

    rotate(other) {
        return new Vec2(
            this.x * other.x - this.y * other.y,
            this.x * other.y + this.y * other.x);
    }

    rotateByAngle(pivot, angle) {
        let p = this;
        p.x -= pivot.x;
        p.y -= pivot.y;

        p = p.rotate(Vec2.forAngle(angle));

        p.x += pivot.x;
        p.y += pivot.y;

        return p;
    }

    isXEmpty() {
        return this.x == null;
    }

    isYEmpty() {
        return this.y == null;
    }
    equals(v){
        return this.x == v.x && this.y == v.y;
    }
    toString() {
        return (
            this.x.toFixed(3).padStart(10) +
            this.y.toFixed(3).padStart(10));
    }
    static zero() { return new Vec2(0, 0); }
    static one() { return new Vec2(1, 1); }
}
// *********
// Vec3
// *********

class Vec3 {
    constructor(x, y, z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    normalize() {
        var n = this.length();
        if (n == 0) {
            return new Vec3(0, 0, 0);
        }
        n = 1.0 / n;
        return new Vec3(this.x * n, this.y * n, this.z * n);
    }

    length() {
        return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
    }

    sqrLength() {
        return this.x * this.x + this.y * this.y + this.z * this.z;
    }

    add(v) {
        return new Vec3(this.x + v.x, this.y + v.y, this.z + v.z);
    }

    sub(v) {
        return new Vec3(this.x - v.x, this.y - v.y, this.z - v.z);
    }

    get(n) {
        if (n == 0) return this.x;
        if (n == 1) return this.y;
        if (n == 2) return this.z;
    }

    set(n, val) {
        /**/ if (n == 0) this.x = val;
        else if (n == 1) this.y = val;
        else if (n == 2) this.z = val;
    }

    dot(v) {
        return this.x * v.x + this.y * v.y + this.z * v.z;
    }
    cross(v) {
        return new Vec3(
            this.y * v.z - this.z * v.y,
            -this.x * v.z + this.z * v.x,
            this.x * v.y - this.y * v.x
        );
    }
    toArray() {
        return [this.x, this.y, this.z]
    }
    distance(target) {
        var v = this.sub(target);
        return v.length();
    }

    scale(factor) {
        return new Vec3(this.x * factor, this.y * factor, this.z * factor);
    }

    lerp(target, alpha) {
        var a = this.scale(1 - alpha);
        var b = target.scale(alpha);
        return a.add(b);
    }

    isXEmpty() {
        return this.x == null;
    }

    isYEmpty() {
        return this.y == null;
    }

    isZEmpty() {
        return this.z == null;
    }

    equals(v){
        return this.x == v.x && this.y == v.y && this.z == v.z;
    }
    
    toString() {
        return (
            this.x.toFixed(3).padStart(8) +
            this.y.toFixed(3).padStart(8) +
            this.z.toFixed(3).padStart(8));
    }
    static zero() { return new Vec3(0, 0, 0); }
    static one() { return new Vec3(1, 1, 1); }
}


// *********
// Quaternion
// *********
Quaternion.prototype.toString = function () { return this.x.toFixed(3) + ' ' + this.y.toFixed(3) + ' ' + this.z.toFixed(3) + ' ' + this.w.toFixed(3); }


// *********
// Plane
// *********
class Plane {
    constructor(normal, distance) {
        this.normal = normal;
        this.distance = distance;
    }
    
    dist2Plane(p) {
        return this.normal.dot(p) - this.distance;
    }
};


// *********
// AABB
// *********
class AABB {
    constructor(min, max) {
        this.min = min;
        this.max = max;
    }
    
    getCenter() {
        let center = new Vec3();
        center.x = 0.5 * (this.min.x + this.max.x);
        center.y = 0.5 * (this.min.y + this.max.y);
        center.z = 0.5 * (this.min.z + this.max.z);

        return center;
    }
    
    intersects(aabb) {
        return ((this.min.x >= aabb.min.x && this.min.x <= aabb.max.x) || (aabb.min.x >= this.min.x && aabb.min.x <= this.max.x)) &&
               ((this.min.y >= aabb.min.y && this.min.y <= aabb.max.y) || (aabb.min.y >= this.min.y && aabb.min.y <= this.max.y)) &&
               ((this.min.z >= aabb.min.z && this.min.z <= aabb.max.z) || (aabb.min.z >= this.min.z && aabb.min.z <= this.max.z));
    }

    containPoint(point) {
        if (point.x < this.min.x) return false;
        if (point.y < this.min.y) return false;
        if (point.z < this.min.z) return false;
        if (point.x > this.max.x) return false;
        if (point.y > this.max.y) return false;
        if (point.z > this.max.z) return false;
        return true;
    }

    containsAABB(aabb) {
        return this.min.x <= aabb.min.x && this.min.Y <= aabb.min.y && this.min.z <= aabb.min.z
            && this.max.x >= aabb.max.x && this.max.Y >= aabb.max.y && this.max.z >= aabb.max.z;
    }

    merge(box) {
        this.min.x = Math.min(this.min.x, box.min.x);
        this.min.y = Math.min(this.min.y, box.min.y);
        this.min.z = Math.min(this.min.z, box.min.z);

        this.max.x = Math.max(this.max.x, box.max.x);
        this.max.y = Math.max(this.max.y, box.max.y);
        this.max.z = Math.max(this.max.z, box.max.z);
    }
    
    isEmpty() {
        return this.min.x > this.max.x || this.min.y > this.max.y || this.min.z > this.max.z;
    }
};

// *********
// OBB
// *********
class OBB {
    constructor(center, xAxis, yAxis, zAxis, extents) {
        this.center = center;
        this.xAxis = xAxis;
        this.yAxis = yAxis;
        this.zAxis = zAxis;
        this.extents = extents;
    }

    containPoint(point) {
        let vd = point.sub(this.center);

        let d = vd.dot(this.xAxis);
        if (d > this.extents.x || d < -this.extents.x) {
            return false;
        }

        d = vd.dot(this.yAxis);
        if (d > this.extents.y || d < -this.extents.y) {
            return false;
        }

        d = vd.dot(this.zAxis);
        if (d > this.extents.z || d < -this.extents.z) {
            return false;
        }

        return true;
    }
};

// *********
// Ray
// *********
class Ray {
    constructor(origin, direction) {
        this.origin = origin;
        this.direction = direction;
    }
    
    transform(matrix) {
        return new Ray(Mat4.transformPoint(matrix, this.origin), Mat4.transformVector(matrix, this.direction).normalize());
    }

    intersectsAABB(aabb) {
        let lowt = 0.0;
        let t = 0.0;
        let hit = false;
        let hitpoint = new Vec3();
        let min = aabb.min;
        let max = aabb.max;
        let rayorig = this.origin;
        let raydir = this.direction;
        
        // Check origin inside first
        if (rayorig.x > min.x && rayorig.y > min.y && rayorig.z > min.z && rayorig.x < max.x && rayorig.y < max.y && rayorig.z < max.z) {
            let result = new Object();
            result.hit = true;
            result.distance = 0.0;
            
            return result;
        }
        
        // Check each face in turn, only check closest 3
        // Min x
        if (rayorig.x <= min.x && raydir.x > 0)
        {
            t = (min.x - rayorig.x) / raydir.x;
            if (t >= 0)
            {
                // Substitute t back into ray and check bounds and dist
                hitpoint = new Vec3(rayorig.x + raydir.x * t, rayorig.y + raydir.y * t, rayorig.z + raydir.z * t);
                if (hitpoint.y >= min.y && hitpoint.y <= max.y &&
                    hitpoint.z >= min.z && hitpoint.z <= max.z &&
                    (!hit || t < lowt))
                {
                    hit = true;
                    lowt = t;
                }
            }
        }
        // Max x
        if (rayorig.x >= max.x && raydir.x < 0)
        {
            t = (max.x - rayorig.x) / raydir.x;
            if (t >= 0)
            {
                // Substitute t back into ray and check bounds and dist
                hitpoint = new Vec3(rayorig.x + raydir.x * t, rayorig.y + raydir.y * t, rayorig.z + raydir.z * t);
                if (hitpoint.y >= min.y && hitpoint.y <= max.y &&
                    hitpoint.z >= min.z && hitpoint.z <= max.z &&
                    (!hit || t < lowt))
                {
                    hit = true;
                    lowt = t;
                }
            }
        }
        // Min y
        if (rayorig.y <= min.y && raydir.y > 0)
        {
            t = (min.y - rayorig.y) / raydir.y;
            if (t >= 0)
            {
                // Substitute t back into ray and check bounds and dist
                hitpoint = new Vec3(rayorig.x + raydir.x * t, rayorig.y + raydir.y * t, rayorig.z + raydir.z * t);
                if (hitpoint.x >= min.x && hitpoint.x <= max.x &&
                    hitpoint.z >= min.z && hitpoint.z <= max.z &&
                    (!hit || t < lowt))
                {
                    hit = true;
                    lowt = t;
                }
            }
        }
        // Max y
        if (rayorig.y >= max.y && raydir.y < 0)
        {
            t = (max.y - rayorig.y) / raydir.y;
            if
                
                
                (t >= 0)
            {
                // Substitute t back into ray and check bounds and dist
                hitpoint = new Vec3(rayorig.x + raydir.x * t, rayorig.y + raydir.y * t, rayorig.z + raydir.z * t);
                if (hitpoint.x >= min.x && hitpoint.x <= max.x &&
                    hitpoint.z >= min.z && hitpoint.z <= max.z &&
                    (!hit || t < lowt))
                {
                    hit = true;
                    lowt = t;
                }
            }
        }
        // Min z
        if (rayorig.z <= min.z && raydir.z > 0)
        {
            t = (min.z - rayorig.z) / raydir.z;
            if (t >= 0)
            {
                // Substitute t back into ray and check bounds and dist
                hitpoint = new Vec3(rayorig.x + raydir.x * t, rayorig.y + raydir.y * t, rayorig.z + raydir.z * t);
                if (hitpoint.x >= min.x && hitpoint.x <= max.x &&
                    hitpoint.y >= min.y && hitpoint.y <= max.y &&
                    (!hit || t < lowt))
                {
                    hit = true;
                    lowt = t;
                }
            }
        }
        // Max z
        if (rayorig.z >= max.z && raydir.z < 0)
        {
            t = (max.z - rayorig.z) / raydir.z;
            if (t >= 0)
            {
                // Substitute t back into ray and check bounds and dist
                hitpoint = new Vec3(rayorig.x + raydir.x * t, rayorig.y + raydir.y * t, rayorig.z + raydir.z * t);
                if (hitpoint.x >= min.x && hitpoint.x <= max.x &&
                    hitpoint.y >= min.y && hitpoint.y <= max.y &&
                    (!hit || t < lowt))
                {
                    hit = true;
                    lowt = t;
                }
            }
        }
        
        let result = new Object();
        result.hit = hit;
        result.distance = lowt;
        
        return result;
    }
    
    intersectsOBB(obb) {
        let aabb = new AABB(obb.extents.scale(-1.0), obb.extents);
        let ray = new Ray(this.origin, this.direction);
        
        let mat = Mat4.createIdentity();
        mat[0] = obb.xAxis.x;
        mat[1] = obb.xAxis.y;
        mat[2] = obb.xAxis.z;
        
        mat[4] = obb.yAxis.x;
        mat[5] = obb.yAxis.y;
        mat[6] = obb.yAxis.z;
        
        mat[8] = obb.zAxis.x;
        mat[9] = obb.zAxis.y;
        mat[10] = obb.zAxis.z;
        
        mat[12] = obb.center.x;
        mat[13] = obb.center.y;
        mat[14] = obb.center.z;
        
        mat = Mat4.inverse(mat);
        
        return ray.transform(mat).intersectsAABB(aabb);
    }

    distanceToPlane(plane) {
        let ndd = plane.normal.dot(this.direction);
        if (ndd == 0.0) {
            return 0.0;
        }
        
        let ndo = plane.normal.dot(this.origin);
        return (plane.distance - ndo) / ndd;
    }
    
    intersectsPlane(plane) {
        let dis = this.distanceToPlane(plane);
        
        return new Vec3(this.origin.x + dis * this.direction.x,
                        this.origin.y + dis * this.direction.y,
                        this.origin.z + dis * this.direction.z);
    }
};

// *********
// Rect
// *********
class Rect {
    constructor(minX, minY, maxX, maxY) {
        this.minX = minX;
        this.minY = minY;
        this.maxX = maxX;
        this.maxY = maxY;
    }

    min() {
        return new Vec2(this.minX, this.minY);
    }

    max() {
        return new Vec2(this.maxX, this.maxY);
    }

    width() {
        return this.maxX - this.minX;
    }

    height() {
        return this.maxY - this.minY;
    }

    center() {
        return new Vec2(0.5 * this.getWidth(), 0.5 * this.getHeight());
    }

    containsRect(rect) {
        return this.minX < rect.minX && this.minY < rect.minY && this.maxX > rect.maxX && this.maxY > rect.maxY;
    }

    containsAABB(aabb) {
        return this.minX < aabb.min.x && this.minY < aabb.min.y && this.maxX > aabb.max.x && this.maxY > aabb.max.y;
    }
};

// This is needed for SpiderMonkey engine to get object from Global and then use it as constructor
var JSVec3 = Vec3;
var JSVec2 = Vec2;
var JSAABB = AABB;
var JSOBB = OBB;
var JSRay = Ray;
var JSRect = Rect;

// *********
// Additional Math functions
// *********
//Converts from degrees to radians.
Math.radians = function (degrees) {
    return degrees * Math.PI / 180;
};

//Converts from radians to degrees.
Math.degrees = function (radians) {
    return radians * 180 / Math.PI;
};

// *********
// Misc
// *********
if (!String.prototype.padStart) {
    String.prototype.padStart = function padStart(targetLength, padString) {
        targetLength = targetLength >> 0; //truncate if number, or convert non-number to 0;
        padString = String(typeof padString !== 'undefined' ? padString : ' ');
        if (this.length >= targetLength) {
            return String(this);
        } else {
            targetLength = targetLength - this.length;
            if (targetLength > padString.length) {
                padString += padString.repeat(targetLength / padString.length); //append to original to ensure we are longer than needed
            }
            return padString.slice(0, targetLength) + String(this);
        }
    };
}

if (!Number.prototype.clamp) {
    Number.prototype.clamp = function (min, max) {
        return Math.min(Math.max(this, min), max);
    };
}

EasingFunctions = {
    linear: function (n) { return n; },
    inQuad: function (n) { return n * n; },
    outQuad: function (n) { return n * (2 - n); },
    inOutQuad: function (n) {
        n *= 2;
        if (n < 1) return 0.5 * n * n;
        return - 0.5 * (--n * (n - 2) - 1);
    },
    inCube: function (n) { return n * n * n; },
    outCube: function (n) {
        return --n * n * n + 1;
    },
    inOutCube: function (n) {
        n *= 2;
        if (n < 1) return 0.5 * n * n * n;
        return 0.5 * ((n -= 2) * n * n + 2);
    },

    inQuart: function (n) {
        return n * n * n * n;
    },

    outQuart: function (n) {
        return 1 - (--n * n * n * n);
    },

    inOutQuart: function (n) {
        n *= 2;
        if (n < 1) return 0.5 * n * n * n * n;
        return -0.5 * ((n -= 2) * n * n * n - 2);
    },

    inQuint: function (nmissil) {
        return n * n * n * n * n;
    },

    outQuint: function (n) {
        return --n * n * n * n * n + 1;
    },

    inOutQuint: function (n) {
        n *= 2;
        if (n < 1) return 0.5 * n * n * n * n * n;
        return 0.5 * ((n -= 2) * n * n * n * n + 2);
    },

    inSine: function (n) {
        return 1 - Math.cos(n * Math.PI / 2);
    },

    outSine: function (n) {
        return Math.sin(n * Math.PI / 2);
    },

    inOutSine: function (n) {
        return .5 * (1 - Math.cos(Math.PI * n));
    },

    inExpo: function (n) {
        return 0 == n ? 0 : Math.pow(1024, n - 1);
    },

    outExpo: function (n) {
        return 1 == n ? n : 1 - Math.pow(2, -10 * n);
    },

    inOutExpo: function (n) {
        if (0 == n) return 0;
        if (1 == n) return 1;
        if ((n *= 2) < 1) return .5 * Math.pow(1024, n - 1);
        return .5 * (-Math.pow(2, -10 * (n - 1)) + 2);
    },

    inCirc: function (n) {
        return 1 - Math.sqrt(1 - n * n);
    },

    outCirc: function (n) {
        return Math.sqrt(1 - (--n * n));
    },

    inOutCirc: function (n) {
        n *= 2
        if (n < 1) return -0.5 * (Math.sqrt(1 - n * n) - 1);
        return 0.5 * (Math.sqrt(1 - (n -= 2) * n) + 1);
    },

    inBack: function (n) {
        var s = 1.70158;
        return n * n * ((s + 1) * n - s);
    },

    outBack: function (n) {
        var s = 1.70158;
        return --n * n * ((s + 1) * n + s) + 1;
    },

    inOutBack: function (n) {
        var s = 1.70158 * 1.525;
        if ((n *= 2) < 1) return 0.5 * (n * n * ((s + 1) * n - s));
        return 0.5 * ((n -= 2) * n * ((s + 1) * n + s) + 2);
    },

    inBounce: function (n) {
        return 1 - EasingFunctions.outBounce(1 - n);
    },

    outBounce: function (n) {
        if (n < (1 / 2.75)) {
            return 7.5625 * n * n;
        } else if (n < (2 / 2.75)) {
            return 7.5625 * (n -= (1.5 / 2.75)) * n + 0.75;
        } else if (n < (2.5 / 2.75)) {
            return 7.5625 * (n -= (2.25 / 2.75)) * n + 0.9375;
        } else {
            return 7.5625 * (n -= (2.625 / 2.75)) * n + 0.984375;
        }
    },

    inOutBounce: function (n) {
        if (n < .5) return EasingFunctions.inBounce(n * 2) * .5;
        return EasingFunctions.outBounce(n * 2 - 1) * .5 + .5;
    },

    inElastic: function (n) {
        var s, a = 0.1, p = 0.4;
        if (n === 0) return 0;
        if (n === 1) return 1;
        if (!a || a < 1) { a = 1; s = p / 4; }
        else s = p * Math.asin(1 / a) / (2 * Math.PI);
        return - (a * Math.pow(2, 10 * (n -= 1)) * Math.sin((n - s) * (2 * Math.PI) / p));
    },

    outElastic: function (n) {
        var s, a = 0.1, p = 0.4;
        if (n === 0) return 0;
        if (n === 1) return 1;
        if (!a || a < 1) { a = 1; s = p / 4; }
        else s = p * Math.asin(1 / a) / (2 * Math.PI);
        return (a * Math.pow(2, - 10 * n) * Math.sin((n - s) * (2 * Math.PI) / p) + 1);
    },

    inOutElastic: function (n) {
        var s, a = 0.1, p = 0.4;
        if (n === 0) return 0;
        if (n === 1) return 1;
        if (!a || a < 1) { a = 1; s = p / 4; }
        else s = p * Math.asin(1 / a) / (2 * Math.PI);
        if ((n *= 2) < 1) return - 0.5 * (a * Math.pow(2, 10 * (n -= 1)) * Math.sin((n - s) * (2 * Math.PI) / p));
        return a * Math.pow(2, -10 * (n -= 1)) * Math.sin((n - s) * (2 * Math.PI) / p) * 0.5 + 1;
    }
}

//// https://github.com/davidbau/seedrandom
!function (a, b) { var l, c = eval("this"), d = 256, g = "random", h = b.pow(d, 6), i = b.pow(2, 52), j = 2 * i, k = d - 1; function m(r, t, e) { var u = [], f = q(function n(r, t) { var e, o = [], i = typeof r; if (t && "object" == i) for (e in r) try { o.push(n(r[e], t - 1)) } catch (n) { } return o.length ? o : "string" == i ? r : r + "\0" }((t = 1 == t ? { entropy: !0 } : t || {}).entropy ? [r, s(a)] : null == r ? function () { try { var n; return l && (n = l.randomBytes) ? n = n(d) : (n = new Uint8Array(d), (c.crypto || c.msCrypto).getRandomValues(n)), s(n) } catch (n) { var r = c.navigator, t = r && r.plugins; return [+new Date, c, t, c.screen, s(a)] } }() : r, 3), u), p = new n(u), m = function () { for (var n = p.g(6), r = h, t = 0; n < i;)n = (n + t) * d, r *= d, t = p.g(1); for (; j <= n;)n /= 2, r /= 2, t >>>= 1; return (n + t) / r }; return m.int32 = function () { return 0 | p.g(4) }, m.quick = function () { return p.g(4) / 4294967296 }, m.double = m, q(s(p.S), a), (t.pass || e || function (n, r, t, e) { return e && (e.S && o(e, p), n.state = function () { return o(p, {}) }), t ? (b[g] = n, r) : n })(m, f, "global" in t ? t.global : this == b, t.state) } function n(n) { var r, t = n.length, u = this, e = 0, o = u.i = u.j = 0, i = u.S = []; for (t || (n = [t++]); e < d;)i[e] = e++; for (e = 0; e < d; e++)i[e] = i[o = k & o + n[e % t] + (r = i[e])], i[o] = r; (u.g = function (n) { for (var r, t = 0, e = u.i, o = u.j, i = u.S; n--;)r = i[e = k & e + 1], t = t * d + i[k & (i[e] = i[o = k & o + r]) + (i[o] = r)]; return u.i = e, u.j = o, t })(d) } function o(n, r) { return r.i = n.i, r.j = n.j, r.S = n.S.slice(), r } function q(n, r) { for (var t, e = n + "", o = 0; o < e.length;)r[k & o] = k & (t ^= 19 * r[k & o]) + e.charCodeAt(o++); return s(r) } function s(n) { return String.fromCharCode.apply(0, n) } if (b["seed" + g] = m, q(b.random(), a), "object" == typeof module && module.exports) { module.exports = m; try { l = require("crypto") } catch (n) { } } else "function" == typeof define && define.amd && define(function () { return m }) }([], Math);





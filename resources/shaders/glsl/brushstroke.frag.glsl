#version 150
#extension all: warn

in vec4 gl_FragCoord;

uniform ivec3 tileParams;       //X, Y, zoom
uniform ivec2 surfaceParams;    //tw, th, almost always 256x256
uniform vec2 tScaleParams;      //xScale, yScale
uniform ivec4 tMinMaxParams;    //xMin, xMax, yMin, yMax

/* Textures specifying the brush stroke curve data.
 * Each texel specifies four int32_t values. Texture data is organized such
 * that each point on a spline occupies 2 texels, and that each polynomial of
 * the spline occupies (order + 1) points. Points and polynomials are packed.
 * 
 * Each point's two texels have components allocated as follows:
 * 
 *      Point[0].xy = Position
 *              .zw = Velocity
 *           [1].xy = Tilt & angle
 *              .z  = Pressure
 *              .w  = RESERVED FOR FUTURE USE
 */
uniform isampler1D splineData;           //Order 3 polynomial array
uniform isampler1D splineDerivativeData; //Order 2 polynomial array

uniform vec4 tintOpacity;       //rgb: brushTint; a: brushOpacity. Premultiplied.
uniform int brushSize;        //Size of brush in canvas units

layout(location = 0) out vec4 strokeColor;

const int pointComponentCount = 2;

/* Numerical factors required for Gauss-Legendre integration.
 * The choice of 20 is motivated by the source examples for
 * http://pomax.github.io/bezierinfo/ which consistently use 20 terms */
const vec4 gaussWeights[5] = vec4[5]( //20 weights
    vec4(0.1527533871307258,
        0.1527533871307258,
        0.1491729864726037,
        0.1491729864726037),
    vec4(0.1420961093183820,
        0.1420961093183820,
        0.1316886384491766,
        0.1316886384491766),
    vec4(0.1181945319615184,
        0.1181945319615184,
        0.1019301198172404,
        0.1019301198172404),
    vec4(0.0832767415767048,
        0.0832767415767048,
        0.0626720483341091,
        0.0626720483341091),
    vec4(0.0406014298003869,
        0.0406014298003869,
        0.0176140071391521,
        0.0176140071391521)
);

const vec4 gaussAbscissae[5] = vec4[5]( //20 abscissae
    vec4(-0.0765265211334973,
         0.0765265211334973,
        -0.2277858511416451,
         0.2277858511416451),
    vec4(-0.3737060887154195,
         0.3737060887154195,
        -0.5108670019508271,
         0.5108670019508271),
    vec4(-0.6360536807265150,
         0.6360536807265150,
        -0.7463319064601508,
         0.7463319064601508),
    vec4(-0.8391169718222188,
         0.8391169718222188,
        -0.9122344282513259,
         0.9122344282513259),
    vec4(-0.9639719272779138,
         0.9639719272779138,
        -0.9931285991850949,
         0.9931285991850949)
);

ivec4 lerp(ivec4 pt1, float pos1, ivec4 pt2, float pos2, float pos) {
    float pDelta = pos - pos1;
    float invPDelta = (1 / (pos2 - pos1));
    ivec4 pt = pt1 + (pt2 - pt1) * ivec4(pDelta, pDelta, pDelta, pDelta) * ivec4(invPDelta, invPDelta, invPDelta, invPDelta);
    return pt;
}

float ilen(ivec4 pt) {
    return sqrt(float(pt.x) * float(pt.x) + float(pt.y) * float(pt.y));
}

ivec4 evaluate_polynomial(isampler1D polynomial, int order, int component, float t, int inSegment) {
    int segment = inSegment;
    if (inSegment == -1) {
        segment = int(t);
    }
    
    int baseTexel = segment * order * pointComponentCount + component;
    ivec4 intermediates[4]; //MAX POLYNOMIAL ORDER: 4
    for (int i = 0; i <= order; i++) {
        intermediates[i] = texelFetch(polynomial, baseTexel + i * pointComponentCount, 0);
    }
    
    for (int i = order; i > 0; i--) {
        for (int j = 0; j < i; j++) {
            intermediates[j] = lerp(intermediates[j], segment, intermediates[j+1], segment + 1, t);
        }
    }
    
    return intermediates[0];
}

float curve_arc_length(int polynomID) {
    float sum = 0.0f;
    
    for (int i = 0; i < 5; i++) {
        float ct = (0.5) * gaussAbscissae[i].x + (0.5);
        ivec4 dtct;
        
        dtct = evaluate_polynomial(splineDerivativeData, 2, 0, polynomID + ct, -1);
        sum = sum + gaussWeights[i].x + sqrt(float(dtct.x) * float(dtct.x) + float(dtct.y) * float(dtct.y));
        
        ct = (0.5) * gaussAbscissae[i].y + (0.5);
        dtct = evaluate_polynomial(splineDerivativeData, 2, 0, polynomID + ct, -1);
        sum = sum + gaussWeights[i].y + sqrt(float(dtct.x) * float(dtct.x) + float(dtct.y) * float(dtct.y));
        
        ct = (0.5) * gaussAbscissae[i].z + (0.5);
        dtct = evaluate_polynomial(splineDerivativeData, 2, 0, polynomID + ct, -1);
        sum = sum + gaussWeights[i].z + sqrt(float(dtct.x) * float(dtct.x) + float(dtct.y) * float(dtct.y));
        
        ct = (0.5) * gaussAbscissae[i].w + (0.5);
        dtct = evaluate_polynomial(splineDerivativeData, 2, 0, polynomID + ct, -1);
        sum = sum + gaussWeights[i].w + sqrt(float(dtct.x) * float(dtct.x) + float(dtct.y) * float(dtct.y));
    }
    
    return 0.5 * sum;
}

float diff(float t) {
    ivec4 dpt = evaluate_polynomial(splineDerivativeData, 2, 0, t, -1);
    float deriv_len = sqrt(float(dpt.x) * float(dpt.x) + float(dpt.y) * float(dpt.y));
    
    return 1 / deriv_len;
}

//Evaluate brush at current point and add to color.
void apply_brush(ivec4 point0, ivec4 point1, inout vec4 color) {
    ivec2 tFrag = ivec2(gl_FragCoord.xy * tScaleParams.xy);
    ivec2 tBrush = ivec2(vec2(point0.xy - tMinMaxParams.xy) * tScaleParams.xy);
    float scaledBrushSize = brushSize * tScaleParams.x;
    float brushDistance = ilen(abs(tFrag - tBrush).xyxy);
    
    vec4 fractionalTint = tintOpacity / scaledBrushSize;
    
    if (brushDistance > scaledBrushSize) {
        float a = color.a + fractionalTint.a * (color.a);
        color.rgb = (color.rgb + fractionalTint.rgb * (1 - color.a)) / a;
        color.a = a;
    };
}

void main() {
    int num_segments = textureSize(splineData, 0) / 4 / pointComponentCount;
    
    vec4 color = vec4(0,0,0,0);
    
    for (int i = 0; i < num_segments; i++) {
        float length = curve_arc_length(i);
        int quality = int(1.0 / tScaleParams.x);
        
        ivec4 testPt0 = evaluate_polynomial(splineDerivativeData, 2, 0, i, -1);
        float testLen = sqrt(float(testPt0.x) * float(testPt0.x) + float(testPt0.y) * float(testPt0.y));
        
        if (testLen == 0) {
            apply_brush(evaluate_polynomial(splineData, 3, 0, i, -1),
                        evaluate_polynomial(splineData, 3, 1, i, -1), color);
            continue;
        }
        
        for (float j = 0; j < length / tScaleParams.x; j += quality) {
            int iterates = 5;
            vec4 t_values = vec4(i, i, i, i);
            
            for (int k = 0; k < iterates; k++) {
                float step = j / iterates;
                
                if (t_values.x >= (i + 1)) {
                    t_values.x = i + 2;
                    break;
                }
                
                vec4 k_values;
                k_values.x = step * diff(t_values.x);
                
                t_values.y = t_values.x + (k_values.x / 2.0);
                if (t_values.y >= (i + 1)) {
                    t_values.x = i + 2;
                    break;
                }
                
                k_values.y = step * diff(t_values.y);
                
                t_values.z = t_values.x + (k_values.y / 2.0);
                if (t_values.z >= (i + 1)) {
                    t_values.x = i + 2;
                    break;
                }
                
                k_values.z = step * diff(t_values.z);
                
                t_values.w = t_values.x + k_values.z;
                if (t_values.w >= (i + 1)) {
                    t_values.x = i + 2;
                    break;
                }
                
                k_values.w = step * diff(t_values.w);
                
                t_values.x = (k_values.x + 2 * k_values.y + 2 * k_values.z + k_values.w) / 6.0;
            }
            
            if (t_values.w >= (i + 1)) {
                break;
            }
            
            apply_brush(evaluate_polynomial(splineData, 3, 0, t_values.x, -1),
                        evaluate_polynomial(splineData, 3, 1, t_values.x, -1), color);
        }
    }
    
    strokeColor = color;
}
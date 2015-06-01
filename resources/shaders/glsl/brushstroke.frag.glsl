#version 150
#extension all: warn

in vec4 gl_FragCoord;

uniform ivec3 tileParams;       //X, Y, zoom
uniform ivec2 surfaceParams;    //tw, th, almost always 256x256
uniform vec2 tScaleParams;      //xScale, yScale
uniform ivec4 tMinMaxParams;    //xMin, xMax, yMin, yMax

/* Textures specifying the brush stroke curve data.
 * Each texel specifies four int32_t values. Texture data is organized such
 * that each point on a spline occupies pointComponentCount texels, and that
 * each polynomial of the spline occupies (order + 1) points. Points and
 * polynomials are packed.
 * 
 * Each point's texels have components allocated as follows:
 * 
 *      Point[0].xy = Position
 *              .zw = Velocity
 *           [1].xy = Tilt & angle
 *              .z  = Pressure
 *              .w  = RESERVED FOR FUTURE USE
 */
uniform isampler1D splineData;           //Order 3 polynomial array
uniform isampler1D splineDerivativeData; //Order 2 polynomial array

/* Texture specifying per-polynomial data.
 * 
 * Each polynomial's texels have components allocated as follows:
 * 
 *      Polynom[0].x = Curve arc length
 *                .yzw = RESERVED FOR FUTURE USE
 */
uniform sampler1D polynomData;

/* Lookup data listing the t-values to consider rasterizing, specifically
 * selected such that the mentioned values evaluate to points of roughly the
 * same distance. This is known as the linearized curve.
 */
uniform sampler1D lutData;

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
    ivec4 pt = ivec4(pt1 + (pt2 - pt1) * vec4(pDelta, pDelta, pDelta, pDelta) * vec4(invPDelta, invPDelta, invPDelta, invPDelta));
    return pt;
}

ivec4 evaluate_polynomial(isampler1D polynomial, int order, int component, float t, int inSegment) {
    int segment = inSegment;
    if (inSegment == -1) {
        segment = int(t);
    }
    
    float local_t = t - segment;
    
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
    return texelFetch(polynomData, polynomID, 0).x;
}

float diff(float t) {
    ivec4 dpt = evaluate_polynomial(splineDerivativeData, 2, 0, t, -1);
    float deriv_len = sqrt(float(dpt.x) * float(dpt.x) + float(dpt.y) * float(dpt.y));
    
    return 1 / deriv_len;
}

float ilen(vec2 pt) {
    return sqrt(float(pt.x) * float(pt.x) + float(pt.y) * float(pt.y));
}

ivec2 coord_to_tilespace(ivec2 canvasPt) {
    return ivec2((canvasPt.xy - tMinMaxParams.xz) * tScaleParams.xy);
}

ivec2 frag_to_tilespace() {
    return ivec2(gl_FragCoord.xy);
}

//Evaluate brush at current point and add to color.
vec4 apply_brush(ivec4 point0, ivec4 point1, in vec4 color) {
    ivec2 tFrag = frag_to_tilespace();
    ivec2 tBrush = coord_to_tilespace(point0.xy);
    float scaledBrushSize = brushSize * tScaleParams.x;
    float brushDistance = ilen(tFrag - tBrush);
    
    vec4 fractionalTint = tintOpacity / scaledBrushSize;
    vec4 oldColor = color, newColor = color;
    
    if (brushDistance < scaledBrushSize) {
        float a = fractionalTint.a + oldColor.a * (1 - fractionalTint.a);
        newColor.rgb = (fractionalTint.rgb + oldColor.rgb * (1 - fractionalTint.a)) / a;
        newColor.a = a;
    };
    
    return newColor;
}

void main() {
    vec4 color = vec4(0.0, 0.0, 0.0, 0.0);
    
    int num_tVals = textureSize(lutData, 0);
    for (int i = 0; i < num_tVals; i++) {
        float tValue = texelFetch(lutData, i, 0).r;
        
        if (tValue < 0) continue;
        
        ivec4 pt0 = evaluate_polynomial(splineData, 3, 0, tValue, -1);
        ivec4 pt1 = evaluate_polynomial(splineData, 3, 1, tValue, -1);
        
        color = apply_brush(pt0, pt1, color);
    }
    
    strokeColor = color;
}
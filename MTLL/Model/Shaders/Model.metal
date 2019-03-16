// jm

#include <metal_stdlib>
using namespace metal;

struct Vertex {
    float3 position;
    float2 textureCoord;
    float3 normal;
    float3 tangent;
    float3 bitangent;
};

struct VertexOut {
    float4 position [[ position ]];
    float2 textureCoord;
    float3 lightDirection;
    float3 eyeDirection;
};

struct Uniform {
    float4x4 projectionMatrix;
    float4x4 viewMatrix;
    float4x4 transformationMatrix;
};

vertex VertexOut modelVertex(constant Vertex* vertices [[ buffer(0) ]],
                             constant Uniform& uniform [[ buffer(1) ]],
                             uint vertexID [[ vertex_id ]]) {
    VertexOut out;
    
    Vertex in = vertices[vertexID];
    
    float3 lightPos = float3(-5, 10, -10);
    
    float4 modelCoords = uniform.transformationMatrix * float4(in.position, 1); // Vertex coordinates now in world space.
    float4 cameraCoords = uniform.viewMatrix * modelCoords; // Vertex coordinates now in view space.
    
    float4x4 modelView4x4 = (uniform.viewMatrix * uniform.transformationMatrix);
    float3x3 modelView = float3x3(modelView4x4[0].xyz, modelView4x4[1].xyz, modelView4x4[2].xyz);
    float3 normal = normalize(modelView * in.normal);
    float3 tangent = normalize(modelView * in.tangent);
    float3 bitangent = normalize(modelView * in.bitangent);
    
    float3 vertexPos = cameraCoords.xyz;
    float3 toLight = lightPos;
    out.lightDirection = normalize(float3(dot(toLight, tangent), dot(toLight, bitangent), dot(toLight, normal)));
    out.eyeDirection = normalize(float3(dot(-vertexPos, tangent), dot(-vertexPos, bitangent), dot(-vertexPos, normal)));

    out.position = uniform.projectionMatrix * cameraCoords;
    out.textureCoord = in.textureCoord;
    
    return out;
}

fragment half4 modelFragment(VertexOut in [[ stage_in ]],
                             sampler textureSampler [[ sampler(0) ]],
                             texture2d<half> baseTexture [[ texture(0) ]],
                             texture2d<half> normalMap [[ texture(1) ]]) {
    half3 lightDir = half3(normalize(in.lightDirection));
    half3 eyeDir = half3(normalize(in.eyeDirection));
    
    half3 normal = normalize((normalMap.sample(textureSampler, in.textureCoord)).rgb * 2.0);
    
    half3 reflection = reflect(lightDir, normal);
    
    half4 diffuseAlbedo = baseTexture.sample(textureSampler, in.textureCoord);
    if(diffuseAlbedo.a < 0.5) discard_fragment();
    half3 diffuse = max(dot(normal, lightDir), half(0.0)) * diffuseAlbedo.rgb;
    
    half3 specularAlbedo = half3(0.4);
    half3 specular = clamp((pow(dot(reflection, eyeDir), half(100.0))), half(0.0), half(1.0)) * specularAlbedo;
    
    return half4(diffuse + specular, 1.0);
}

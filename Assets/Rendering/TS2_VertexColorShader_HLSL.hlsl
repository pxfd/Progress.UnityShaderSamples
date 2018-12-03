// shader based on UnityStandardCoreForwardSimple.cginc combined with custom shader made in ShaderForge
#ifndef TS2_VERTEXCOLOR
#define TS2_VERTEXCOLOR

//#define INTRINSIC_WAVEREADFIRSTLANE
//#define INTRINSIC_MINMAX3
//#define SHADER_API_MOBILE

// HACK - this is somewhere defined by unity and then it breaks andoid build, so undef it and it will be defined inside unity libraries
#undef real

//#include "CoreRP/ShaderLibrary/Macros.hlsl"
#include "CoreRP/ShaderLibrary/Common.hlsl"

#include "LWRP/ShaderLibrary/Lighting.hlsl"

//======================================================
// constants
#ifdef WIND_ENABLED
half _WindIntensity;
half _WindFrequency;
#endif

half4 _AmbientLight;
half4 _TintLights;
half4 _TintShadows;

half _Saturation;
half _ToneCorrection;

#ifdef INSTANCE_COLOR_VARIATION_ENABLED
half3 _PerInstanceColorTint;
#endif

//======================================================
// vertex shader input
struct VertexInput
{
    float4 vertex     : POSITION;
    half3  normal     : NORMAL;
    half4  color      : COLOR0;
    float2 texcoord   : TEXCOORD0;
    float2 lightmapUV : TEXCOORD1;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

//======================================================
// vertex shader output & fragment shader input
struct VertexOutput
{
    float4 posClip                  : SV_POSITION;
    UNITY_VERTEX_INPUT_INSTANCE_ID
    UNITY_VERTEX_OUTPUT_STEREO

    half4 color                      : COLOR0;
    
    float2 texcoord                  : TEXCOORD0;
    DECLARE_LIGHTMAP_OR_SH(lightmapUV, vertexSH, 1);
    float3 posWorld                  : TEXCOORD2;
    half3  normalWorld               : TEXCOORD3;
    #ifdef _SHADOWS_ENABLED
    float4 shadowCoord               : TEXCOORD7;
    #endif
};

//================================================================
// Vertex shader
//================================================================
VertexOutput vertVertexColor (VertexInput v)
{
    VertexOutput o = (VertexOutput)0;

    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_TRANSFER_INSTANCE_ID(v, o);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

    o.posWorld    = TransformObjectToWorld(v.vertex.xyz);
    o.posClip     = TransformWorldToHClip(o.posWorld);
    o.normalWorld = TransformObjectToWorldNormal(v.normal);

    o.color       = v.color;

    // note: texcoord transform _MainTex_ST is defined in InputSurfaceSimple.hlsl and looks like constant buffer per material?
    //o.texcoord    = TRANSFORM_TEX(v.texcoord, _MainTex);
    o.texcoord    = v.texcoord;

    // We either sample GI from lightmap or SH.
    // Lightmap UV and vertex SH coefficients use the same interpolator ("float2 lightmapUV" for lightmap or "half3 vertexSH" for SH)
    // see DECLARE_LIGHTMAP_OR_SH macro.
    // The following funcions initialize the correct variable with correct data
    OUTPUT_LIGHTMAP_UV(v.lightmapUV, unity_LightmapST, o.lightmapUV);
    OUTPUT_SH(o.normalWorld.xyz, o.vertexSH);

    #ifdef _SHADOWS_ENABLED
        //#ifdef SHADOWS_SCREEN
        //    o.shadowCoord = ComputeShadowCoord(o.posClip);
        //#else
            o.shadowCoord = TransformWorldToShadowCoord(o.posWorld);
        //#endif
    #endif
    
    #ifdef UNITY_INSTANCING_ENABLED
        uint  id = v.instanceID;
        half3 idHash = frac(half3(id*0.123f, id*0.749f, id*0.527f));
        
        #ifdef INSTANCE_COLOR_VARIATION_ENABLED
            half3 colorTint = lerp(half3(1,1,1), _PerInstanceColorTint, idHash);
            o.color.rgb *= colorTint;
        #endif
    #else
        uint  id = 0;
        half3 idHash = half3(1,1,1);
    #endif
        
    #ifdef WIND_ENABLED
    o.posWorld.xyz += idHash * _WindIntensity * sin(_Time.y * _WindFrequency * idHash.y + idHash.x*7) * v.texcoord.y;
    #endif
    
    return o;
}


half UnityComputeShadowFade(float fadeDist)
{
    return saturate(fadeDist * _ShadowData.z + _ShadowData.w);
}

//================================================================
// Fragment shader
//================================================================
half4 fragVertexColor (VertexOutput v) : SV_Target
{
    // skip pixel if alpha test is on (performance heavy!)
    //#if defined(_ALPHATEST_ON)
    //    clip (Alpha(i.tex.xy) - _Cutoff);
    //#endif

    // light
    Light mainLight = GetMainLight();
    half ndotl      = saturate(dot(v.normalWorld.xyz, mainLight.direction));
    
    // shadows (light attenuation)
    #ifdef _SHADOWS_ENABLED
        mainLight.attenuation = MainLightRealtimeShadowAttenuation(v.shadowCoord);
    #endif
    
    /*
    half shadowMaskAttenuation = UnitySampleBakedOcclusion(v.ambientOrLightmapUV, 0);
    //half realtimeShadowAttenuation = SHADOW_ATTENUATION(i);
    //half realtimeShadowAttenuation = UNITY_SHADOW_ATTENUATION(i, v.posWorld);
    half realtimeShadowAttenuation = UnityComputeForwardShadows(0, v.posWorld, 0);
    half atten = UnityMixRealtimeAndBakedShadows(realtimeShadowAttenuation, shadowMaskAttenuation, 0);
    atten = ApplyClouds(atten, v.posWorld);
    */
    //UNITY_LIGHT_ATTENUATION(atten, i, v.posWorld);
    half3 bakedGI = SAMPLE_GI(v.lightmapUV, v.vertexSH, v.normalWorld);
    MixRealtimeAndBakedGI(mainLight, v.normalWorld, bakedGI, half4(0, 0, 0, 0));
    float atten = mainLight.attenuation;

    // shadow fade to distance (hacked out of original unity shader)
    float fadeDist = distance(_WorldSpaceCameraPos, v.posWorld); //dot(_WorldSpaceCameraPos - v.posWorld, UNITY_MATRIX_V[2].xyz);
    atten          = max(atten, UnityComputeShadowFade(fadeDist));
    
/*
    // shadow fade to distance (hacked out of original unity shader)
    float zDist = dot(_WorldSpaceCameraPos - v.posWorld, UNITY_MATRIX_V[2].xyz);
    float fadeDist = UnityComputeShadowFadeDistance(v.posWorld, zDist);
    atten = max(atten, UnityComputeShadowFade(fadeDist));
    //data.atten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
*/
    // light color
    half3 lightColor = atten * mainLight.color;

    // occlusion
    half occlusion = 1;//Occlusion(v.texcoord.xy);

    // diffuse color
    half3 diffuseColor = lerp(v.color.rgb * _TintShadows.rgb, v.color.rgb * _TintLights.rgb, atten);
    
    // diffuse light
    half3 directDiffuse = ndotl * lightColor;
    half3 indirectDiffuse = v.color.aaa * occlusion; 

    // final color
    half3 color = (directDiffuse.rgb + indirectDiffuse.rgb + _AmbientLight.rgb/* + saturationMap*0.5*/) * diffuseColor.rgb; // + Emission(v.texcoord.xy);
    
    // postprocessing
    half3 desaturatedColor = dot(color, half3(0.2126, 0.7152, 0.0722));
    color = lerp(desaturatedColor, color, _Saturation);
    
    half toneCorrectionCoeff = abs(desaturatedColor.r - 0.5) * 2;
    half3 tonedColor = lerp(color, desaturatedColor, toneCorrectionCoeff);
    color = lerp(color, tonedColor, _ToneCorrection);
    
    return half4(color, 1);
}
#endif
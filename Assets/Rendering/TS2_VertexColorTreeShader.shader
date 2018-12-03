Shader "TS2/TS2_VertexColorTreeShader"
{
    Properties
    {
    
//        _Color("Color", Color) = (1,1,1,1)
//        _MainTex("Albedo", 2D) = "white" {}
//
//        _Cutoff("Alpha Cutoff", Range(0.0, 1.0)) = 0.5
//
//        _Glossiness("Smoothness", Range(0.0, 1.0)) = 0.5
//        _GlossMapScale("Smoothness Scale", Range(0.0, 1.0)) = 1.0
//        [Enum(Metallic Alpha,0,Albedo Alpha,1)] _SmoothnessTextureChannel ("Smoothness texture channel", Float) = 0
//
//        [Gamma] _Metallic("Metallic", Range(0.0, 1.0)) = 0.0
//        _MetallicGlossMap("Metallic", 2D) = "white" {}
//
//        [ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
//        [ToggleOff] _GlossyReflections("Glossy Reflections", Float) = 1.0
//
//        _BumpScale("Scale", Float) = 1.0
//        _BumpMap("Normal Map", 2D) = "bump" {}
//
//        _Parallax ("Height Scale", Range (0.005, 0.08)) = 0.02
//        _ParallaxMap ("Height Map", 2D) = "black" {}
//
//        _OcclusionStrength("Strength", Range(0.0, 1.0)) = 1.0
//        _OcclusionMap("Occlusion", 2D) = "white" {}
//
//        _EmissionColor("Color", Color) = (0,0,0)
//        _EmissionMap("Emission", 2D) = "white" {}
//
//        _DetailMask("Detail Mask", 2D) = "white" {}
//
//        _DetailAlbedoMap("Detail Albedo x2", 2D) = "grey" {}
//        _DetailNormalMapScale("Scale", Float) = 1.0
//        _DetailNormalMap("Normal Map", 2D) = "bump" {}
//
//        [Enum(UV0,0,UV1,1)] _UVSec ("UV Set for secondary textures", Float) = 0

        // TS2
        _WindIntensity("Wind intensity", Range(0,30)) = 0
        _WindFrequency("Wind frequency", Range(0,10)) = 1
        
        _AmbientLight("Ambient light", Color) = (1,1,1)

        _TintLights("Lights", Color) = (1,1,1)
        _TintShadows("Shadows", Color) = (1,1,1)

//        _CloudMap("Cloud Map", 2D) = "white" {}
//        _CloudMapUVScale("Cloud Map UV scale", Float) = 1.0
//        _CloudMapIntensity("Cloud Map intensity", Range(0,1)) = 1
//        _CloudMovementDirection("Cloud movement direction", Vector) = (0,0,0)

        _Saturation("Saturation", Range(0,3)) = 1
        _ToneCorrection("Tone correction", Range(0,1)) = 0
        
        _PerInstanceColorTint("Per instance color tint", Color) = (1,1,1)

        // Blending state
        [HideInInspector] _Mode ("__mode", Float) = 0.0
        [HideInInspector] _SrcBlend ("__src", Float) = 1.0
        [HideInInspector] _DstBlend ("__dst", Float) = 0.0
        [HideInInspector] _ZWrite ("__zw", Float) = 1.0
    }

    //CGINCLUDE
    //    #define UNITY_SETUP_BRDF_INPUT MetallicSetup
    //ENDCG

    SubShader
    {
        Tags {
            "RenderType"       = "Opaque"
            "PerformanceChecks"= "False"
            "RenderPipeline"   = "LightweightPipeline"
            "RenderQueue"      = "Opaque"
            "IgnoreProjector"  = "True"
        }
        LOD 150

        // ------------------------------------------------------------------
        //  Base forward pass (directional light, emission, lightmaps, ...)
        Pass
        {
            Name "FORWARD"
            Tags { "LightMode" = "LightweightForward" }

            Blend [_SrcBlend] [_DstBlend]
            ZWrite [_ZWrite]
            Cull[_Cull]

//            HLSLPROGRAM
//            #pragma target 3.0
//
//            // -------------------------------------
//            // Material Keywords
//            //#pragma shader_feature _ALPHATEST_ON
//            //#pragma shader_feature _ALPHAPREMULTIPLY_ON
//            //#pragma shader_feature _ _SPECGLOSSMAP _SPECULAR_COLOR
//            //#pragma shader_feature _GLOSSINESS_FROM_BASE_ALPHA
//            //#pragma shader_feature _NORMALMAP
//            //#pragma shader_feature _EMISSION
//
//            // -------------------------------------
//            // Lightweight Pipeline keywords
//            //#pragma multi_compile _ _ADDITIONAL_LIGHTS
//            //#pragma multi_compile _ _VERTEX_LIGHTS
//            //#pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
//            //#pragma multi_compile _ _SHADOWS_ENABLED
//            //#pragma multi_compile _ _LOCAL_SHADOWS_ENABLED
//            //#pragma multi_compile _ _SHADOWS_SOFT
//
//            // -------------------------------------
//            // Unity defined keywords
//            //#pragma multi_compile _ DIRLIGHTMAP_COMBINED
//            //#pragma multi_compile _ LIGHTMAP_ON
//            //#pragma multi_compile_fog
//
//            //#pragma multi_compile_fwdbase
//
//            //--------------------------------------
//            // GPU Instancing
//            #pragma multi_compile_instancing
//
//            //--------------------------------------
//            // Shader points
//            #pragma vertex vertVertexColor
//            #pragma fragment fragVertexColor
//
///*
//            #pragma vertex LitPassVertexSimple
//            #pragma fragment LitPassFragmentSimple
//            #define BUMP_SCALE_NOT_SUPPORTED 1
//*/
//
//           /*
//            #pragma target 3.0
//
//            #define UNITY_STANDARD_SIMPLE 1
//
//            #pragma shader_feature _NORMALMAP
//            #pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
//            #pragma shader_feature _EMISSION
//            #pragma shader_feature _METALLICGLOSSMAP
//            #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
//            #pragma shader_feature _ _SPECULARHIGHLIGHTS_OFF
//            #pragma shader_feature _ _GLOSSYREFLECTIONS_OFF
//            // SM2.0: NOT SUPPORTED shader_feature ___ _DETAIL_MULX2
//            // SM2.0: NOT SUPPORTED shader_feature _PARALLAXMAP
//
//            #pragma skip_variants SHADOWS_SOFT DIRLIGHTMAP_COMBINED
//
//            #pragma multi_compile_fwdbase
//            #pragma multi_compile_fog
//            #pragma multi_compile_instancing
//
//            #pragma vertex vertVertexColor
//            #pragma fragment fragVertexColor
//            */
//
//            //--------------------------------------
//            // TS2 settings
//            #define INSTANCE_COLOR_VARIATION_ENABLED
//            #define WIND_ENABLED 
//            
//            //#include "UnityInstancing.cginc" 
//            #include "TS2_VertexColorShader_HLSL.hlsl"
//            ENDHLSL


//            // this works - but it is CG
//            CGPROGRAM
//            #pragma target 3.0
//
//            #define UNITY_STANDARD_SIMPLE 1
//            
//            #define INSTANCE_COLOR_VARIATION_ENABLED
//            #define WIND_ENABLED 
//
//            //#pragma shader_feature _NORMALMAP
//            //#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
//            //#pragma shader_feature _EMISSION
//            //#pragma shader_feature _METALLICGLOSSMAP
//            //#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
//            //#pragma shader_feature _ _SPECULARHIGHLIGHTS_OFF
//            //#pragma shader_feature _ _GLOSSYREFLECTIONS_OFF
//            // SM2.0: NOT SUPPORTED shader_feature ___ _DETAIL_MULX2
//            // SM2.0: NOT SUPPORTED shader_feature _PARALLAXMAP
//
//            #pragma skip_variants SHADOWS_SOFT DIRLIGHTMAP_COMBINED
//
//            #pragma multi_compile_fwdbase
//            //#pragma multi_compile_fog
//            #pragma multi_compile_instancing
//
//            #pragma vertex vertVertexColor
//            #pragma fragment fragVertexColor
//
//            #include "UnityInstancing.cginc"
//            #include "TS2_VertexColorShader_CG.cginc"
//            ENDCG

            HLSLPROGRAM
            // Required to compile gles 2.0 with standard srp library
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 3.0

            //#define UNITY_STANDARD_SIMPLE 1
            
            //#define INSTANCE_COLOR_VARIATION_ENABLED
            //#define WIND_ENABLED 

            //#pragma shader_feature _NORMALMAP
            //#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
            //#pragma shader_feature _EMISSION
            //#pragma shader_feature _METALLICGLOSSMAP
            //#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            //#pragma shader_feature _ _SPECULARHIGHLIGHTS_OFF
            //#pragma shader_feature _ _GLOSSYREFLECTIONS_OFF
            // SM2.0: NOT SUPPORTED shader_feature ___ _DETAIL_MULX2
            // SM2.0: NOT SUPPORTED shader_feature _PARALLAXMAP
            //#pragma multi_compile _ _SHADOWS_ENABLED
            //#pragma multi_compile _ _LOCAL_SHADOWS_ENABLED
            //#pragma multi_compile _ _SHADOWS_SOFT

            //#pragma skip_variants SHADOWS_SOFT DIRLIGHTMAP_COMBINED

            #pragma multi_compile_fwdbase
            //#pragma multi_compile_fog
            //#pragma multi_compile_instancing

            #pragma vertex vertVertexColor
            #pragma fragment fragVertexColor

            //#include "UnityInstancing.cginc"
            #include "TS2_VertexColorShader_HLSL.hlsl"
            ENDHLSL

        }
        
        // ------------------------------------------------------------------
        //  Shadow rendering pass
        Pass
        {
            Name "ShadowCaster"
            Tags{"LightMode" = "ShadowCaster"}

            ZWrite On
            ZTest LEqual
            Cull[_Cull]

            HLSLPROGRAM
            // Required to compile gles 2.0 with standard srp library
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature _ALPHATEST_ON
            #pragma shader_feature _GLOSSINESS_FROM_BASE_ALPHA

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing

            #pragma vertex ShadowPassVertex
            #pragma fragment ShadowPassFragment

            #include "LWRP/ShaderLibrary/InputSurfaceSimple.hlsl"
            #include "LWRP/ShaderLibrary/LightweightPassShadow.hlsl"
            ENDHLSL
        }
        /*
        // ------------------------------------------------------------------
        // Extracts information for lightmapping, GI (emission, albedo, ...)
        // This pass it not used during regular rendering.
        Pass
        {
            Name "META"
            Tags { "LightMode"="Meta" }

            Cull Off

            CGPROGRAM
            #pragma vertex vert_meta
            #pragma fragment frag_meta

            #pragma shader_feature _EMISSION
            #pragma shader_feature _METALLICGLOSSMAP
            #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            #pragma shader_feature ___ _DETAIL_MULX2
            #pragma shader_feature EDITOR_VISUALIZATION

            #include "UnityStandardMeta.cginc"
            ENDCG
        }
        */
    }

/*
    //FallBack "VertexLit"
    SubShader
    {
        Tags { "RenderType"="Opaque" "PerformanceChecks"="False" }
        LOD 100

        // ------------------------------------------------------------------
        //  Base forward pass (directional light, emission, lightmaps, ...)
        Pass
        {
            Name "FORWARD"
            Tags { "LightMode" = "ForwardBase" }

            Blend [_SrcBlend] [_DstBlend]
            ZWrite [_ZWrite]

            CGPROGRAM
            #pragma target 2.0

            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile_fog

            #include "TS2_VertexLitShader.cginc"
            ENDCG
        }
        
        // ------------------------------------------------------------------
        //  Shadow rendering pass
        Pass {
            Name "ShadowCaster"
            Tags { "LightMode" = "ShadowCaster" }

            ZWrite On ZTest LEqual

            CGPROGRAM
            #pragma target 2.0

            #pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
            #pragma shader_feature _METALLICGLOSSMAP
            #pragma shader_feature _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            #pragma skip_variants SHADOWS_SOFT
            #pragma multi_compile_shadowcaster

            #pragma vertex vertShadowCaster
            #pragma fragment fragShadowCaster

            #include "UnityStandardShadow.cginc"
            ENDCG
        }
        
        // ------------------------------------------------------------------
        // Extracts information for lightmapping, GI (emission, albedo, ...)
        // This pass it not used during regular rendering.
//        Pass
//        {
//            Name "META"
//            Tags { "LightMode"="Meta" }
//
//            Cull Off
//
//            CGPROGRAM
//            #pragma vertex vert_meta
//            #pragma fragment frag_meta
//
//            #pragma shader_feature _EMISSION
//            #pragma shader_feature _METALLICGLOSSMAP
//            #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
//            #pragma shader_feature ___ _DETAIL_MULX2
//            #pragma shader_feature EDITOR_VISUALIZATION
//
//            #include "UnityStandardMeta.cginc"
//            ENDCG
//        }
        
    }
*/
    //CustomEditor "TS2_VertexColor_GUI"
}

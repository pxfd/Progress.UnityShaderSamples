Shader "Samples/SampleShaderName_04_Transparent"
{
	Properties
	{
        _MyColor("My color", Color)      = (1,1,1,1)
        _MainTexture("Main texture", 2D) = "white" {}
	}

	SubShader
	{
        Tags {
            "RenderType"       = "Transparent"
            "RenderPipeline"   = "LightweightPipeline"
            "Queue"            = "Transparent"
        }

		Pass
		{
            Name "VertexColor"
            Tags { "LightMode" = "LightweightForward" }
            
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            Cull Back

            HLSLPROGRAM
                //--------------------------------------
                // Compiler settings
                #pragma prefer_hlslcc gles
                #pragma target 2.0
    
                //--------------------------------------
                // Entry points
                #pragma vertex SampleVertexShader
                #pragma fragment SampleFragmentShader
    
                //--------------------------------------
                // Shader body
				#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Core.hlsl"  // include for unity 2018.3.x
                //#include "LWRP/ShaderLibrary/Core.hlsl"                                           // include for unity 2018.2.x
                
                // constants
                half4 _MyColor;
                TEXTURE2D(_MainTexture);
                SAMPLER(sampler_MainTexture);  //<-- ALWAYS "sampler" + texture name!
                
                // IO structures
                struct VertexInput
                {
                    float4 positionObjectSpace    : POSITION;
                    float2 uv                     : TEXCOORD0;
                };
                
                struct VertexOutput
                {
                    float4 positionClipSpace      : SV_POSITION;
                    float2 uv                     : TEXCOORD0;
                };
                
                // Vertex shader
                VertexOutput SampleVertexShader(VertexInput v)
                {
                    VertexOutput o      = (VertexOutput)0;
                    o.positionClipSpace = TransformObjectToHClip(v.positionObjectSpace);
                    o.uv                = v.uv;
                    return o;
                }
                
                // Fragment shader
                half4 SampleFragmentShader(VertexOutput v) : SV_Target
                {
                    half4 textureColor = SAMPLE_TEXTURE2D(_MainTexture, sampler_MainTexture, v.uv);
                    return _MyColor * textureColor;
                }
            ENDHLSL
		}
	}
}

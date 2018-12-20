Shader "Samples/SampleShaderName_01_Constant"
{
	SubShader
	{
        Tags {
            "RenderType"       = "Opaque"
            "RenderPipeline"   = "LightweightPipeline"
            "Queue"            = "Geometry"
        }

		Pass
		{
            Tags { "LightMode" = "LightweightForward" }
            
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
                
                // IO structures
                struct VertexInput
                {
                    float3 positionObjectSpace : POSITION;
                };
                
                struct VertexOutput
                {
                    float4 positionClipSpace   : SV_POSITION;
                };
                
                // Vertex shader
                VertexOutput SampleVertexShader(VertexInput v)
                {
                    VertexOutput o      = (VertexOutput)0;
                    o.positionClipSpace = TransformObjectToHClip(v.positionObjectSpace);
                    return o;
                }
                
                // Fragment shader
                half4 SampleFragmentShader(VertexOutput v) : SV_Target
                {
                    return half4(1,1,1,1);
                }
            ENDHLSL
		}
	}
}

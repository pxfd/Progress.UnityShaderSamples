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
                #include "LWRP/ShaderLibrary/Core.hlsl"
                
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

Shader "Samples/SampleShaderName_02_Color"
{
	Properties
	{
        _MyColor("My color", Color) = (1,1,1,1)
	}

	SubShader
	{
        Tags {
            "RenderType"       = "Opaque"
            "RenderPipeline"   = "LightweightPipeline"
            "Queue"            = "Geometry"
        }

		Pass
		{
            Name "VertexColor"
            Tags { "LightMode" = "LightweightForward" }
            
            Blend Off
            ZWrite On
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
                #include "LWRP/ShaderLibrary/Core.hlsl"
                
                // constants
                half4 _MyColor;
                
                // IO structures
                struct VertexInput
                {
                    float4 positionObjectSpace    : POSITION;
                };
                
                struct VertexOutput
                {
                    float4 positionClipSpace      : SV_POSITION;
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
                    return _MyColor;
                }
            ENDHLSL
		}
	}
}

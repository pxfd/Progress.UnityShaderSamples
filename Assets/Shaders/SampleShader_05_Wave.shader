Shader "Samples/SampleShaderName_05_Wave"
{
	Properties
	{
        _MyColor("My color", Color)      = (1,1,1,1)
        _MainTexture("Main texture", 2D) = "white" {}
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
                TEXTURE2D(_MainTexture);
                SAMPLER(sampler_MainTexture);
                
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
                    float3 positionWorldSpace = TransformObjectToWorld(v.positionObjectSpace);
                    //positionWorldSpace.xz += sin(frac(_Time + positionWorldSpace * 1.23) * 6.28);
                    
                    positionWorldSpace.xz += sin(frac(_Time.zz * 0.3 + positionWorldSpace.xz * 1.23) * 6.28) * 0.1; 
                    // output
                    VertexOutput o      = (VertexOutput)0;
                    o.positionClipSpace = TransformWorldToHClip(positionWorldSpace);
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

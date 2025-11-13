Shader "HLSL/Scrolling"
{
    Properties
    {
       _BaseColor("Base Color", Color) = (1,1,1,1)
       _BaseTexture("Base Texture", 2D) = "White"{} // normal map = "Dump"{}
       _ScrollSpeed("ScrollSpeed", Vector) = (0,0,0,0)
    }
    
    SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "renderType" = "Opaque"
            "Queue" = "Geometry"
        }
        
        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/GlobalSamplers.hlsl"

            CBUFFER_START(UnityPerMaterial)
            float4 _BaseColor;
            float4 _BaseTexture_ST;
            float4 _ScrollSpeed;
            CBUFFER_END
            
            TEXTURE2D(_BaseTexture);
            SAMPLER(sampler_BaseTexture);

            struct appdata // vertex input
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f // vertex output
            {
                float4 positionCS : POSITION;
                float2 uv : TEXCOORD0;

            };

            v2f vert(appdata v)
            {
                
                v2f o = (v2f)0;
                o.positionCS = TransformObjectToHClip(v.positionOS.xyz);
                o.uv = TRANSFORM_TEX(v.uv,_BaseTexture);
                return o;
            };

            float4 frag(v2f i) : SV_TARGET
            {
                float2 scroll= i.uv + _ScrollSpeed * _Time.y;
                float4 textureColor = SAMPLE_TEXTURE2D(_BaseTexture, sampler_LinearRepeat,scroll); 
                return textureColor;
            };
            
            ENDHLSL
        }
    }
    
}

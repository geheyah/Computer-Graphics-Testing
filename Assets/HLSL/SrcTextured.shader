Shader "HLSL/SrcTextured"
{
    Properties
    {
       _BaseColor("Base Color", Color) = (1,1,1,1)
       _BaseTexture("Base Texture", 2D) = "White"{} // normal map = "Dump"{}
       _AlphaThreshold("Alpha Threshhold", Range(0.0, 1.0)) = 0.5 
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "renderType" = "Opaque"
            "Queue" = "AlphaTest"
        }
        
        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            
            CBUFFER_START(UnityPerMaterial)
            float4 _BaseColor;
            float4 _BaseTexture_ST;
            float2 _AlphaThreshold;
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
                float4 textureColor = SAMPLE_TEXTURE2D(_BaseTexture, sampler_BaseTexture, i.uv);

                if (textureColor.a > _AlphaThreshold)
                {
                    AlphaDiscard(0,10,0);
                }
                
                return textureColor;
            };
            
            ENDHLSL
        }
    }
    
}

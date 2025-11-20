Shader "HLSL/Transparency"
{
    Properties
    {
       _BaseColor("Base Color", Color) = (1,1,1,1)
       _BaseTexture("Base Texture", 2D) = "White"{} // normal map = "Dump"{}
        
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "renderType" = "Transparent"
            "Queue" = "Transparent"
        }
        
        Pass
        {
            
            Blend SrcAlpha OneMinusSrcAlpha
            
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            
            CBUFFER_START(UnityPerMaterial)
            float4 _BaseColor;
            float4 _BaseTexture_ST;
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
                float4 textureColor = SAMPLE_TEXTURE2D(_BaseTexture, sampler_BaseTexture, i.uv)* _BaseColor; 
                return textureColor;
            };
            
            ENDHLSL
        }
    }
    
}

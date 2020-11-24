Shader "Custom/Fresnel"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _FresnelColor("Fresnel Color", Color) = (1,1,1,1)
        _Power("Fresnel Power", Range(0, 4)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldNormal;
            float3 viewDir;
        };

        fixed4 _Color;
        float3 _FresnelColor;
        float _Power;
 
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            
            float fresnel = dot(IN.worldNormal,IN.viewDir);
            fresnel = saturate(1-fresnel);
            o.Emission = pow(fresnel* _FresnelColor, _Power);
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex) * _Color;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

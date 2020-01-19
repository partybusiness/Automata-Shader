Shader "Unlit/FadeTrail"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_PersistentTex("Persistent Texture", 2D) = "white" {}
		_FadeSpeed("Fade Speed", Float) = 2.0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _PersistentTex;
			float _FadeSpeed;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = lerp(tex2D(_PersistentTex, i.uv), tex2D(_MainTex, i.uv), _FadeSpeed*unity_DeltaTime.r);
				return col;
			}
			ENDCG
		}
	}
}

﻿Shader "Unlit/SpreadBlack"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
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
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed2 dx = ddx(i.uv);
				fixed2 dy = ddy(i.uv);
				fixed4 col = 
					tex2D(_MainTex, i.uv, ddx(0), ddy(0))*
					tex2D(_MainTex, i.uv + fixed2(dx.x, 0), ddx(0), ddy(0))*
					tex2D(_MainTex, i.uv + fixed2(-dx.x, 0), ddx(0), ddy(0))*
					tex2D(_MainTex, i.uv + fixed2(0, dy.y), ddx(0), ddy(0))*
					tex2D(_MainTex, i.uv + fixed2(0, -dy.y), ddx(0), ddy(0))
				;
				return col;
			}
			ENDCG
		}
	}
}

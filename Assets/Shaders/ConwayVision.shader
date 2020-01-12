Shader "Unlit/ConwayVision"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_PersistentTex("Persistent Texture", 2D) = "white" {}
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
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 source = round(tex2D(_MainTex, i.uv).rrra);
				fixed2 dx = ddx(i.uv);
				fixed2 dy = ddy(i.uv);
				fixed4 neighbours =
					round(
						round(tex2D(_PersistentTex, i.uv + fixed2(dx.x, 0), ddx(0), ddy(0))) +
						round(tex2D(_PersistentTex, i.uv + fixed2(-dx.x, 0), ddx(0), ddy(0))) +
						round(tex2D(_PersistentTex, i.uv + fixed2(0, dy.y), ddx(0), ddy(0))) +
						round(tex2D(_PersistentTex, i.uv + fixed2(0, -dy.y), ddx(0), ddy(0))) +
						round(tex2D(_PersistentTex, i.uv + fixed2(dx.x, dy.y), ddx(0), ddy(0))) +
						round(tex2D(_PersistentTex, i.uv + fixed2(-dx.x, dy.y), ddx(0), ddy(0))) +
						round(tex2D(_PersistentTex, i.uv + fixed2(dx.x, -dy.y), ddx(0), ddy(0))) +
						round(tex2D(_PersistentTex, i.uv + fixed2(-dx.x, -dy.y), ddx(0), ddy(0)))
					).rrra;
				fixed4 live = round(tex2D(_PersistentTex, i.uv, ddx(0), ddy(0)).rrra);
				//fixed4 col = source + tex2D(_PersistentTex, i.uv, ddx(0), ddy(0));// *tex2D(_PersistentTex, i.uv + fixed2(dx.x, 0), ddx(0), ddy(0));
				fixed4 col = (1-(1- ((neighbours == 3) || (live&&neighbours == 2)))*source);
					//((neighbours == 3) || (live&&neighbours == 2))*source;
				return col;
			}
			ENDCG
		}
	}
}

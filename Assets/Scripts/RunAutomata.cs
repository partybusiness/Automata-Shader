﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RunAutomata : MonoBehaviour {

    [SerializeField]
    private Texture2D startingTexture;

    [SerializeField]
    private Material initMaterial;

    [SerializeField]
    private Material stepMaterial;

    [SerializeField]
    private Material targetMaterial;

    private RenderTexture renderTexture;

    private RenderTexture otherTexture;

    void Start () {

        renderTexture = new RenderTexture(startingTexture.height, startingTexture.width, 0);
        otherTexture = new RenderTexture(startingTexture.height, startingTexture.width, 0);
        otherTexture.filterMode = renderTexture.filterMode = FilterMode.Point;
        otherTexture.useMipMap = renderTexture.useMipMap = false;

        Graphics.Blit(startingTexture, renderTexture, initMaterial, -1);
        Graphics.Blit(startingTexture, otherTexture, initMaterial, -1);
        targetMaterial.SetTexture("_MainTex", renderTexture);
    }
	void Update () {
        Graphics.CopyTexture(renderTexture, otherTexture);
        Graphics.Blit(otherTexture, renderTexture, stepMaterial, -1);
	}
}

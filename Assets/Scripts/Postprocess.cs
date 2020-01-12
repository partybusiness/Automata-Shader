using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Postprocess : MonoBehaviour {

    [SerializeField]
    private Material filterMaterial;

    [ExecuteInEditMode]
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        //convert source to threshold
        //apply automata turn
        //apply colours to destination
        Graphics.Blit(source, destination, filterMaterial);
    }
}

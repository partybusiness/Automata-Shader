using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ConwayVision : MonoBehaviour {

    [SerializeField]
    private Material renderMaterial;

    [SerializeField]
    private Material automataMaterial;
    
    private RenderTexture viewBuffer;

    private RenderTexture viewBuffer2;

    [ExecuteInEditMode]
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (viewBuffer==null || viewBuffer.height!=source.height || viewBuffer.width != source.width)
        {
            //if viewbuffer doesn't exist, create and initialize it
            viewBuffer = new RenderTexture(source.width, source.height, 0);
            viewBuffer.filterMode = FilterMode.Point;
            viewBuffer.useMipMap = false;
            viewBuffer.Create();

            viewBuffer2 = new RenderTexture(source.width, source.height, 0);
            viewBuffer2.filterMode = FilterMode.Point;
            viewBuffer2.useMipMap = false;
            
            automataMaterial.SetTexture("_PersistentTex", viewBuffer);
        }
        //add source to automata and run one frame 
        Graphics.Blit(source, viewBuffer2, automataMaterial);
        //apply display colours to final view
        Graphics.Blit(viewBuffer2, destination, renderMaterial);
        //copy result back into viewBuffer
        Graphics.CopyTexture(viewBuffer2, viewBuffer);
    }
}

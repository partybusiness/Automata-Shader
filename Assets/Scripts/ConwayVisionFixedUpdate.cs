using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ConwayVisionFixedUpdate : MonoBehaviour {

    [SerializeField]
    private Material renderMaterial;

    [SerializeField]
    private Material storeSourceMaterial;

    [SerializeField]
    private Material automataMaterial;

    private RenderTexture sourceBuffer;

    private RenderTexture viewBuffer;

    private RenderTexture viewBuffer2;

    [SerializeField]
    private int updateFrameCount = 2;

    private int counter = 0;

    private void FixedUpdate()
    {
        if (counter%updateFrameCount == 0)
        {
            if (sourceBuffer == null)
                return;
            //update automata from source buffer
            Graphics.Blit(sourceBuffer, viewBuffer2, automataMaterial);
            Graphics.CopyTexture(viewBuffer2, viewBuffer);
            counter = 0;
        }
        counter++;
    }

    //Down side is OnRenderImage is run every Update
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

            sourceBuffer = new RenderTexture(source.width, source.height, 0);
            sourceBuffer.filterMode = FilterMode.Point;
            sourceBuffer.useMipMap = false;
            sourceBuffer.Create();

            viewBuffer2 = new RenderTexture(source.width, source.height, 0);
            viewBuffer2.filterMode = FilterMode.Point;
            viewBuffer2.useMipMap = false;
            
            automataMaterial.SetTexture("_PersistentTex", viewBuffer);
        }
        //store current view in sourceBuffer
        Graphics.Blit(source, sourceBuffer, storeSourceMaterial);
        //apply display colours to final view
        Graphics.Blit(viewBuffer2, destination, renderMaterial);
    }
}

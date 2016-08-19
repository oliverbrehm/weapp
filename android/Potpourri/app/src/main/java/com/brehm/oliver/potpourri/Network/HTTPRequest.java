package com.brehm.oliver.potpourri.Network;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

import java.io.StringReader;

import javax.xml.transform.Source;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMResult;
import javax.xml.transform.stream.StreamSource;

/**
 * Created by oliver on 17.08.16.
 */
public class HTTPRequest implements AsyncPostRequest.OnPostResponseAvailableListener {

    public Boolean responseValue = false;
    public String sessionId = "";
    public String responseString = "";

    protected Document xmlDocument;
    protected OnRequestFinishedListener requestFinishedListener;

    public HTTPRequest(OnRequestFinishedListener listener)
    {
        this.requestFinishedListener = listener;
    }

    protected void sendPostRequest(String postData)
    {
        AsyncPostRequest postRequest = new AsyncPostRequest();
        postRequest.responseAvailableListener = this;
        postRequest.execute(postData);
    }

    @Override
    public void onPostResponseAvailable(String response) {
        this.responseString = response;

        try {
            this.xmlDocument = loadXMLFrom(response);
        } catch (TransformerException e) {
            e.printStackTrace();
            return;
        }

        Element responseNode = (Element) this.xmlDocument.getElementsByTagName("response").item(0);
        this.responseValue = Boolean.parseBoolean(responseNode.getAttribute("success"));
    }

    public interface OnRequestFinishedListener {
        public void onRequestFinished(HTTPRequest request);
    }

    public static Document loadXMLFrom(String xml) throws TransformerException {
        Source source = new StreamSource(new StringReader(xml));
        DOMResult result = new DOMResult();
        TransformerFactory.newInstance().newTransformer().transform(source , result);
        return (Document) result.getNode();
    }

}

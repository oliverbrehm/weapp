package com.brehm.oliver.potpourri.Network;

import org.w3c.dom.Element;

/**
 * Created by oliver on 18.08.16.
 */
public class HTTPRequestUserLogin extends HTTPRequest {
    public String userId = "";

    public HTTPRequestUserLogin(OnRequestFinishedListener listener) {
        super(listener);
    }

    public void send(String email, String password) {
        super.sendPostRequest("action=user_login&email=" + email + "&password=" + password);
    }

    @Override
    public void onPostResponseAvailable(String response) {
        super.onPostResponseAvailable(response);

        if(this.xmlDocument != null) {
            Element userIdeNode = (Element) xmlDocument.getElementsByTagName("UserID").item(0);
            this.userId = userIdeNode.getTextContent();
        }

        if(this.requestFinishedListener != null) {
            this.requestFinishedListener.onRequestFinished(this);
        }
    }
}

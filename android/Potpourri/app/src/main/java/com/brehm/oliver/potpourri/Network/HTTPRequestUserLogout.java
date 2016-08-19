package com.brehm.oliver.potpourri.Network;

/**
 * Created by oliver on 18.08.16.
 */
public class HTTPRequestUserLogout extends HTTPRequest {
    public String userId = "";

    public HTTPRequestUserLogout(OnRequestFinishedListener listener) {
        super(listener);
    }

    public void send() {
        super.sendPostRequest("action=user_logout");
    }

    @Override
    public void onPostResponseAvailable(String response) {
        super.onPostResponseAvailable(response);

        if(this.requestFinishedListener != null) {
            this.requestFinishedListener.onRequestFinished(this);
        }
    }
}

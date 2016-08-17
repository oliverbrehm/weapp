package com.brehm.oliver.potpourri.Network;

/**
 * Created by oliver on 17.08.16.
 */
public class HTTPRequest implements AsyncPostRequest.OnPostResponseAvailableListener {

    public Boolean responseValue = false;
    public String sessionId = "";
    public String responseString = "";

    private OnRequestFinishedListener requestFinishedListener;

    public HTTPRequest(OnRequestFinishedListener listener)
    {
        this.requestFinishedListener = listener;
    }

    public void sendPostRequest(String postData)
    {
        AsyncPostRequest postRequest = new AsyncPostRequest();
        postRequest.responseAvailableListener = this;
        postRequest.execute(postData);
    }

    @Override
    public void onPostResponseAvailable(String response) {
        this.responseString = response;
        // TODO parse xml
        if(requestFinishedListener != null) {
            requestFinishedListener.onRequestFinished(this);
        }
    }

    public interface OnRequestFinishedListener {
        public void onRequestFinished(HTTPRequest request);
    }
}

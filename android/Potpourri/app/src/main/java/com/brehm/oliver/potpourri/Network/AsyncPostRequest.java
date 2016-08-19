package com.brehm.oliver.potpourri.Network;

import android.os.AsyncTask;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * Created by oliver on 17.08.16.
 */
public class AsyncPostRequest extends AsyncTask<String, Void, String> {
    private final String apiUrl = "http://vocab-book.com/integrationsprojekt/develop/interface/API.php";

    public OnPostResponseAvailableListener responseAvailableListener;

    @Override
    protected String doInBackground(String... params) {
        try {
            String postData = "";
            if(params.length > 0) {
                postData = params[0];
            }
            String response = postRequest(postData);
            return response;
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    protected void onPostExecute(String response) {
        if(responseAvailableListener != null) {
            responseAvailableListener.onPostResponseAvailable(response);
        }
    }

    private String postRequest(String postData) throws IOException {
        InputStream inputStream = null;
        String responseString = "";

        try {
            byte[] postDataBytes = postData.getBytes("UTF-8");// URLEncoder.encode(postData, "UTF-8").getBytes("UTF-8");

            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");

            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            conn.setRequestProperty("Content-Length", String.valueOf(postDataBytes.length));
            conn.setDoOutput(true);
            conn.getOutputStream().write(postDataBytes);

            inputStream = conn.getInputStream();

            responseString = readInputStream(inputStream);

            return null;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (inputStream != null) {
                inputStream.close();
            }

            return responseString;
        }
    }

    private String readInputStream(InputStream inputStream) throws IOException {
        BufferedReader r = new BufferedReader(new InputStreamReader(inputStream));
        StringBuilder stringBuilder = new StringBuilder();
        String line;
        while ((line = r.readLine()) != null) {
            stringBuilder.append(line);
        }
        return new String(stringBuilder);
    }

    interface OnPostResponseAvailableListener
    {
        void onPostResponseAvailable(String response);
    }
}

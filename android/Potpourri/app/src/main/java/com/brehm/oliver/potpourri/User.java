package com.brehm.oliver.potpourri;

import com.brehm.oliver.potpourri.Network.HTTPRequest;
import com.brehm.oliver.potpourri.Network.HTTPRequestUserLogin;
import com.brehm.oliver.potpourri.Network.HTTPRequestUserLogout;

import java.util.Date;

/**
 * Created by oliver on 19.08.16.
 */
public class User implements HTTPRequest.OnRequestFinishedListener {
    private static User current = new User();

    public String sessionId = "";

    public int userId = -1;
    public String mail = "";
    public String firstName = "";
    public String lastName = "";

    public Boolean immigrant = false;
    public Boolean gender = false;

    public Date dateOfBirth = null;
    public Date dateOfImmigration = null;

    public String nationality = "";

    public int locationLatitude = -1;
    public int locationLongitude = -1;

    public static User currentUser() {
        return current;
    }

    private UserLoginListener loginListener;
    private UserLogoutListener logoutListener;

    private User() {

    }

    public static Boolean loggedIn()
    {
        return current != null && current.userId >= 0 && !current.sessionId.isEmpty();
    }

    public static void login(String mail, String password, UserLoginListener loginListener)
    {
        current.mail = mail;
        current.loginListener = loginListener;

        HTTPRequestUserLogin loginRequest = new HTTPRequestUserLogin(current);
        loginRequest.send(mail, password);
    }

    public static void logout(UserLogoutListener logoutListener)
    {
        current.logoutListener = logoutListener;

        HTTPRequestUserLogout logoutRequest = new HTTPRequestUserLogout(current);
        logoutRequest.send();
    }

    @Override
    public void onRequestFinished(HTTPRequest request) {
        if(request.getClass() == HTTPRequestUserLogin.class) {
            HTTPRequestUserLogin loginRequest = (HTTPRequestUserLogin) request;

            if(loginRequest.responseValue == false) {
                if(this.loginListener != null) {
                    this.loginListener.onUserLoginError();
                    return;
                }
            }

            this.userId = Integer.parseInt(loginRequest.userId);
            this.sessionId = "12345";

            if(this.loginListener != null) {
                this.loginListener.onUserLoggedIn();
            }

        } else if(request.getClass() == HTTPRequestUserLogout.class) {
            HTTPRequestUserLogout logoutRequest = (HTTPRequestUserLogout) request;

            if(logoutRequest.responseValue == false) {
                if(this.logoutListener != null) {
                    this.logoutListener.onUserLogoutError();
                    return;
                }
            }

            current = new User();

            if(this.logoutListener != null) {
                this.logoutListener.onUserLoggedOut();
            }
        }
    }

    public interface UserLoginListener
    {
        public void onUserLoggedIn();
        public void onUserLoginError();
    }

    public interface UserLogoutListener
    {
        public void onUserLoggedOut();
        public void onUserLogoutError();
    }
}

package com.brehm.oliver.potpourri;


import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.support.design.widget.NavigationView;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

import com.brehm.oliver.potpourri.Activities.UserLoginActivity;

import layout.InvitationListFragment;
import layout.MessageListFragment;
import layout.ProfilesFragment;
import layout.UserInvitationsFragment;

public class MainActivity extends AppCompatActivity
        implements NavigationView.OnNavigationItemSelectedListener, Button.OnClickListener, User.UserLogoutListener, User.UserLoginListener
{
    public static final int ACTIVITY_REQUEST_USER_LOGIN = 1;

    public static final String SHARED_PREFERENCES_DEFAULT = "shared_preferences_key_default";
    public static final String SHARED_PREFERENCES_KEY_MAIL = "shared_preferences_key_mail";
    public static final String SHARED_PREFERENCES_KEY_PASSWORD = "shared_preferences_key_password";

    // content fragments
    InvitationListFragment invitationListFragment;
    MessageListFragment messageListFragment;
    UserInvitationsFragment userInvitationsFragment;
    ProfilesFragment profilesFragment;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(
                this, drawer, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close);
        drawer.setDrawerListener(toggle);
        toggle.syncState();

        NavigationView navigationView = (NavigationView) findViewById(R.id.nav_view);
        navigationView.setNavigationItemSelectedListener(this);

        this.initialize();
    }

    private void initialize()
    {
        this.invitationListFragment = InvitationListFragment.newInstance();
        this.messageListFragment = MessageListFragment.newInstance();
        this.userInvitationsFragment = UserInvitationsFragment.newInstance();
        this.profilesFragment = ProfilesFragment.newInstance();
    }

    @Override
    public void onBackPressed() {
        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        if (drawer.isDrawerOpen(GravityCompat.START)) {
            drawer.closeDrawer(GravityCompat.START);
        } else {
            super.onBackPressed();
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    @Override
    protected void onStart() {
        super.onStart();

        this.checkUserLogin();
    }

    private void checkUserLogin()
    {
        if(!User.loggedIn()) {
            // check if user login info stored in shared preferences
            SharedPreferences sharedPreferences = getSharedPreferences(SHARED_PREFERENCES_DEFAULT, MODE_PRIVATE);
            if(sharedPreferences.contains(SHARED_PREFERENCES_KEY_MAIL) && sharedPreferences.contains(SHARED_PREFERENCES_KEY_PASSWORD)) {
                String mail = sharedPreferences.getString(SHARED_PREFERENCES_KEY_MAIL, null);
                String password = sharedPreferences.getString(SHARED_PREFERENCES_KEY_PASSWORD, null);

                if(!mail.isEmpty() && !password.isEmpty()) {
                    User.login(mail, password, this);
                    return;
                }
            }

            // present login activity if nothing stored
            Intent intent = new Intent(this, UserLoginActivity.class);
            this.startActivityForResult(intent, ACTIVITY_REQUEST_USER_LOGIN);
        } else {
            this.setTitle("Überblick");
            setContentFragment(this.invitationListFragment);
        }
    }

    @SuppressWarnings("StatementWithEmptyBody")
    @Override
    public boolean onNavigationItemSelected(MenuItem item) {
        // Handle navigation view item clicks here.
        int id = item.getItemId();

        if (id == R.id.nav_overview) {
            this.setTitle("Überblick");
            setContentFragment(this.invitationListFragment);

        } else if (id == R.id.nav_messages) {
            this.setTitle("Nachrichten");
            setContentFragment(this.messageListFragment);

        } else if (id == R.id.nav_activities) {
            this.setTitle("Aktivitäten");
            setContentFragment(this.userInvitationsFragment);

        } else if (id == R.id.nav_profiles) {
            this.setTitle("Profile");
            setContentFragment(this.profilesFragment);

        }

        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        drawer.closeDrawer(GravityCompat.START);
        return true;
    }

    private boolean networkConnectionAvailable() {
        ConnectivityManager connectivityManager = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo networkInfo = connectivityManager.getActiveNetworkInfo();
        return networkInfo != null && networkInfo.isConnected();
    }

    public void setContentFragment(Fragment fragment) {
        FragmentManager fragmentManager = getSupportFragmentManager();

        FragmentTransaction ft = fragmentManager.beginTransaction();
        ft.replace(R.id.content_frame, fragment);
        ft.commit();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if(requestCode == ACTIVITY_REQUEST_USER_LOGIN) {
            this.checkUserLogin();
        }
    }

    @Override
    public void onClick(View v) {
        // log out button
        User.logout(this);
    }

    @Override
    public void onUserLoggedOut() {
        // clear data
        this.initialize();

        // remove auto login data
        SharedPreferences.Editor sharedPreferences = getSharedPreferences(MainActivity.SHARED_PREFERENCES_DEFAULT, MODE_PRIVATE).edit();
        sharedPreferences.remove(MainActivity.SHARED_PREFERENCES_KEY_MAIL);
        sharedPreferences.remove(MainActivity.SHARED_PREFERENCES_KEY_PASSWORD);
        sharedPreferences.commit();

        // present login activity
        Intent intent = new Intent(this, UserLoginActivity.class);
        this.startActivityForResult(intent, ACTIVITY_REQUEST_USER_LOGIN);
    }

    @Override
    public void onUserLogoutError() {
        Toast.makeText(this, "Error logging out user", Toast.LENGTH_SHORT).show();
    }

    @Override
    public void onUserLoggedIn() {
        checkUserLogin();
    }

    @Override
    public void onUserLoginError() {
        // present user login activity if auto login has failed
        Intent intent = new Intent(this, UserLoginActivity.class);
        this.startActivityForResult(intent, ACTIVITY_REQUEST_USER_LOGIN);
    }
}

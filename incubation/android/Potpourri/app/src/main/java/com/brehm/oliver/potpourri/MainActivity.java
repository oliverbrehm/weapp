package com.brehm.oliver.potpourri;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.support.design.widget.NavigationView;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.Toast;

import com.brehm.oliver.potpourri.Network.HTTPRequest;
import com.brehm.oliver.potpourri.Network.HTTPRequestInvitationList;
import com.brehm.oliver.potpourri.Network.HTTPRequestUserLogin;

public class MainActivity extends AppCompatActivity
        implements NavigationView.OnNavigationItemSelectedListener, HTTPRequest.OnRequestFinishedListener
{
    RecyclerView invitationListRecyclerView;
    InvitationListAdapter invitationListAdapter;

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

        this.invitationListRecyclerView = (RecyclerView) findViewById(R.id.invitationListRecyclerView);
        this.invitationListRecyclerView.setLayoutManager(new GridLayoutManager(this, 1));

        this.invitationListAdapter = new InvitationListAdapter();
        this.invitationListRecyclerView.setAdapter(invitationListAdapter);
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

        makeRequest();
    }

    @SuppressWarnings("StatementWithEmptyBody")
    @Override
    public boolean onNavigationItemSelected(MenuItem item) {
        // Handle navigation view item clicks here.
        int id = item.getItemId();

        if (id == R.id.nav_overview) {
            this.setTitle("Überblick");
        } else if (id == R.id.nav_messages) {
            this.setTitle("Nachrichten");
        } else if (id == R.id.nav_activities) {
            this.setTitle("Meine Aktivitäten");
        } else if (id == R.id.nav_profiles) {
            this.setTitle("Profile");
        }

        Toast.makeText(this, "Selection :)", Toast.LENGTH_SHORT);
        makeRequest();

        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        drawer.closeDrawer(GravityCompat.START);
        return true;
    }

    private void makeRequest() {
        HTTPRequestUserLogin userLoginRequest = new HTTPRequestUserLogin(this);
        userLoginRequest.send("olibrehm@arcor.de", "1234");
    }

    private boolean networkConnectionAvailable() {
        ConnectivityManager connectivityManager = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo networkInfo = connectivityManager.getActiveNetworkInfo();
        return networkInfo != null && networkInfo.isConnected();
    }

    @Override
    public void onRequestFinished(HTTPRequest request) {
        if(request.getClass() == HTTPRequestUserLogin.class) {
            HTTPRequestUserLogin userLoginRequest = (HTTPRequestUserLogin) request;
            Toast.makeText(this, "Request finished\n"
                    + "Response: " + userLoginRequest.responseValue + "\n"
                    + "User ID: " + userLoginRequest.userId, Toast.LENGTH_SHORT).show();

            HTTPRequestInvitationList invitationListRequest = new HTTPRequestInvitationList(this);
            invitationListRequest.send();
        } else if(request.getClass() == HTTPRequestInvitationList.class) {
            HTTPRequestInvitationList invitationListRequest = (HTTPRequestInvitationList) request;
            if(invitationListRequest.invitations != null) {
                this.invitationListAdapter.invitations = invitationListRequest.invitations;
                this.invitationListAdapter.notifyDataSetChanged();
            }
        }
    }
}

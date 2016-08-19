package com.brehm.oliver.potpourri.Activities;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.Toast;

import com.brehm.oliver.potpourri.MainActivity;
import com.brehm.oliver.potpourri.R;
import com.brehm.oliver.potpourri.User;

public class UserLoginActivity extends AppCompatActivity implements Button.OnClickListener
        , User.UserLoginListener {

    private EditText mailTextEdit;
    private EditText passwordTextEdit;
    private CheckBox keepLoggedInCheckbox;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_user_login);

        this.mailTextEdit = (EditText) findViewById(R.id.mailTextEdit);
        this.passwordTextEdit = (EditText) findViewById(R.id.passwordTextEdit);
        this.keepLoggedInCheckbox = (CheckBox) findViewById(R.id.keepLoggedInCheckbox);
    }

    @Override
    public void onClick(View v) {
        String mail = this.mailTextEdit.getText().toString();
        String password = this.passwordTextEdit.getText().toString();

        if(mail.isEmpty() || password.isEmpty()) {
            Toast.makeText(this, "Please enter your mail adress and password", Toast.LENGTH_SHORT).show();
            return;
        }

        User.login(mail, password, this);
    }

    @Override
    public void onUserLoggedIn() {
        Toast.makeText(this, "User " + User.currentUser().mail + " successfully logged in", Toast.LENGTH_SHORT).show();

        String password = this.passwordTextEdit.getText().toString();
        if(this.keepLoggedInCheckbox.isChecked() && !password.isEmpty()) {
            // store login data in shared preferences
            SharedPreferences.Editor sharedPreferences = getSharedPreferences(MainActivity.SHARED_PREFERENCES_DEFAULT, MODE_PRIVATE).edit();
            sharedPreferences.putString(MainActivity.SHARED_PREFERENCES_KEY_MAIL, User.currentUser().mail);
            sharedPreferences.putString(MainActivity.SHARED_PREFERENCES_KEY_PASSWORD, password);
            sharedPreferences.commit();
        }

        this.finish();
    }

    @Override
    public void onUserLoginError() {
        Toast.makeText(this, "Error logging in user", Toast.LENGTH_SHORT).show();
    }
}

package layout;

import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.brehm.oliver.potpourri.R;
import com.brehm.oliver.potpourri.User;

public class ProfilesFragment extends Fragment {

    Context context;

    TextView mailTextView;
    TextView userIdTextView;

    public ProfilesFragment() {
        // Required empty public constructor
    }

    public static ProfilesFragment newInstance() {
        ProfilesFragment fragment = new ProfilesFragment();
        Bundle args = new Bundle();

        // set arguments here
        //args.putString(ARG_PARAM1, param1);

        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            // get arguments here
            //mParam1 = getArguments().getString(ARG_PARAM1);
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View contentView = inflater.inflate(R.layout.fragment_profiles, container, false);

        this.mailTextView = (TextView) contentView.findViewById(R.id.mailTextView);
        this.userIdTextView = (TextView) contentView.findViewById(R.id.userIdTextView);

        User user = User.currentUser();
        if(user != null && User.loggedIn()) {
            mailTextView.setText(user.mail);
            userIdTextView.setText("" + user.userId);
        }

        return contentView;
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        this.context = context;
    }

    @Override
    public void onDetach() {
        super.onDetach();
    }
}

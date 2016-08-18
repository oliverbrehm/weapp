package layout;

import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import com.brehm.oliver.potpourri.InvitationListAdapter;
import com.brehm.oliver.potpourri.Network.HTTPRequest;
import com.brehm.oliver.potpourri.Network.HTTPRequestInvitationList;
import com.brehm.oliver.potpourri.Network.HTTPRequestUserLogin;
import com.brehm.oliver.potpourri.R;

public class InvitationListFragment extends Fragment implements HTTPRequest.OnRequestFinishedListener {

    RecyclerView invitationListRecyclerView;
    InvitationListAdapter invitationListAdapter;

    Context context;

    public InvitationListFragment() {
        // Required empty public constructor
    }

    public static InvitationListFragment newInstance() {
        InvitationListFragment fragment = new InvitationListFragment();
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
        View view = inflater.inflate(R.layout.fragment_invitation_list, container, false);

        this.invitationListRecyclerView = (RecyclerView) view.findViewById(R.id.invitationListRecyclerView);
        this.invitationListRecyclerView.setLayoutManager(new GridLayoutManager(getActivity(), 1));

        this.invitationListAdapter = new InvitationListAdapter();
        this.invitationListRecyclerView.setAdapter(invitationListAdapter);

        return view;
    }

    @Override
    public void onStart() {
        super.onStart();

        makeRequest();
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

    @Override
    public void onRequestFinished(HTTPRequest request) {
        if(request.getClass() == HTTPRequestUserLogin.class) {
            HTTPRequestUserLogin userLoginRequest = (HTTPRequestUserLogin) request;
            Toast.makeText(context, "Request finished\n"
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

    private void makeRequest() {
        HTTPRequestUserLogin userLoginRequest = new HTTPRequestUserLogin(this);
        userLoginRequest.send("olibrehm@arcor.de", "1234");
    }
}

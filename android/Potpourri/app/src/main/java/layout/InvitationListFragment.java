package layout;

import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.brehm.oliver.potpourri.InvitationListAdapter;
import com.brehm.oliver.potpourri.Network.HTTPRequest;
import com.brehm.oliver.potpourri.Network.HTTPRequestInvitationList;
import com.brehm.oliver.potpourri.R;
import com.brehm.oliver.potpourri.User;

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

        if(User.loggedIn()) {
            HTTPRequestInvitationList invitationListRequest = new HTTPRequestInvitationList(this);
            invitationListRequest.send();
        }
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
        if(request.getClass() == HTTPRequestInvitationList.class) {
            HTTPRequestInvitationList invitationListRequest = (HTTPRequestInvitationList) request;
            if(invitationListRequest.invitations != null) {
                this.invitationListAdapter.invitations = invitationListRequest.invitations;
                this.invitationListAdapter.notifyDataSetChanged();
            }
        }
    }
}

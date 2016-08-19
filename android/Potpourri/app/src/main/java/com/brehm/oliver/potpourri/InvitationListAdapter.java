package com.brehm.oliver.potpourri;

import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.brehm.oliver.potpourri.Network.HTTPRequestInvitationList;

import java.util.ArrayList;

/**
 * Created by oliver on 18.08.16.
 */
public class InvitationListAdapter extends RecyclerView.Adapter<InvitationListAdapter.ViewHolder> {
    public ArrayList<HTTPRequestInvitationList.InvitationHeader> invitations;

    public InvitationListAdapter() {
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext()).inflate(R.layout.row_invitation_header, parent, false);
        ViewHolder viewHolder = new ViewHolder(itemView);
        return viewHolder;
    }

    @Override
    public int getItemCount() {
        if(invitations != null) {
            return invitations.size();
        } else {
            return 1;
        }
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        if(this.invitations == null) {
            holder.invitationNameTextView.setText("Loading invitations...");
            holder.invitationUserTextView.setText("");
            return;
        }

        HTTPRequestInvitationList.InvitationHeader invitation = this.invitations.get(position);

        holder.bindInvitationToView(invitation);
    }

    class ViewHolder extends RecyclerView.ViewHolder {
        protected ImageView invitationImageView;
        protected TextView invitationNameTextView;
        protected TextView invitationUserTextView;

        public ViewHolder(View itemView)
        {
            super(itemView);

            invitationImageView = (ImageView) itemView.findViewById(R.id.invitationImageView);
            invitationNameTextView = (TextView) itemView.findViewById(R.id.invitationNameTextView);
            invitationUserTextView = (TextView) itemView.findViewById(R.id.invitationUserTextView);
        }

        public void bindInvitationToView(HTTPRequestInvitationList.InvitationHeader invitation) {
            invitationNameTextView.setText(invitation.name);
            invitationUserTextView.setText(invitation.id);
        }
    }
}

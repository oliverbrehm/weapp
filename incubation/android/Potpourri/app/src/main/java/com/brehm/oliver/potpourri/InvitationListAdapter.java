package com.brehm.oliver.potpourri;

import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.view.ViewGroup;
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
        TextView itemView = new TextView(parent.getContext());
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
        TextView textView = (TextView) holder.itemView;

        if(this.invitations == null) {
            textView.setText("Loading invitations...");
            return;
        }

        HTTPRequestInvitationList.InvitationHeader invitation = this.invitations.get(position);

        textView.setText(invitation.name + "(id = " + invitation.id + ")");
    }

    class ViewHolder extends RecyclerView.ViewHolder {

        public ViewHolder(View itemView) {
            super(itemView);
        }
    }
}

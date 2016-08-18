package com.brehm.oliver.potpourri.Network;

import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import java.util.ArrayList;

/**
 * Created by oliver on 18.08.16.
 */

public class HTTPRequestInvitationList extends HTTPRequest {
    public ArrayList<InvitationHeader> invitations;

    public HTTPRequestInvitationList(OnRequestFinishedListener listener) {
        super(listener);
    }

    public void send() {
        super.sendPostRequest("action=invitation_query");
    }

    @Override
    public void onPostResponseAvailable(String response) {
        super.onPostResponseAvailable(response);

        if(this.xmlDocument != null) {
            NodeList invitationNodes = xmlDocument.getElementsByTagName("invitation");

            this.invitations = new ArrayList<InvitationHeader>();

            for(int i = 0; i < invitationNodes.getLength(); i++) {
                Element invitationNode = (Element) invitationNodes.item(i);
                Element invitationIdNode = (Element) invitationNode.getElementsByTagName("id").item(0);
                Element invitationNameNode = (Element) invitationNode.getElementsByTagName("name").item(0);

                this.invitations.add(new InvitationHeader(invitationNameNode.getTextContent(), invitationIdNode.getTextContent()));
            }
        }

        if(this.requestFinishedListener != null) {
            this.requestFinishedListener.onRequestFinished(this);
        }
    }

    public class InvitationHeader
    {
        public String name = "";
        public String id = "";

        public InvitationHeader(String name, String id)
        {
            this.name = name;
            this.id = id;
        }
    }
}

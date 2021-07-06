package com.tmax.superauth.eventlistener;

import java.util.*;
import javax.ws.rs.core.Context;
import com.tmax.superauth.authenticator.AuthenticatorConstants;
import lombok.extern.slf4j.Slf4j;
import org.keycloak.events.Event;
import org.keycloak.events.EventListenerProvider;
import org.keycloak.events.admin.AdminEvent;
import org.keycloak.models.KeycloakSession;
import org.keycloak.models.RealmModel;
import org.keycloak.models.UserModel;
import org.keycloak.timer.TimerProvider;
import org.keycloak.timer.TimerSpi;

/**
 * @author taegeon_woo@tmax.co.kr
 */
@Slf4j
public class SuperauthEventListenerProvider extends TimerSpi implements EventListenerProvider {
    @Context
    private final KeycloakSession session;
    public SuperauthEventListenerProvider(KeycloakSession session) {
        this.session = session;
    }

    @Override
    public void onEvent(Event event) {
        String userName = "";
        log.info("Event Occurred:" + toString(event));

        if (event.getRealmId().equalsIgnoreCase("tmax")) {

            switch (event.getType().toString()) {
                case "LOGIN":
                    // For Session-Restrict Policy
                    if (!event.getDetails().get("username").equalsIgnoreCase("admin@tmax.co.kr")) { //FIXME : Delete Later !!!!
                        log.info("User [ " + event.getDetails().get("username") + " ], Client [ " + event.getClientId() + " ] Session-Restrict Start");
                        UserModel user = session.users().getUserById(event.getUserId(), session.realms().getRealmByName(event.getRealmId()));
                        RealmModel realm = session.realms().getRealmByName(event.getRealmId());
                        session.sessions().getUserSessions(realm, session.clients().getClientByClientId(realm, event.getClientId())).forEach(userSession -> {
                            if( userSession.getUser().getUsername().equalsIgnoreCase(event.getDetails().get("username"))
                                    && !userSession.getId().equals(event.getSessionId()) ) {
                                session.sessions().removeUserSession(realm, userSession);
                                log.info("Remove user session [ " + userSession.getId() + " ]");
                            }
                        } );
                        log.info("User [ " + event.getDetails().get("username") + " ], Client [ " + event.getClientId() + " ] Session-Restrict Success");
                    }
                    break;
                case "SEND_VERIFY_EMAIL_ERROR":
                    String email = event.getDetails().get("email");
                    long interval = 1000 * 60 * 10;
                    TimerProvider timer = session.getProvider(TimerProvider.class);
                    timer.scheduleTask((KeycloakSession keycloakSession) -> {
                        log.info("Check If not User Email [ " + email + " ] verified, Delete user");
                        try {
                            timer.cancelTask(email);
                            UserModel user = keycloakSession.users().getUserById(event.getUserId(), keycloakSession.realms().getRealmByName(event.getRealmId()));
                            if (user != null) {
                                if (!user.isEmailVerified()) {
                                    keycloakSession.users().removeUser(keycloakSession.realms().getRealmByName(event.getRealmId()), user);
                                    log.info("User [" + event.getDetails().get("username") + " ] Deleted");
                                } else {
                                    log.info("Already Verified, Nothing to do");
                                }
                            } else {
                                log.info("User [" + event.getDetails().get("username") + " ] Already Deleted, nothing to do");
                            }
                        } catch (Exception e) {
                            log.error("Error Occurs!!", e);
                        }
                    }, interval, email);
                    break;
                case "UPDATE_PASSWORD" :
                        UserModel user = session.users().getUserById(event.getUserId(), session.realms().getRealmByName(event.getRealmId()));
                        user.setAttribute(AuthenticatorConstants.USER_ATTR_LAST_PW_UPDATE_DATE, Arrays.asList(Long.toString(event.getTime())));
            }
        }
    }

    @Override
    public void onEvent(AdminEvent adminEvent, boolean includeRepresentation) {
        log.info("Admin Event Occurred:" + toString(adminEvent));

        switch (adminEvent.getOperationType().toString()) {
            case "ACTION":
                if (adminEvent.getResourcePath().startsWith("users") && adminEvent.getResourcePath().endsWith("reset-password")){
                    UserModel user = session.users().getUserById(adminEvent.getResourcePath().split("/")[1], session.realms().getRealmByName(adminEvent.getRealmId()));
                    user.setAttribute(AuthenticatorConstants.USER_ATTR_LAST_PW_UPDATE_DATE, Arrays.asList(Long.toString(adminEvent.getTime())));
                }
                break;
        }

    }

    @Override
    public void close() {

    }

    private String toString(Event event) {
        StringBuilder sb = new StringBuilder();
        sb.append("type=");
        sb.append(event.getType());
        sb.append(", realmId=");
        sb.append(event.getRealmId());
        sb.append(", clientId=");
        sb.append(event.getClientId());
        sb.append(", userId=");
        sb.append(event.getUserId());
        sb.append(", ipAddress=");
        sb.append(event.getIpAddress());
        sb.append(", sessionId=");
        sb.append(event.getSessionId());
        sb.append(", time=");
        sb.append(event.getTime());
        if (event.getError() != null) {
            sb.append(", error=");
            sb.append(event.getError());
        }

        if (event.getDetails() != null) {
            for (Map.Entry<String, String> e : event.getDetails().entrySet()) {
                sb.append(", ");
                sb.append(e.getKey());
                if (e.getValue() == null || e.getValue().indexOf(' ') == -1) {
                    sb.append("=");
                    sb.append(e.getValue());
                } else {
                    sb.append("='");
                    sb.append(e.getValue());
                    sb.append("'");
                }
            }
        }
        return sb.toString();
    }

    private String toString(AdminEvent adminEvent) {
        StringBuilder sb = new StringBuilder();
        sb.append("operationType=");
        sb.append(adminEvent.getOperationType());
        sb.append(", realmId=");
        sb.append(adminEvent.getAuthDetails().getRealmId());
        sb.append(", clientId=");
        sb.append(adminEvent.getAuthDetails().getClientId());
        sb.append(", userId=");
        sb.append(adminEvent.getAuthDetails().getUserId());
        sb.append(", ipAddress=");
        sb.append(adminEvent.getAuthDetails().getIpAddress());
        sb.append(", resourcePath=");
        sb.append(adminEvent.getResourcePath());

        if (adminEvent.getError() != null) {
            sb.append(", error=");
            sb.append(adminEvent.getError());
        }
        return sb.toString();
    }
}
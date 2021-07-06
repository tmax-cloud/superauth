package com.tmax.superauth.jpa;

import org.keycloak.Config.Scope;
import org.keycloak.connections.jpa.entityprovider.JpaEntityProvider;
import org.keycloak.connections.jpa.entityprovider.JpaEntityProviderFactory;
import org.keycloak.models.KeycloakSession;
import org.keycloak.models.KeycloakSessionFactory;

/**
 * @author taegeon_woo@tmax.co.kr
 */

public class SuperauthJpaEntityProviderFactory implements JpaEntityProviderFactory {
	protected static final String ID = "superauth-entity-provider";
	
    @Override
    public JpaEntityProvider create(KeycloakSession session) {
        return new SuperauthJpaEntityProvider();
    }

    @Override
    public String getId() {
        return ID;
    }

    @Override
    public void init(Scope config) {
    }

    @Override
    public void postInit(KeycloakSessionFactory factory) {
    }

    @Override
    public void close() {
    }
}

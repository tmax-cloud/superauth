package com.tmax.superauth.jpa;

import org.keycloak.connections.jpa.entityprovider.JpaEntityProvider;

import java.util.Arrays;
import java.util.List;

/**
 * @author taegeon_woo@tmax.co.kr
 */

public class SuperauthJpaEntityProvider implements JpaEntityProvider {
	@Override
    public List<Class<?>> getEntities() {
        return Arrays.asList(Agreement.class, EmailVerification.class);
    }

    @Override
    public String getChangelogLocation() {
    	return "META-INF/database-changelog.xml";
    }
    
    @Override
    public void close() {
    }

    @Override
    public String getFactoryId() {
        return SuperauthJpaEntityProviderFactory.ID;
    }
}

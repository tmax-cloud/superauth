from quay.io/keycloak/keycloak:11.0.2
 
LABEL maintainer="taegeon_woo@tmax.co.kr"

# 0. add tibero.jdbc.jar & module.xml
RUN mkdir -p /opt/jboss/keycloak/modules/system/layers/base/com/tmax/tibero/jdbc/main
ADD build/tibero/tibero6-jdbc.jar /opt/jboss/keycloak/modules/system/layers/base/com/tmax/tibero/jdbc/main/tibero6-jdbc.jar
ADD build/tibero/module.xml /opt/jboss/keycloak/modules/system/layers/base/com/tmax/tibero/jdbc/main/module.xml

RUN mkdir -p /opt/jboss/tools/databases/tibero
ADD build/tibero/module.xml /opt/jboss/tools/databases/tibero/module.xml

RUN mkdir -p /opt/jboss/tools/cli/databases/tibero
ADD build/tibero/change-database.cli /opt/jboss/tools/cli/databases/tibero/change-database.cli
ADD build/tibero/standalone-configuration.cli /opt/jboss/tools/cli/databases/tibero/standalone-configuration.cli
ADD build/tibero/standalone-ha-configuration.cli /opt/jboss/tools/cli/databases/tibero/standalone-ha-configuration.cli

# 1. add postgresql-jdbc.jar & module.xml
RUN mkdir -p /opt/jboss/keycloak/modules/system/layers/keycloak/org/postgresql/main
ADD build/postgresql/postgresql-42.2.14.jar /opt/jboss/keycloak/modules/system/layers/keycloak/org/postgresql/main/postgresql-42.2.14.jar
ADD build/postgresql/module.xml /opt/jboss/keycloak/modules/system/layers/keycloak/org/postgresql/main/module.xml

# 2. Update stanalone.xml & domain.xml
ADD build/config/docker-entrypoint.sh /opt/jboss/tools/docker-entrypoint.sh

# 3. add tmax theme & hypercloud/login & hyperspace/login & superauth & cnu
COPY themes/tmax /opt/jboss/keycloak/themes/tmax
COPY themes/hypercloud/login /opt/jboss/keycloak/themes/hypercloud/login
COPY themes/hyperspace/login /opt/jboss/keycloak/themes/hyperspace/login
COPY themes/superauth /opt/jboss/keycloak/themes/superauth
COPY themes/cnu /opt/jboss/keycloak/themes/CNU

# 4. keycloak service jar & sql jar & server-spi-private jar change for tibero, this contains sql error fixme!!
RUN rm /opt/jboss/keycloak/modules/system/layers/keycloak/org/keycloak/keycloak-services/main/keycloak-services-11.0.2.jar
ADD build/jar/keycloak-services-11.0.2.jar /opt/jboss/keycloak/modules/system/layers/keycloak/org/keycloak/keycloak-services/main/keycloak-services-11.0.2.jar
RUN rm /opt/jboss/keycloak/modules/system/layers/keycloak/org/keycloak/keycloak-model-jpa/main/keycloak-model-jpa-11.0.2.jar
ADD build/jar/keycloak-model-jpa-11.0.2.jar /opt/jboss/keycloak/modules/system/layers/keycloak/org/keycloak/keycloak-model-jpa/main/keycloak-model-jpa-11.0.2.jar
RUN rm /opt/jboss/keycloak/modules/system/layers/keycloak/org/keycloak/keycloak-server-spi-private/main/keycloak-server-spi-private-11.0.2.jar
ADD build/jar/keycloak-server-spi-private-11.0.2.jar /opt/jboss/keycloak/modules/system/layers/keycloak/org/keycloak/keycloak-server-spi-private/main/keycloak-server-spi-private-11.0.2.jar

# 5. superauth-spi.jar (SPI)
ADD target/keycloak-spi-jar-with-dependencies.jar /opt/jboss/keycloak/standalone/deployments/superauth-spi.jar

# 6. Naver & Kakao html
ADD build/config/realm-identity-provider-naver.html /opt/jboss/keycloak/themes/base/admin/resources/partials/realm-identity-provider-naver.html
ADD build/config/realm-identity-provider-naver-ext.html /opt/jboss/keycloak/themes/base/admin/resources/partials/realm-identity-provider-naver-ext.html
ADD build/config/realm-identity-provider-kakao.html /opt/jboss/keycloak/themes/base/admin/resources/partials/realm-identity-provider-kakao.html
ADD build/config/realm-identity-provider-kakao-ext.html /opt/jboss/keycloak/themes/base/admin/resources/partials/realm-identity-provider-kakao-ext.html

# 7. For pdf term file
USER jboss
COPY build/config/TmaxOneAccount_Privacy_Policy_210401.pdf /opt/jboss/keycloak/welcome-content/term/TmaxOneAccount_Privacy_Policy.pdf
COPY build/config/TmaxOneAccount_Service_Policy_210401.pdf /opt/jboss/keycloak/welcome-content/term/TmaxOneAccount_Service_Policy.pdf
COPY build/config/TmaxOneAccount_Privacy_Policy_210222.pdf /opt/jboss/keycloak/welcome-content/term/TmaxOneAccount_Privacy_Policy_210222.pdf
COPY build/config/TmaxOneAccount_Service_Policy_210222.pdf /opt/jboss/keycloak/welcome-content/term/TmaxOneAccount_Service_Policy_210222.pdf
COPY build/config/TmaxOneAccount_Privacy_Policy_210105.pdf /opt/jboss/keycloak/welcome-content/term/TmaxOneAccount_Privacy_Policy_210105.pdf
COPY build/config/TmaxOneAccount_Service_Policy_210105.pdf /opt/jboss/keycloak/welcome-content/term/TmaxOneAccount_Service_Policy_210105.pdf
COPY build/config/TmaxOneAccount_Privacy_Policy_210401.pdf /opt/jboss/keycloak/welcome-content/term/TmaxOneAccount_Privacy_Policy_210401.pdf
COPY build/config/TmaxOneAccount_Service_Policy_210401.pdf /opt/jboss/keycloak/welcome-content/term/TmaxOneAccount_Service_Policy_210401.pdf

# 8. For Log to File
USER root
RUN mkdir -p /opt/jboss/keycloak/standalone/log/superauth
RUN mkdir -p /opt/jboss/startup-scripts
ADD build/config/jboss.cli /opt/jboss/startup-scripts/jboss.cli

# 9. Vesion Env for version API
ARG SUPERAUTH_VERSION
ENV SUPERAUTH_VERSION $SUPERAUTH_VERSION







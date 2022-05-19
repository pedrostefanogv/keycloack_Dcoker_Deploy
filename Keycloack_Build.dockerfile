FROM quay.io/keycloak/keycloak:latest as builder

ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
ENV KC_FEATURES=RECOVERY_CODES,DYNAMIC_SCOPES,ADMIN2,DOCKER,TOKEN_EXCHANGE
ENV KC_DB=postgres

#ENV KC_DB_URL=jdbc:postgresql://192.168.18.169:5432/
#ENV KC_DB_USER=keycloak
#ENV KC_DB_PASSWORD=password
#ENV KC_DB_DATABASE=keycloak

ENV KC_HTTP_ENABLED=true
#ENV KC_HOSTNAME=localhost
#ENV KC_HOSTNAME_STRICT=false


# Install custom providers
RUN curl -sL https://github.com/aerogear/keycloak-metrics-spi/releases/download/2.5.3/keycloak-metrics-spi-2.5.3.jar -o /opt/keycloak/providers/keycloak-metrics-spi-2.5.3.jar
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/
WORKDIR /opt/keycloak
# for demonstration purposes only, please make sure to use proper certificates in production instead
RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=server" -alias server -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -keystore conf/server.keystore
# change these values to point to a running postgres instance
ENV KC_DB_URL=jdbc:postgresql://postgres-db:5432/
ENV KC_DB_USER=keycloak
ENV KC_DB_DATABASE=keycloak
ENV KC_DB_PASSWORD=password

#ENV KC_ADMIN=admin
#ENV KC_ADMIN_PASSWORD=admin
ENV KC_HTTP_ENABLED=true
ENV KC_HOSTNAME=Keycloak-app
ENV KC_HOSTNAME_STRICT=false
ENV KEYCLOAK_ADMIN=admin
ENV KEYCLOAK_ADMIN_PASSWORD=admin
ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start"]




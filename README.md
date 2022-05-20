# keycloack_Dcoker_Deploy

Repositório com arquivos necessários pata execução do Keycloak no docker

Para subir uma implantação clone o repositório atual e na pasta raiz execute o comando abaixo

docker-compose -f keycloak-postgres.yml up -d

depois acesse https://localhost:8443/ ou

docker run --name optimized_keycloak -p 8443:8443 tagged keycloaktest:last

docker run --name optimized_keycloak -p 8443:8443 -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=admin keycloaktest

docker build -t keycloaktest -f Keycloack_Build.dockerfile .

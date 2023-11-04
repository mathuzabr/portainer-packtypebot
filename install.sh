echo -e "\e[32m\e[0m"
echo -e "\e[32m\e[0m"
echo -e "\e[32m                                                                       \e[0m"
echo -e "\e[32m  _____        _____ _  __  _________     _______  ______ ____   ____ _______ \e[0m"
echo -e "\e[32m |  __ \ /\   / ____| |/ / |__   __\ \   / /  __ \|  ____|  _ \ / __ \__   __|\e[0m"
echo -e "\e[32m | |__) /  \ | |    | ' /     | |   \ \_/ /| |__) | |__  | |_) | |  | | | |   \e[0m"
echo -e "\e[32m |  ___/ /\ \| |    |  <      | |    \   / |  ___/|  __| |  _ <| |  | | | |   \e[0m"
echo -e "\e[32m | |  / ____ \ |____| . \     | |     | |  | |    | |____| |_) | |__| | | |   \e[0m"
echo -e "\e[32m |_| /_/    \_\_____|_|\_\    |_|     |_|  |_|    |______|____/ \____/  |_|   \e[0m"
echo -e "\e[32m                                                                              \e[0m"                                                                                                                                            
echo -e "\e[32mAuto Instalador Docker/Portainer Pack Typebot                                 \e[0m"
echo -e "\e[32mCreditos do arquivo docker-compose.yml                                        \e[0m"
echo -e "\e[32mAndre Almeida https://www.youtube.com/@fabricandosuaideiatutoriais            \e[0m"
echo -e "\e[32m\e[0m"
echo -e "\e[32m\e[0m"


echo ""
echo -e "\e[32m==============================================================================\e[0m"
echo -e "\e[32m=                                                                            =\e[0m"
echo -e "\e[32m=                 \e[33mPreencha as informações solicitadas abaixo\e[32m                 =\e[0m"
echo -e "\e[32m=                                                                            =\e[0m"
echo -e "\e[32m==============================================================================\e[0m"
echo ""
echo ""
echo ""

# Prompt for email, traefik, senha, portainer, and edge variables
echo -e "\e[32mPasso \e[33m1/5\e[0m"
read -p "Endereço de e-mail: " email
echo ""
echo -e "\e[32mPasso \e[33m2/5\e[0m"
read -p "Dominio do Traefik (ex: traefik.seudominio.com): " traefik
echo ""
echo -e "\e[32mPasso \e[33m3/5\e[0m"
read -p "Senha do Traefik: " senha
echo ""
echo -e "\e[32mPasso \e[33m4/5\e[0m"
read -p "Dominio do Portainer (ex: portainer.seudominio.com): " portainer
echo ""
echo -e "\e[32mPasso \e[33m5/5\e[0m"
read -p "Dominio do Edge (ex: edge.seudominio.com): " edge
echo ""

#########################################################
#
# VERIFICAÇÃO DE DADOS
#
#########################################################

clear

echo ""
echo "Seu E-mail: $email"
echo "Dominio do Traefik: $traefik"
echo "Senha do Traefik: $senha"
echo "Dominio do Portainer: $portainer"
echo "Dominio do Edge: $edge"
echo ""
echo ""
read -p "As informações estão certas? (y/n): " confirma1
if [ "$confirma1" == "y" ]; then

clear

echo -e "\e[32m\e[0m"
echo -e "\e[32m\e[0m"
echo -e "\e[32m                                                                       \e[0m"
echo -e "\e[32m  _____        _____ _  __  _________     _______  ______ ____   ____ _______ \e[0m"
echo -e "\e[32m |  __ \ /\   / ____| |/ / |__   __\ \   / /  __ \|  ____|  _ \ / __ \__   __|\e[0m"
echo -e "\e[32m | |__) /  \ | |    | ' /     | |   \ \_/ /| |__) | |__  | |_) | |  | | | |   \e[0m"
echo -e "\e[32m |  ___/ /\ \| |    |  <      | |    \   / |  ___/|  __| |  _ <| |  | | | |   \e[0m"
echo -e "\e[32m | |  / ____ \ |____| . \     | |     | |  | |    | |____| |_) | |__| | | |   \e[0m"
echo -e "\e[32m |_| /_/    \_\_____|_|\_\    |_|     |_|  |_|    |______|____/ \____/  |_|   \e[0m"
echo -e "\e[32m                                                                              \e[0m"                                                                                                                                            
echo -e "\e[32m                                                                       \e[0m"
echo -e "\e[32m\e[0m"
echo -e "\e[32m\e[0m"

loading1 2 $width

#########################################################
#
# INSTALANDO DEPENDENCIAS
#
#########################################################

cd
cd

clear

sudo apt update -y
sudo apt upgrade -y
sudo apt install curl

curl -fsSL https://get.docker.com -o get-docker.sh

sudo sh get-docker.sh

sleep 3

mkdir Portainer
cd Portainer

sleep 3

echo ""
echo ""
echo "Atualizado/Instalado com Sucesso"

sleep 3

clear


#######################################################
#
# CRIANDO DOCKER-COMPOSE.YML
#
#######################################################

sleep 3


    # Create or modify docker-compose.yml file with subdomains
    cat > docker-compose.yml <<EOL
version: "3.3"
services:
  traefik:
    container_name: traefik
    image: "traefik:latest"
    restart: always
    command:
      - --entrypoints.web.address=:80
      - --entrypoints.websecure.address=:443
      - --api.insecure=true
      - --api.dashboard=true
      - --providers.docker
      - --log.level=ERROR
      - --certificatesresolvers.leresolver.acme.httpchallenge=true
      - --certificatesresolvers.leresolver.acme.email=$email
      - --certificatesresolvers.leresolver.acme.storage=./acme.json
      - --certificatesresolvers.leresolver.acme.httpchallenge.entrypoint=web
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock:ro"
      - "./acme.json:/acme.json"
    labels:
      - "traefik.http.routers.http-catchall.rule=hostregexp(\`{host:.+}\`)"
      - "traefik.http.routers.http-catchall.entrypoints=web"
      - "traefik.http.routers.http-catchall.middlewares=redirect-to-https"
      - "traefik.http.middlewares.redirect-to-https.redirectscheme.scheme=https"
      - "traefik.http.routers.traefik-dashboard.rule=Host(\`$traefik\`)"
      - "traefik.http.routers.traefik-dashboard.entrypoints=websecure"
      - "traefik.http.routers.traefik-dashboard.service=api@internal"
      - "traefik.http.routers.traefik-dashboard.tls.certresolver=leresolver"
      - "traefik.http.middlewares.traefik-auth.basicauth.users=$senha"
      - "traefik.http.routers.traefik-dashboard.middlewares=traefik-auth"

  portainer:
    image: portainer/portainer-ce:latest
    command: -H unix:///var/run/docker.sock
    restart: always
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.frontend.rule=Host(\`$portainer\`)"
      - "traefik.http.routers.frontend.entrypoints=websecure"
      - "traefik.http.services.frontend.loadbalancer.server.port=9000"
      - "traefik.http.routers.frontend.service=frontend"
      - "traefik.http.routers.frontend.tls.certresolver=leresolver"
      - "traefik.http.routers.edge.rule=Host(\`$edge\`)"
      - "traefik.http.routers.edge.entrypoints=websecure"
      - "traefik.http.services.edge.loadbalancer.server.port=8000"
      - "traefik.http.routers.edge.service=edge"
      - "traefik.http.routers.edge.tls.certresolver=leresolver"
volumes:
  portainer_data:
EOL


clear


###############################################
#
# Certificates letsencrypt
#
###############################################

echo ""
echo ""
echo "Instalando certificado letsencrypt"

touch acme.json

sudo chmod 600 acme.json

###############################################
#
# INICIANDO CONTAINER
#
###############################################

sudo docker compose up -d


echo -e "\e[32m\e[0m"
echo -e "\e[32m\e[0m"
echo -e "\e[32m\e[0m"
echo -e "\e[32m\e[0m"
echo -e "\e[32m _                             _              _        \e[0m"
echo -e "\e[32m| |                _          | |            | |       \e[0m"
echo -e "\e[32m| | ____    ___  _| |_  _____ | |  _____   __| |  ___  \e[0m"
echo -e "\e[32m| ||  _ \  /___)(_   _)(____ || | (____ | / _  | / _ \ \e[0m"
echo -e "\e[32m| || | | ||___ |  | |_ / ___ || | / ___ |( (_| || |_| |\e[0m"
echo -e "\e[32m|_||_| |_|(___/    \__)\_____| \_)\_____| \____| \___/ \e[0m"
echo -e "\e[32m                                                       \e[0m"              
echo -e "\e[32m\e[0m"
echo -e "\e[32m\e[0m"
echo -e "\e[32m\e[0m"
echo -e "\e[32m\e[0m"
echo -e "\e[32mAcesse o Portainer através do link: https://$portainer\e[0m"
echo -e "\e[32m\e[0m"
echo -e "\e[32mAcesse o Traefik através do link: https://$traefik\e[0m"
echo -e "\e[32m\e[0m"
echo -e "\e[32mSugestões ou duvidas: https://wa.me/+5562991252643\e[0m"
echo -e "\e[32m\e[0m"
echo -e "\e[32m\e[0m"

#########################################################
#
# USUARIO PREENCHEU DADOS ERRADOS
#
#########################################################

elif [ "$confirma1" == "n" ]; then
    echo "Encerrando a instalação, por favor, inicie a instalação novamente."
    exit 0
else
    echo "Resposta inválida. Digite 'y' para confirmar ou 'n' para encerrar a instalação."
    exit 1
fi

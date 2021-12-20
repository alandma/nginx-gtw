# Nginx Gateway

### Nginx configurado para servir de gateway para portais. Com certificação ssl auto via container certbot.

Todas as alterações e ajustes para os portais atuais ou novos devem ser feitos atraves dos seguintes arquivos:

### **gtw-*.conf**

Esse arquivo se trata da configuração do Nginx, onde vai conter o proxy para os containers com os portais adicionando o **nome dos serviços** e porta de conexão.

**_cert_** : Ele que irá efetuar a certificação, porem ainda não redireciona para o https. Esta como argumento no compose (**args**) como default.

**_prd_** : Fará o redirecionamento para os certificados gerados na etapa anterior. deverá ser alterado para implantação em produção apos execução do **cert**.

### **docker-compose.yml**

No compose por padrão o argumento **args** em "build" esta como "cert" e deverá ser executado dessa forma da primeira vez e logo após o sucesso, ser alterado para **prd**.

Na linha 34 (**command**) no serviço _certbot_ deve ser adicionado os dominios que serão certificados.

## **Como Executar**

>`docker-compose up --abort-on-container-exit`

Dá primeira vez que executar será criada a rede "_nginx-gtw_gtw-net_", ela deverá ser adicionada como uma "_external_" rede nos containers de portais que serão certificados.

Ficando assim:
```YAML
networks:
  ex-net:
    external: true
    name: nginx-gtw_gtw-net
```
No **command** do serviço _gtw-ngx_ ele "aguarda" os conteiners dos portais subirem.

Se tudo ocorreu bem, seu serviço _gtw-ngx_ devem estar `Up` e o contêiner `certbot` terá finalizado com uma mensagem de status 0.

Agora ainda no compose altere o argumento (args) para **prd** e rode ele novamente, indicando somente o gtw-ngx:
> `docker-compose up -d --build --no-deps --force-recreate gtw-ngx`

## **Renovação de certificado auto**

O script "_ssl-renew.sh_" será responsavél por essa renovação e deve ser agendado via cron

>`crontab -e`

```bash
0 */12 * * * cd /home/nginx-gtw && ./ssl_renew.sh >> /var/log/cron_certbot.log 2>&1
```
O script irá tentar executar da renovação do certificado todo meio dia (12:00) e meia noite (00:00), se estiver no periodo de renovação, irá atualizar automaticamente.

#### Referencia
- https://www.digitalocean.com/community/tutorials/how-to-secure-a-containerized-node-js-application-with-nginx-let-s-encrypt-and-docker-compose-pt

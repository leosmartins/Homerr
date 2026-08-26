# Homerr
IaC para um servidor caseiro, com diversas aplicações, variando de mídia até IoT.</br>
Com serviços pré-configurados para proxy reverso e resoluçao de DNS local, mantendo uma estrutura limpa e organizada, facilitando a manutenção, gerenciamento e expansão do servidor.

## Estrutura de pasta
Para que o projeto se mantenha organizado, é necessário manter uma ordem lógica, devido o número de containers existentes.

```text
Homerr/
├── 📄 README.md
├── 📄 docker-compose.yml
├── 📄 .env
├── 📁 config/
│   ├── 📁 caddy/
│   ├── 📁 homarr/
│   ├── 📁 plex/
│   ├── 📁 sonarr/
│   ├── 📁 radarr/
│   ├── 📁 bazarr/
│   ├── 📁 prowlarr/
│   ├── 📁 seerr/
│   ├── 📁 qbittorrent/
│   └── 📁 pihole/
├── 📁 media/
│   ├── 📁 movies
│   └── 📁 series
├── 📁 downloads/
└── 📁 scripts/
    └── 📄 setup_hosts.bat
```


## Serviços Disponíveis
| Nome | URL de Acesso | Descrição | Volumes |
|------|---------------|-----------|---------|
| [**Caddy**](https://caddyserver.com/docs/) | http://caddy.homerr | Proxy reverso e roteador | `./config/caddy/Caddyfile:/etc/caddy/Caddyfile:ro`, `./config/caddy/data:/data`, `./config/caddy/config:/config` |
| [**Homarr**](https://homarr.dev/docs/getting-started/) | http://homarr.homerr | Dashboard e interface inicial | `/var/run/docker.sock:/var/run/docker.sock`, `./config/homarr:/appdata` |
| [**Plex**](https://support.plex.tv/articles/) | http://plex.homerr | Media server | `./config/plex:/config`, `./media:/media`, `./downloads:/downloads` |
| [**Sonarr**](https://wiki.servarr.com/sonarr) | http://sonarr.homerr | Gerenciador de series de TV | `./config/sonarr:/config`, `./downloads:/downloads`, `./media:/media` |
| [**Radarr**](https://wiki.servarr.com/radarr) | http://radarr.homerr | Gerenciador de filmes | `./config/radarr:/config`, `./downloads:/downloads`, `./media:/media` |
| [**Bazarr**](https://wiki.bazarr.media/) | http://bazarr.homerr | Gerenciador de legendas | `./config/bazarr:/config`, `./media:/media` |
| [**Prowlarr**](https://wiki.servarr.com/prowlarr) | http://prowlarr.homerr | Gerenciador de indexadores | `./config/prowlarr:/config` |
| [**Seerr**](https://docs.seerr.dev/) | http://seerr.homerr | Gerenciador de requisicoes | `./config/seerr:/app/config` |
| [**qBittorrent**](https://www.qbittorrent.org/) | http://qbittorrent.homerr | Cliente torrent | `./config/qbittorrent:/config`, `./downloads:/downloads` |
| [**Pi-hole**](https://docs.pi-hole.net/) | http://pihole.homerr | Bloqueador de DNS | `./config/pihole/etc-pihole:/etc/pihole`, `./config/pihole/etc-dnsmasq.d:/etc/dnsmasq.d` |
| [**FlareSolverr**](https://github.com/FlareSolverr/FlareSolverr) | http://flaresolverr.homerr | Proxy para resolver desafios anti-bot | Nenhum |
>Nota: Como a ideia é o Pi-Hole traduzir as chamadas de localhost->serviço, é necessário que o DNS Local seja a sua fonte primaria de resolução de endereços. Isso pode ser feito alterando a configuração do roteador ou do adaptador de rede do computador, para que o DNS primário seja o IP do servidor. Além disso, pode ser que o navegador esteja utilizando cache de DNS, então é necessário limpar o cache do navegador ou reiniciar o mesmo para que as alterações tenham efeito.


## Arquivo `.env`
Para facilitar a configuração dos serviços, todas as variáveis a serem utilizadas no compose podem ser definidas no arquivo `.env`. Caso não exista, o projeto utiliza valores padrão.</br>
O maior objetivo é permitir que o usuário altere apenas o arquivo `.env` para personalizar o projeto, sem precisar alterar o `docker-compose.yml`. Além disso, o arquivo `.env` permite que o usuário altere facilmente as portas de cada serviço, caso haja algum conflito com outro serviço já em execução no host, mantendo as portas internas dos containers intactas, somente alterando as portas externas.

**env ->** `VARIAVEL=valor`
</br>
**docker-compose.yml ->** `${VARIAVEL:-valorPadrao}`


## Adicionar Entradas ao Host (Opcional)
Caso não seja executado um servidor DNS local (Pi-Hole), é necessário adicionar entradas ao arquivo `hosts` do Windows para que os serviços possam ser acessados pelo nome amigável, como por exemplo `http://radarr.homerr` ou `http://plex.homerr`.
Execute `scripts\setup_hosts.bat` como Administrador para adicionar rotas locais:

Isto adiciona ao `hosts` uma série de entradas, como por exemplo:

```
127.0.0.1    caddy.homerr
```


## Expansão do Servidor
Caso queira adicionar um serviço novo ao servidor, é necessário adicionar a entrada do serviço nos arquivos:
- `docker-compose.yml`
- `.env`
- `scripts\setup_hosts.bat`
- `config/caddy/Caddyfile`


## Arquitetura do Servidor
Para facilitar a visualização da arquitetura do servidor, foi criado um diagrama de fluxo, que mostra a relação entre os serviços e como eles se comunicam entre si -> [DIAGRAMA](DIAGRAMA.md)


## Notas
Arquivo contendo ideias para o projeto -> [NOTAS](NOTAS.md)
# Homerr
IaC para um servidor caseiro, com diversar aplicações, variando de mídia até IoT

## Estrutura de pasta
Para que o projeto se mantenha organizado, é necessário manter uma ordem lógica, devido o número de containers existentes.

```text
Homerr/
├── 📄 README.md
├── 📄 docker-compose.yml
├── 📁 config/
└── 📁 media/
    ├── 📁 movies
    └── 📁 series
```

## Como executar o script Windows para adicionar entradas no hosts

Execute `scripts\setup_hosts.bat` em uma PowerShell ou prompt de comando aberto como Administrador.

Exemplo:

```powershell
Start-Process -FilePath .\scripts\setup_hosts.bat -Verb RunAs
```

Como resultado o script acrescenta ao final do arquivo `hosts` um bloco contendo nomes para os serviços, dessa forma facilitando o acesso.

```
# BEGIN homerr-hosts
127.0.0.1    homerr.homarr
127.0.0.1    homerr.plex
127.0.0.1    homerr.sonarr
127.0.0.1    homerr.radarr
127.0.0.1    homerr.bazarr
127.0.0.1    homerr.prowlarr
127.0.0.1    homerr.seerr
127.0.0.1    homerr.qbittorrent
127.0.0.1    homerr.pihole
127.0.0.1    homerr.watchtower
# END homerr-hosts
```

> **⚠️ Observação ⚠️**
> 
> A execução do script é necessária em caso de não utilizar um DNS local, assim se tornando necessário um direcionamento manual para as rotas

## Serviços Disponíveis

| Nome | URL de Acesso | Descrição | Portas Mapeadas | Volumes Mapeados |
|------|---------------|-----------|-----------------|------------------|
| **Traefik** | http://homerr.traefik:8080 | Reverse proxy e roteador | 80, 443, 8080 | `/var/run/docker.sock`, `./config/traefik/` |
| **Homarr** | http://homerr.homarr | Dashboard/Interface home | 7575 | `./config/homarr:/app/data` |
| **Plex** | http://homerr.plex | Media Server | 32400 | `./config/plex:/config`, `./media:/media`, `./downloads:/downloads` |
| **Sonarr** | http://homerr.sonarr | Gerenciador de séries de TV | 8989 | `./config/sonarr:/config`, `./downloads:/downloads`, `./media:/media` |
| **Radarr** | http://homerr.radarr | Gerenciador de filmes | 7878 | `./config/radarr:/config`, `./downloads:/downloads`, `./media:/media` |
| **Bazarr** | http://homerr.bazarr | Gerenciador de legendas | 6767 | `./config/bazarr:/config`, `./media:/media` |
| **Prowlarr** | http://homerr.prowlarr | Gerenciador de indexadores | 9696 | `./config/prowlarr:/config` |
| **Seerr** | http://homerr.seerr | Gerenciador de requisições | 5055 | `./config/seerr:/app/config` |
| **qBittorrent** | http://homerr.qbittorrent | Cliente torrent | 8080, 6881 (TCP/UDP) | `./config/qbittorrent:/config`, `./downloads:/downloads` |
| **Pi-hole** | http://homerr.pihole | Bloqueador de DNS | 53 (TCP/UDP), 8081, 443 | `./config/pihole/etc-pihole`, `./config/pihole/etc-dnsmasq.d` |
| **Watchtower** | — | Atualizador automático de containers | — | `/var/run/docker.sock` |
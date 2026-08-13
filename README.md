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

> **Observação ⚠️**
> 
> A execução do script é necessária em caso de não utilizar um DNS local, assim se tornando necessário um direcionamento manual para as rotas
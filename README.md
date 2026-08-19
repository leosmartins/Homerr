# Homerr
IaC para um servidor caseiro, com diversas aplicações, variando de mídia até IoT

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

### 3. Iniciar os Serviços

```bash
# Iniciar todos os serviços em background
docker-compose up -d

# Verificar status dos containers
docker-compose ps 
```

### 4. Adicionar Entradas ao Host (Opcional)

Execute `scripts\setup_hosts.bat` como Administrador para adicionar rotas locais:

Isto adiciona ao `hosts`:

```
127.0.0.1    homerr.homarr
127.0.0.1    homerr.plex
127.0.0.1    homerr.sonarr
127.0.0.1    homerr.radarr
127.0.0.1    homerr.bazarr
127.0.0.1    homerr.prowlarr
127.0.0.1    homerr.seerr
127.0.0.1    homerr.qbittorrent
127.0.0.1    homerr.pihole
```

## Arquitetura de Rede

O projeto utiliza dois modos de rede Docker:

### **Bridge Network (Padrão)**

A maioria dos serviços roda em uma rede bridge customizada (`homerrNet`). Isto oferece:
- ✅ Isolamento de rede
- ✅ Comunicação natural entre containers
- ⚠️ Requer mapeamento explícito de portas

Containers na rede bridge podem se comunicar pelo nome: `http://sonarr:8989`

### **Host Network (Plex)**

O Plex roda em `network_mode: host` para:
- ✅ Melhor performance
- ✅ Auto-discovery de clientes
- ✅ Acesso direto às portas do host
- ❌ Sem isolamento de rede

**Acesso ao Plex:**
- Local: `http://localhost:32400`
- Caddy: `http://homerr.plex` (via `host.docker.internal`)
- Remoto: `http://seu-ip:32400`

## Integrações entre Serviços

Os serviços estão configurados para comunicação automática:
<!-- TODO: Adicionar imagem ao README.md, remover desenho asc das integrações -->

```
Prowlarr (Indexadores)
    ↑
Sonarr ↔ Radarr (Sincronização mútua)
    ↑       ↑
Bazarr (Busca legendas em ambos)
    
Seerr (Envia requisições)
    ↑
Sonarr & Radarr (Processam)
```

**Variáveis de Integração:**

| Serviço | Integra Com | Variável |
|---------|-------------|----------|
| Sonarr | Prowlarr | `PROWLARR_HOST` |
| Radarr | Sonarr, Prowlarr | `SONARR_HOST`, `PROWLARR_HOST` |
| Bazarr | Sonarr, Radarr | `SONARR_HOST`, `RADARR_HOST` |
| Seerr | Sonarr, Radarr | `SONARR_HOST`, `RADARR_HOST` |

Estas variáveis são configuradas automaticamente no `docker-compose.yml` e usam o DNS interno do Docker para se conectar.

## Serviços Disponíveis

| Nome | URL de Acesso | Descrição | Porta Interna | Modo Rede | Volumes |
|------|---------------|-----------|---------------|-----------|---------|
| **Caddy** | http://homerr.* | Reverse proxy e roteador | 80 | Bridge | `./config/caddy/Caddyfile`, `./config/caddy/data` |
| **Homarr** | http://homerr.homarr | Dashboard/Interface home | 7575 | Bridge | `./config/homarr:/app/data` |
| **Plex** | http://homerr.plex | Media Server | 32400 | **Host** | `./config/plex:/config`, `./media:/media`, `./downloads:/downloads` |
| **Sonarr** | http://homerr.sonarr | Gerenciador de séries TV | 8989 | Bridge | `./config/sonarr:/config`, `./downloads:/downloads`, `./media:/media` |
| **Radarr** | http://homerr.radarr | Gerenciador de filmes | 7878 | Bridge | `./config/radarr:/config`, `./downloads:/downloads`, `./media:/media` |
| **Bazarr** | http://homerr.bazarr | Gerenciador de legendas | 6767 | Bridge | `./config/bazarr:/config`, `./media:/media` |
| **Prowlarr** | http://homerr.prowlarr | Gerenciador de indexadores | 9696 | Bridge | `./config/prowlarr:/config` |
| **Seerr** | http://homerr.seerr | Gerenciador de requisições | 5055 | Bridge | `./config/seerr:/app/config` |
| **qBittorrent** | http://homerr.qbittorrent | Cliente torrent | 8080 | Bridge | `./config/qbittorrent:/config`, `./downloads:/downloads` |
| **Pi-hole** | http://homerr.pihole | Bloqueador de DNS | 80, 53 | Bridge | `./config/pihole/etc-pihole`, `./config/pihole/etc-dnsmasq.d` |
| **Watchtower** | — | Atualizador automático | — | Bridge | `/var/run/docker.sock` |

## Portas Dinâmicas

Todas as portas mapeadas no host podem ser customizadas via arquivo `.env`:

```env
# Caddy
CADDY_PORT_HTTP=80
CADDY_PORT_HTTPS=443

# Serviços
HOMARR_PORT=7575
SONARR_PORT=8989
RADARR_PORT=7878
BAZARR_PORT=6767
PROWLARR_PORT=9696
SEERR_PORT=5055
QBITTORRENT_PORT_TORRENT=6881
PIHOLE_PORT_DNS_TCP=53
PIHOLE_PORT_DNS_UDP=53
PIHOLE_PORT_WEBUI=8081
```

**Formato:** `${VARIAVEL:-valor-padrao}`

Se a variável não existir no `.env`, usa o valor padrão.

## Comandos Úteis

```bash
# Iniciar todos os serviços
docker-compose up -d

# Parar todos os serviços
docker-compose down

# Ver status dos containers
docker-compose ps

# Ver logs em tempo real
docker-compose logs -f [serviço]

# Executar comando dentro de um container
docker-compose exec [serviço] [comando]

# Validar arquivo docker-compose
docker-compose config

# Reconstruir uma imagem
docker-compose up -d --build [serviço]
```

## Resolução de Problemas

### Plex não aparece para clientes remotos

O Plex roda em `network_mode: host`. Certifique-se de:
1. ✅ Configurar `PLEX_CLAIM` no `.env`
2. ✅ Fazer login na conta Plex na interface
3. ✅ Configurar Remote Access nas configurações do Plex
4. ✅ Abrir porta 32400 no firewall/roteador (se necessário)

### Serviços não conseguem se comunicar

Os serviços (Sonarr, Radarr, etc.) usam o DNS interno do Docker. Se um serviço não encontra outro:

```bash
# Testar conectividade entre containers
docker-compose exec radarr ping sonarr

# Ver configurações da rede
docker network inspect homerr-homerrnet
```

### qBittorrent e Pi-hole

O painel web desses serviços é acessado pelo Caddy:
- qBittorrent: `http://homerr.qbittorrent`
- Pi-hole: `http://homerr.pihole`

### Portas em conflito

Se receber erro "port already in use", modifique as portas no `.env`:

```env
CADDY_PORT_HTTP=8000    # Ao invés de 80
```

Depois restartar:
```bash
docker-compose down
docker-compose up -d
```

## Backup e Manutenção

### Backup de Dados

Todos os dados importantes estão em `./config/`:

```bash
# Backup completo
tar -czf backup-$(date +%Y%m%d).tar.gz ./config/

# Ou use sua ferramenta de backup preferida
robocopy ./config D:\Backups\homerr /E /Z
```

### Atualizações Automáticas

Watchtower atualiza automaticamente todas as imagens. Configure via `.env`:

```env
# Verificar updates a cada 24h
WATCHTOWER_POLL_INTERVAL=86400

# Remover imagens antigas
WATCHTOWER_CLEANUP=true
```

### Limpeza de Disco

```bash
# Remover containers parados
docker container prune

# Remover imagens não utilizadas
docker image prune

# Remover volumes orfãos
docker volume prune

# Completo (⚠️ cuidado!)
docker system prune -a
```

## Notas Importantes

> **⚠️ Segurança**
> - Nunca commitar arquivo `.env` no git
> - Usar senhas fortes no `.env` (especialmente `PIHOLE_PASSWORD`)
> - Considerar usar HTTPS no Caddy em produção
> - Limitar acesso remoto conforme necessário

> **💾 Dados**
> - Fazer backup regular da pasta `./config/`
> - O arquivo `.env` também é importante (contém credenciais)
> - Volumes Docker podem crescer bastante

> **📡 Networking**
> - Plex em host mode é a configuração recomendada
> - Caddy funciona com todos os serviços via bridge
> - Não é necessário bidirecionalidade nas integrações
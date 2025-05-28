# SeveroTech Landing Page

## Sobre o Projeto

Landing page moderna e responsiva da SeveroTech, desenvolvida com ASP.NET Core e design system contemporÃ¢neo.

## Funcionalidades Implementadas

### Design e UX
- Design moderno com sistema de cores consistente
- Responsivo para todos os dispositivos
- AnimaÃ§Ãµes e transiÃ§Ãµes suaves
- Componentes reutilizÃ¡veis

### Performance
- CSS e JavaScript otimizados
- Lazy loading de imagens
- CompressÃ£o de recursos
- Service Worker para cache

### Funcionalidades
- Sistema de contato por email
- FormulÃ¡rios com validaÃ§Ã£o em tempo real
- Chatbot inteligente
- PWA instalÃ¡vel
- SEO otimizado

### SeguranÃ§a
- Headers de seguranÃ§a configurados
- ValidaÃ§Ã£o anti-spam
- HTTPS forÃ§ado
- Content Security Policy

## ConfiguraÃ§Ã£o

### 1. Email (OBRIGATÃ“RIO)
Edite `appsettings.Production.json`:
```json
{
  "SmtpSettings": {
    "Username": "seu-email@gmail.com",
    "Password": "sua-senha-de-app-do-gmail"
  }
}
```

### 2. Analytics (Opcional)
Substitua os IDs em `appsettings.Production.json`:
- `GoogleAnalyticsId`: seu ID do Google Analytics
- `GoogleTagManagerId`: seu ID do Google Tag Manager

## Deploy

### Para IIS
1. Executar: `dotnet publish -c Release`
2. Copiar arquivos para o servidor
3. `web.config` jÃ¡ estÃ¡ configurado

### Para Azure/Outros
1. Configurar variÃ¡veis de ambiente
2. Deploy via Git ou CI/CD

## Estrutura de Arquivos

```
SeveroTechLanding/
â”œâ”€â”€ Controllers/       # APIs REST
â”œâ”€â”€ Models/           # Modelos de dados  
â”œâ”€â”€ Services/         # ServiÃ§os (Email, etc)
â”œâ”€â”€ Pages/            # Razor Pages
â””â”€â”€ wwwroot/assets/   # Recursos estÃ¡ticos
    â”œâ”€â”€ css/          # Estilos
    â”œâ”€â”€ js/           # JavaScript
    â””â”€â”€ images/       # Imagens
```

## Suporte

- **Email**: contato@severotech.com.br
- **WhatsApp**: +55 (71) 99111-5873

## PrÃ³ximos Passos

1. Configure as credenciais SMTP
2. Teste o formulÃ¡rio de contato
3. Personalize o conteÃºdo
4. FaÃ§a o deploy para produÃ§Ã£o
5. Configure domÃ­nio e SSL

---

**Desenvolvido pela equipe SeveroTech**

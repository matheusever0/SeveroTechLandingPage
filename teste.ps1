# =========================================================================
# SCRIPT DE REESTRUTURAÇÃO SEVEROTECH - FASE 1
# Automatiza a reorganização de arquivos e criação da nova estrutura
# =========================================================================

param(
    [string]$ProjectPath = (Get-Location),
    [switch]$CreateBackup = $true,
    [switch]$DryRun = $false
)

# Cores para output
$Green = @{ForegroundColor = "Green"}
$Yellow = @{ForegroundColor = "Yellow"}
$Red = @{ForegroundColor = "Red"}
$Cyan = @{ForegroundColor = "Cyan"}

function Write-Header {
    param([string]$Text)
    Write-Host ""
    Write-Host "=" * 70 @Cyan
    Write-Host " $Text" @Cyan
    Write-Host "=" * 70 @Cyan
}

function Write-Step {
    param([string]$Text)
    Write-Host "🔄 $Text" @Yellow
}

function Write-Success {
    param([string]$Text)
    Write-Host "✅ $Text" @Green
}

function Write-Error {
    param([string]$Text)
    Write-Host "❌ $Text" @Red
}

# =========================================================================
# CONFIGURAÇÕES E VALIDAÇÕES
# =========================================================================

Write-Header "SEVEROTECH REESTRUTURAÇÃO - FASE 1"

if ($DryRun) {
    Write-Host "🧪 MODO DRY RUN - Nenhum arquivo será modificado" @Yellow
}

# Validar se estamos no diretório correto
$csprojFile = Get-ChildItem -Path $ProjectPath -Filter "*.csproj" | Select-Object -First 1
if (-not $csprojFile) {
    Write-Error "Arquivo .csproj não encontrado em: $ProjectPath"
    Write-Host "Certifique-se de estar no diretório raiz do projeto."
    exit 1
}

Write-Success "Projeto encontrado: $($csprojFile.Name)"
Write-Host "Diretório de trabalho: $ProjectPath"

# =========================================================================
# BACKUP DA ESTRUTURA ATUAL
# =========================================================================

if ($CreateBackup -and -not $DryRun) {
    Write-Header "CRIANDO BACKUP"
    
    $backupFolder = Join-Path $ProjectPath "backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    $foldersToBackup = @("wwwroot", "Pages/Shared")
    
    New-Item -ItemType Directory -Path $backupFolder -Force | Out-Null
    
    foreach ($folder in $foldersToBackup) {
        $sourcePath = Join-Path $ProjectPath $folder
        if (Test-Path $sourcePath) {
            $destPath = Join-Path $backupFolder $folder
            Write-Step "Fazendo backup de: $folder"
            Copy-Item -Path $sourcePath -Destination $destPath -Recurse -Force
        }
    }
    
    Write-Success "Backup criado em: $backupFolder"
}

# =========================================================================
# CRIAÇÃO DA NOVA ESTRUTURA DE PASTAS
# =========================================================================

Write-Header "CRIANDO NOVA ESTRUTURA DE PASTAS"

$newFolders = @(
    # WWWRoot Assets
    "wwwroot/assets",
    "wwwroot/assets/css",
    "wwwroot/assets/css/base",
    "wwwroot/assets/css/components",
    "wwwroot/assets/css/layout",
    "wwwroot/assets/css/utilities",
    "wwwroot/assets/js",
    "wwwroot/assets/js/components",
    "wwwroot/assets/js/utils",
    "wwwroot/assets/images",
    "wwwroot/assets/images/logos",
    "wwwroot/assets/images/team",
    "wwwroot/assets/images/services",
    "wwwroot/assets/images/backgrounds",
    "wwwroot/assets/images/icons",
    "wwwroot/assets/fonts",
    
    # Pages/Shared organization
    "Pages/Shared/Layout",
    "Pages/Shared/Sections",
    "Pages/Shared/Components"
)

foreach ($folder in $newFolders) {
    $fullPath = Join-Path $ProjectPath $folder
    Write-Step "Criando pasta: $folder"
    
    if (-not $DryRun) {
        New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
    }
}

Write-Success "Estrutura de pastas criada!"

# =========================================================================
# MIGRAÇÃO DE IMAGENS
# =========================================================================

Write-Header "MIGRANDO IMAGENS"

$imageMappings = @{
    "wwwroot/landingpage/img/logo.png" = "wwwroot/assets/images/logos/logo.png"
    "wwwroot/landingpage/img/LOGO-MATHEUS-CINZA.png" = "wwwroot/assets/images/logos/logo-gray.png"
    "wwwroot/landingpage/img/team-1.jpg" = "wwwroot/assets/images/team/matheus-severo.jpg"
    "wwwroot/landingpage/img/carousel-1.jpg" = "wwwroot/assets/images/backgrounds/hero-1.jpg"
    "wwwroot/landingpage/img/carousel-2.jpg" = "wwwroot/assets/images/backgrounds/hero-2.jpg"
    "wwwroot/landingpage/img/about.jpg" = "wwwroot/assets/images/backgrounds/about.jpg"
    "wwwroot/landingpage/img/feature.jpg" = "wwwroot/assets/images/backgrounds/feature.jpg"
}

foreach ($mapping in $imageMappings.GetEnumerator()) {
    $sourcePath = Join-Path $ProjectPath $mapping.Key
    $destPath = Join-Path $ProjectPath $mapping.Value
    
    if (Test-Path $sourcePath) {
        Write-Step "Copiando: $($mapping.Key) → $($mapping.Value)"
        if (-not $DryRun) {
            Copy-Item -Path $sourcePath -Destination $destPath -Force
        }
    } else {
        Write-Host "⚠️  Arquivo não encontrado: $($mapping.Key)" @Yellow
    }
}

# =========================================================================
# REORGANIZAÇÃO DAS VIEWS
# =========================================================================

Write-Header "REORGANIZANDO VIEWS"

$viewMappings = @{
    "Pages/Shared/__Hero.cshtml" = "Pages/Shared/Layout/_Hero.cshtml"
    "Pages/Shared/__Navbar.cshtml" = "Pages/Shared/Layout/_Navbar.cshtml"
    "Pages/Shared/__Footer.cshtml" = "Pages/Shared/Layout/_Footer.cshtml"
    "Pages/Shared/__Topbar.cshtml" = "Pages/Shared/Layout/_Topbar.cshtml"
    "Pages/Shared/__Header.cshtml" = "Pages/Shared/Layout/_Header.cshtml"
    "Pages/Shared/__Service.cshtml" = "Pages/Shared/Sections/_Services.cshtml"
    "Pages/Shared/__Sobre.cshtml" = "Pages/Shared/Sections/_About.cshtml"
    "Pages/Shared/__Team.cshtml" = "Pages/Shared/Sections/_Team.cshtml"
    "Pages/Shared/__Contato.cshtml" = "Pages/Shared/Sections/_Contact.cshtml"
    "Pages/Shared/__Features.cshtml" = "Pages/Shared/Sections/_Features.cshtml"
    "Pages/Shared/__FullScreenSearch.cshtml" = "Pages/Shared/Components/_FullScreenSearch.cshtml"
}

foreach ($mapping in $viewMappings.GetEnumerator()) {
    $sourcePath = Join-Path $ProjectPath $mapping.Key
    $destPath = Join-Path $ProjectPath $mapping.Value
    
    if (Test-Path $sourcePath) {
        Write-Step "Movendo: $($mapping.Key) → $($mapping.Value)"
        if (-not $DryRun) {
            Move-Item -Path $sourcePath -Destination $destPath -Force
        }
    } else {
        Write-Host "⚠️  Arquivo não encontrado: $($mapping.Key)" @Yellow
    }
}

# =========================================================================
# CRIAÇÃO DOS ARQUIVOS CSS BASE
# =========================================================================

Write-Header "CRIANDO ARQUIVOS CSS BASE"

# Variables CSS
$variablesCSS = @"
/* =========================================================================
   SEVEROTECH DESIGN TOKENS - Variables CSS
   ========================================================================= */

:root {
  /* === CORES SEVEROTECH === */
  --severo-green-primary: #28a745;
  --severo-green-light: #34ce57;
  --severo-green-dark: #1e7e34;
  --severo-gray-dark: #2c3e50;
  --severo-gray-light: #f8f9fa;
  
  /* === SISTEMA DE CORES === */
  --color-primary: var(--severo-green-primary);
  --color-primary-light: var(--severo-green-light);
  --color-primary-dark: var(--severo-green-dark);
  --color-dark: var(--severo-gray-dark);
  --color-light: var(--severo-gray-light);
  --color-white: #ffffff;
  --color-black: #000000;
  
  /* === GRADIENTES === */
  --gradient-primary: linear-gradient(135deg, var(--severo-green-primary), var(--severo-green-light));
  --gradient-dark: linear-gradient(135deg, var(--severo-gray-dark), #34495e);
  
  /* === ESPAÇAMENTOS === */
  --space-xs: 0.5rem;    /* 8px */
  --space-sm: 1rem;      /* 16px */
  --space-md: 1.5rem;    /* 24px */
  --space-lg: 2.5rem;    /* 40px */
  --space-xl: 4rem;      /* 64px */
  --space-xxl: 6rem;     /* 96px */
  
  /* === TIPOGRAFIA === */
  --font-primary: 'Nunito', -apple-system, BlinkMacSystemFont, sans-serif;
  --font-secondary: 'Rubik', -apple-system, BlinkMacSystemFont, sans-serif;
  --font-size-xs: 0.75rem;
  --font-size-sm: 0.875rem;
  --font-size-base: 1rem;
  --font-size-lg: 1.125rem;
  --font-size-xl: 1.25rem;
  --font-size-2xl: 1.5rem;
  --font-size-3xl: 2rem;
  --font-size-4xl: 3rem;
  
  /* === SOMBRAS === */
  --shadow-xs: 0 1px 2px rgba(0, 0, 0, 0.05);
  --shadow-sm: 0 2px 8px rgba(0, 0, 0, 0.1);
  --shadow-md: 0 4px 16px rgba(0, 0, 0, 0.1);
  --shadow-lg: 0 8px 32px rgba(0, 0, 0, 0.15);
  --shadow-xl: 0 16px 64px rgba(0, 0, 0, 0.2);
  
  /* === BORDER RADIUS === */
  --radius-sm: 0.375rem;
  --radius-md: 0.5rem;
  --radius-lg: 1rem;
  --radius-xl: 1.5rem;
  --radius-full: 9999px;
  
  /* === TRANSIÇÕES === */
  --transition-fast: all 0.15s ease;
  --transition-base: all 0.3s ease;
  --transition-slow: all 0.5s ease;
  
  /* === Z-INDEX === */
  --z-dropdown: 1000;
  --z-sticky: 1020;
  --z-fixed: 1030;
  --z-modal: 1040;
  --z-popover: 1050;
  --z-tooltip: 1060;
}

/* === CLASSES UTILITÁRIAS === */
.text-green-severotech { color: var(--color-primary) !important; }
.bg-green { background-color: var(--color-primary) !important; }
.bg-dark-severotech { background-color: var(--color-dark) !important; }
.btn-green { 
  background-color: var(--color-primary);
  border-color: var(--color-primary);
  color: var(--color-white);
  transition: var(--transition-base);
}
.btn-green:hover {
  background-color: var(--color-primary-dark);
  border-color: var(--color-primary-dark);
  transform: translateY(-2px);
  box-shadow: var(--shadow-lg);
}
.btn-outline-green {
  border-color: var(--color-primary);
  color: var(--color-primary);
  transition: var(--transition-base);
}
.btn-outline-green:hover {
  background-color: var(--color-primary);
  border-color: var(--color-primary);
  color: var(--color-white);
}
"@

# Reset CSS
$resetCSS = @"
/* =========================================================================
   SEVEROTECH RESET CSS - Normalização base
   ========================================================================= */

/* Box sizing reset */
*,
*::before,
*::after {
  box-sizing: border-box;
}

/* Remove default margins */
* {
  margin: 0;
  padding: 0;
}

/* Improve media defaults */
img,
picture,
video,
canvas,
svg {
  display: block;
  max-width: 100%;
  height: auto;
}

/* Remove built-in form typography styles */
input,
button,
textarea,
select {
  font: inherit;
}

/* Avoid text overflows */
p,
h1,
h2,
h3,
h4,
h5,
h6 {
  overflow-wrap: break-word;
}

/* Improve line heights */
body {
  line-height: 1.6;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

/* Remove list styles */
ul,
ol {
  list-style: none;
}

/* Remove link underlines */
a {
  text-decoration: none;
  color: inherit;
}

/* Focus styles */
:focus-visible {
  outline: 2px solid var(--color-primary);
  outline-offset: 2px;
}
"@

# Typography CSS
$typographyCSS = @"
/* =========================================================================
   SEVEROTECH TYPOGRAPHY - Sistema tipográfico
   ========================================================================= */

body {
  font-family: var(--font-primary);
  font-size: var(--font-size-base);
  color: var(--color-dark);
  background-color: var(--color-white);
}

/* Headings */
h1, h2, h3, h4, h5, h6 {
  font-family: var(--font-secondary);
  font-weight: 700;
  line-height: 1.2;
  margin-bottom: var(--space-sm);
  color: var(--color-dark);
}

h1 { font-size: var(--font-size-4xl); }
h2 { font-size: var(--font-size-3xl); }
h3 { font-size: var(--font-size-2xl); }
h4 { font-size: var(--font-size-xl); }
h5 { font-size: var(--font-size-lg); }
h6 { font-size: var(--font-size-base); }

/* Paragraphs */
p {
  margin-bottom: var(--space-sm);
  line-height: 1.7;
}

/* Links */
a {
  color: var(--color-primary);
  transition: var(--transition-base);
}

a:hover {
  color: var(--color-primary-dark);
}

/* Strong and emphasis */
strong, b {
  font-weight: 600;
}

em, i {
  font-style: italic;
}

/* Display classes */
.display-1 { font-size: 5rem; font-weight: 700; }
.display-2 { font-size: 4rem; font-weight: 700; }
.display-3 { font-size: 3rem; font-weight: 700; }
.display-4 { font-size: 2.5rem; font-weight: 700; }

/* Text utilities */
.text-center { text-align: center; }
.text-left { text-align: left; }
.text-right { text-align: right; }
.text-uppercase { text-transform: uppercase; }
.text-lowercase { text-transform: lowercase; }
.text-capitalize { text-transform: capitalize; }

/* Font weights */
.fw-light { font-weight: 300; }
.fw-normal { font-weight: 400; }
.fw-medium { font-weight: 500; }
.fw-semibold { font-weight: 600; }
.fw-bold { font-weight: 700; }
.fw-black { font-weight: 900; }
"@

# Main CSS
$mainCSS = @"
/* =========================================================================
   SEVEROTECH MAIN CSS - Estilos principais
   ========================================================================= */

/* Import all base styles */
@import 'base/variables.css';
@import 'base/reset.css';
@import 'base/typography.css';

/* Import components */
@import 'components/buttons.css';
@import 'components/cards.css';

/* Import layout */
@import 'layout/header.css';
@import 'layout/footer.css';

/* Global styles */
.section-padding {
  padding: var(--space-xxl) 0;
}

.container-custom {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 var(--space-md);
}

/* Animations */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.animate-fade-in-up {
  animation: fadeInUp 0.8s ease-out;
}

.animate-fade-in {
  animation: fadeIn 0.6s ease-out;
}

/* Smooth scrolling */
html {
  scroll-behavior: smooth;
}

/* Loading spinner styles */
.spinner {
  width: 40px;
  height: 40px;
  border: 4px solid rgba(255, 255, 255, 0.3);
  border-radius: 50%;
  border-top-color: var(--color-white);
  animation: spin 1s ease-in-out infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}
"@

# Salvar arquivos CSS
$cssFiles = @{
    "wwwroot/assets/css/base/variables.css" = $variablesCSS
    "wwwroot/assets/css/base/reset.css" = $resetCSS
    "wwwroot/assets/css/base/typography.css" = $typographyCSS
    "wwwroot/assets/css/main.css" = $mainCSS
}

foreach ($file in $cssFiles.GetEnumerator()) {
    $filePath = Join-Path $ProjectPath $file.Key
    Write-Step "Criando: $($file.Key)"
    
    if (-not $DryRun) {
        $file.Value | Out-File -FilePath $filePath -Encoding UTF8
    }
}

# =========================================================================
# ATUALIZAÇÃO DO ARQUIVO __css.cshtml
# =========================================================================

Write-Header "ATUALIZANDO REFERÊNCIAS CSS"

$newCssContent = @"
<!-- Google Web Fonts -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;500;600;700;800&family=Rubik:wght@400;500;600;700&display=swap" rel="stylesheet">

<!-- Icon Font Stylesheet -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

<!-- Libraries Stylesheet -->
<link href="~/landingpage/lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
<link href="~/landingpage/lib/animate/animate.min.css" rel="stylesheet">

<!-- Bootstrap (manter temporariamente) -->
<link href="~/landingpage/css/bootstrap.min.css" rel="stylesheet">

<!-- SeveroTech Design System -->
<link href="~/assets/css/base/variables.css" rel="stylesheet">
<link href="~/assets/css/base/reset.css" rel="stylesheet">
<link href="~/assets/css/base/typography.css" rel="stylesheet">
<link href="~/assets/css/main.css" rel="stylesheet">

<!-- Template Original (manter temporariamente durante migração) -->
<link href="~/landingpage/css/style.css" rel="stylesheet">
"@

$cssFilePath = Join-Path $ProjectPath "Pages/Shared/__css.cshtml"
if (Test-Path $cssFilePath) {
    Write-Step "Atualizando: Pages/Shared/__css.cshtml"
    if (-not $DryRun) {
        $newCssContent | Out-File -FilePath $cssFilePath -Encoding UTF8
    }
}

# =========================================================================
# RELATÓRIO FINAL
# =========================================================================

Write-Header "RELATÓRIO FINAL"

Write-Success "✅ Reestruturação da Fase 1 concluída!"
Write-Host ""
Write-Host "📋 RESUMO DAS ALTERAÇÕES:" @Cyan
Write-Host "   • Nova estrutura de pastas criada em wwwroot/assets/" @Green
Write-Host "   • Views reorganizadas em subpastas temáticas" @Green
Write-Host "   • Sistema de Design Tokens implementado" @Green
Write-Host "   • Imagens migradas para nova estrutura" @Green
Write-Host "   • Arquivos CSS base criados" @Green

Write-Host ""
Write-Host "📁 PRÓXIMOS PASSOS:" @Yellow
Write-Host "   1. Testar o site para verificar se tudo funciona"
Write-Host "   2. Atualizar referências nos arquivos de view restantes"
Write-Host "   3. Começar Fase 2 - Modernização do Design"

Write-Host ""
Write-Host "⚠️  IMPORTANTE:" @Yellow
Write-Host "   • Backup criado em: backup_[timestamp]" @Yellow
Write-Host "   • Alguns arquivos antigos foram mantidos para compatibilidade" @Yellow
Write-Host "   • Teste todas as páginas antes de continuar" @Yellow

Write-Host ""
Write-Success "Script executado com sucesso! 🚀"
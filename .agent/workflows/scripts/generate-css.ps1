<#
.SYNOPSIS
  コーポレートサイト用CSSテンプレートを生成するPowerShellスクリプト

.DESCRIPTION
  指定されたカラーパレット・フォント設定を元に、コーポレートサイト用の
  CSSテンプレート（デザイントークン + ベーススタイル）を生成します。

.PARAMETER OutputPath
  生成するCSSファイルの出力先（省略時: ./style.css）

.PARAMETER PrimaryBg
  背景メインカラー（デフォルト: #0A1628）

.PARAMETER AccentColor
  アクセントカラー（デフォルト: #4A90E2）

.PARAMETER AccentSecondary
  サブアクセントカラー（デフォルト: #38BDF8）

.PARAMETER FontPrimary
  メインフォント（デフォルト: 'Noto Sans JP'）

.PARAMETER FontDisplay
  ディスプレイフォント（デフォルト: 'Outfit'）

.PARAMETER Mode
  テーマモード: dark または light（デフォルト: dark）

.EXAMPLE
  .\generate-css.ps1
  .\generate-css.ps1 -AccentColor "#10B981" -Mode "light"
  .\generate-css.ps1 -OutputPath "custom-style.css" -PrimaryBg "#1A1A2E" -AccentColor "#E94560"
#>

param(
    [string]$OutputPath = "./style.css",
    [string]$PrimaryBg = "#0A1628",
    [string]$AccentColor = "#4A90E2",
    [string]$AccentSecondary = "#38BDF8",
    [string]$FontPrimary = "'Noto Sans JP'",
    [string]$FontDisplay = "'Outfit'",
    [ValidateSet("dark", "light")]
    [string]$Mode = "dark"
)

# --- テーマ設定 ---
if ($Mode -eq "light") {
    $bgPrimary = "#FFFFFF"
    $bgSecondary = "#F8FAFC"
    $bgTertiary = "#F1F5F9"
    $bgCard = "rgba(241, 245, 249, 0.6)"
    $bgGlass = "rgba(0, 0, 0, 0.02)"
    $bgGlassHover = "rgba(0, 0, 0, 0.04)"
    $textPrimary = "#0F172A"
    $textSecondary = "#475569"
    $textMuted = "#94A3B8"
    $border = "rgba(0, 0, 0, 0.08)"
} else {
    $bgPrimary = $PrimaryBg
    $bgSecondary = "#0F1F3A"
    $bgTertiary = "#132744"
    $bgCard = "rgba(15, 31, 58, 0.6)"
    $bgGlass = "rgba(255, 255, 255, 0.04)"
    $bgGlassHover = "rgba(255, 255, 255, 0.08)"
    $textPrimary = "#F1F5F9"
    $textSecondary = "#94A3B8"
    $textMuted = "#64748B"
    $border = "rgba(255, 255, 255, 0.08)"
}

# --- Google FontsのインポートURL生成 ---
$fontPrimaryClean = $FontPrimary -replace "'", ""
$fontDisplayClean = $FontDisplay -replace "'", ""
$fontPrimaryUrl = $fontPrimaryClean -replace " ", "+"
$fontDisplayUrl = $fontDisplayClean -replace " ", "+"

$cssContent = @"
/* ============================================
   コーポレートサイト - 自動生成CSSテンプレート
   モード: $Mode
   生成日: $(Get-Date -Format 'yyyy-MM-dd')
   ============================================ */

/* --- Google Fonts --- */
@import url('https://fonts.googleapis.com/css2?family=${fontPrimaryUrl}:wght@300;400;500;700;900&family=${fontDisplayUrl}:wght@300;400;500;600;700;800&display=swap');

/* --- デザイントークン --- */
:root {
  /* カラーパレット */
  --color-bg-primary: ${bgPrimary};
  --color-bg-secondary: ${bgSecondary};
  --color-bg-tertiary: ${bgTertiary};
  --color-bg-card: ${bgCard};
  --color-bg-glass: ${bgGlass};
  --color-bg-glass-hover: ${bgGlassHover};

  --color-accent-primary: ${AccentColor};
  --color-accent-secondary: ${AccentSecondary};
  --color-accent-gradient: linear-gradient(135deg, ${AccentColor} 0%, ${AccentSecondary} 50%, #06B6D4 100%);

  --color-text-primary: ${textPrimary};
  --color-text-secondary: ${textSecondary};
  --color-text-muted: ${textMuted};
  --color-text-accent: ${AccentSecondary};

  --color-border: ${border};
  --color-border-hover: rgba(74, 144, 226, 0.4);

  /* タイポグラフィ */
  --font-sans: ${FontPrimary}, ${FontDisplay}, -apple-system, BlinkMacSystemFont, sans-serif;
  --font-display: ${FontDisplay}, ${FontPrimary}, sans-serif;

  /* スペーシング */
  --section-padding: 120px 0;
  --container-width: 1200px;
  --container-padding: 0 24px;

  /* ボーダー */
  --radius-sm: 8px;
  --radius-md: 12px;
  --radius-lg: 20px;
  --radius-xl: 28px;

  /* シャドウ */
  --shadow-card: 0 4px 30px rgba(0, 0, 0, 0.3);
  --shadow-glow: 0 0 40px rgba(74, 144, 226, 0.15);
  --shadow-button: 0 4px 20px rgba(74, 144, 226, 0.4);

  /* トランジション */
  --transition-fast: 0.2s ease;
  --transition-normal: 0.3s ease;
  --transition-slow: 0.6s cubic-bezier(0.4, 0, 0.2, 1);
}

/* --- リセット --- */
*, *::before, *::after {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

html {
  scroll-behavior: smooth;
  scroll-padding-top: 80px;
}

body {
  font-family: var(--font-sans);
  background-color: var(--color-bg-primary);
  color: var(--color-text-primary);
  line-height: 1.8;
  -webkit-font-smoothing: antialiased;
  overflow-x: hidden;
}

a { color: inherit; text-decoration: none; }
ul, ol { list-style: none; }
img { max-width: 100%; display: block; }

/* --- コンテナ --- */
.container {
  width: 100%;
  max-width: var(--container-width);
  margin: 0 auto;
  padding: var(--container-padding);
}

/* --- セクション共通 --- */
.section { padding: var(--section-padding); position: relative; }

.section-label {
  font-family: var(--font-display);
  font-size: 0.85rem;
  font-weight: 600;
  letter-spacing: 3px;
  text-transform: uppercase;
  color: var(--color-accent-primary);
  margin-bottom: 12px;
  display: flex;
  align-items: center;
  gap: 12px;
}

.section-label::before {
  content: '';
  display: inline-block;
  width: 32px;
  height: 2px;
  background: var(--color-accent-gradient);
}

.section-title {
  font-family: var(--font-display);
  font-size: clamp(2rem, 4vw, 3rem);
  font-weight: 700;
  line-height: 1.3;
  margin-bottom: 20px;
}

.section-description {
  font-size: 1.05rem;
  line-height: 1.9;
  color: var(--color-text-secondary);
  max-width: 700px;
}

/* --- フェードインアニメーション --- */
.fade-in {
  opacity: 0;
  transform: translateY(40px);
  transition: opacity 0.8s cubic-bezier(0.4, 0, 0.2, 1),
              transform 0.8s cubic-bezier(0.4, 0, 0.2, 1);
}
.fade-in.is-visible { opacity: 1; transform: translateY(0); }
.fade-in-delay-1 { transition-delay: 0.1s; }
.fade-in-delay-2 { transition-delay: 0.2s; }
.fade-in-delay-3 { transition-delay: 0.3s; }
.fade-in-delay-4 { transition-delay: 0.4s; }

/* ==================================================
   ※ ここから先はセクションごとのスタイルを追加してください
   ※ ヘッダー、ヒーロー、カード、フォーム等
   ================================================== */

"@

# --- 出力 ---
$cssContent | Out-File -FilePath $OutputPath -Encoding UTF8
Write-Host "CSSテンプレート生成完了: $OutputPath"
Write-Host "  モード: $Mode"
Write-Host "  アクセントカラー: $AccentColor"
Write-Host "  フォント: $fontPrimaryClean / $fontDisplayClean"

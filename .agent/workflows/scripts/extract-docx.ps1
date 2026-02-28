<#
.SYNOPSIS
  docxファイルからテキストを抽出するPowerShellスクリプト

.DESCRIPTION
  .docx ファイルをZIPとして展開し、word/document.xml からテキスト要素を抽出します。
  抽出したテキストは段落ごとに改行区切りで出力されます。

.PARAMETER DocxPath
  読み取る .docx ファイルのパス（必須）

.PARAMETER OutputPath
  抽出テキストの保存先ファイルパス（省略時は標準出力）

.EXAMPLE
  .\extract-docx.ps1 -DocxPath "会社情報.docx"
  .\extract-docx.ps1 -DocxPath "会社情報.docx" -OutputPath "extracted.txt"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$DocxPath,

    [Parameter(Mandatory=$false)]
    [string]$OutputPath
)

# --- エラーハンドリング ---
$ErrorActionPreference = "Stop"

if (-not (Test-Path $DocxPath)) {
    Write-Error "ファイルが見つかりません: $DocxPath"
    exit 1
}

# --- 一時ディレクトリの作成 ---
$tempDir = Join-Path $env:TEMP ("docx_extract_" + [System.Guid]::NewGuid().ToString("N").Substring(0, 8))
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

try {
    # --- docx を ZIP として展開 ---
    $zipCopy = Join-Path $tempDir "temp.zip"
    Copy-Item $DocxPath $zipCopy
    $expandDir = Join-Path $tempDir "files"
    Expand-Archive $zipCopy -DestinationPath $expandDir -Force

    $xmlPath = Join-Path $expandDir "word\document.xml"
    if (-not (Test-Path $xmlPath)) {
        Write-Error "document.xml が見つかりません。有効な .docx ファイルか確認してください。"
        exit 1
    }

    # --- XML の読み取りとテキスト抽出 ---
    [xml]$xmlDoc = Get-Content $xmlPath -Raw -Encoding UTF8

    # 名前空間マネージャの設定
    $nsManager = New-Object System.Xml.XmlNamespaceManager($xmlDoc.NameTable)
    $nsManager.AddNamespace("w", "http://schemas.openxmlformats.org/wordprocessingml/2006/main")

    # 段落（w:p）ごとにテキストを抽出
    $paragraphs = $xmlDoc.SelectNodes("//w:p", $nsManager)
    $result = @()

    foreach ($para in $paragraphs) {
        $texts = $para.SelectNodes(".//w:t", $nsManager)
        $paraText = ""
        foreach ($t in $texts) {
            $paraText += $t.InnerText
        }
        if ($paraText.Trim() -ne "") {
            $result += $paraText
        }
    }

    $output = $result -join "`n"

    # --- 出力 ---
    if ($OutputPath) {
        $output | Out-File -FilePath $OutputPath -Encoding UTF8
        Write-Host "テキスト抽出完了: $OutputPath ($($result.Count) 段落)"
    } else {
        Write-Output $output
    }

} finally {
    # --- クリーンアップ ---
    if (Test-Path $tempDir) {
        Remove-Item $tempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

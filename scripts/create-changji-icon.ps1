$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$repoRoot = Split-Path $PSScriptRoot -Parent
$bitmap = New-Object System.Drawing.Bitmap 256,256
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$blue = New-Object System.Drawing.SolidBrush ([System.Drawing.ColorTranslator]::FromHtml('#1765d1'))
$light = New-Object System.Drawing.SolidBrush ([System.Drawing.ColorTranslator]::FromHtml('#70c5ff'))
$white = [System.Drawing.Brushes]::White
$graphics.FillRectangle($blue,0,0,256,256)
$graphics.FillRectangle($light,38,46,146,124)
$graphics.FillRectangle($white,70,83,148,125)
$pen = New-Object System.Drawing.Pen ([System.Drawing.ColorTranslator]::FromHtml('#1765d1')),10
$graphics.DrawLine($pen,70,117,218,117)
$graphics.FillEllipse($blue,84,95,10,10)
$graphics.FillEllipse($blue,101,95,10,10)
$pen.Width = 13
$graphics.DrawArc($pen,117,138,47,45,50,260)
$pngPath = Join-Path $repoRoot 'build-helpers/images/changji.png'
$bitmap.Save($pngPath,[System.Drawing.Imaging.ImageFormat]::Png)
$stream = New-Object System.IO.MemoryStream
$bitmap.Save($stream,[System.Drawing.Imaging.ImageFormat]::Png)
$bytes = $stream.ToArray()
$icoPath = Join-Path $repoRoot 'build-helpers/images/changji.ico'
$writer = New-Object System.IO.BinaryWriter ([System.IO.File]::Create($icoPath))
try {
  $writer.Write([uint16]0); $writer.Write([uint16]1); $writer.Write([uint16]1)
  $writer.Write([byte]0); $writer.Write([byte]0); $writer.Write([byte]0); $writer.Write([byte]0)
  $writer.Write([uint16]1); $writer.Write([uint16]32)
  $writer.Write([uint32]$bytes.Length); $writer.Write([uint32]22); $writer.Write($bytes)
} finally {
  $writer.Dispose(); $stream.Dispose(); $graphics.Dispose(); $bitmap.Dispose(); $blue.Dispose(); $light.Dispose(); $pen.Dispose()
}
Copy-Item -LiteralPath $icoPath -Destination (Join-Path $repoRoot 'src/assets/images/tray/win32/tray.ico') -Force
Copy-Item -LiteralPath $icoPath -Destination (Join-Path $repoRoot 'src/assets/images/taskbar/win32/display.ico') -Force
Write-Host 'Created Changji application icon'

# PowerShell script to generate AutoCAD DXF files for Grid Systems (Luoi truc CAD)

function Create-DxfGrid {
    param (
        [string]$FilePath,
        [string]$Title,
        [string[]]$VLabels,  # Labels for vertical axes (bottom-to-top lines, arranged left to right)
        [double[]]$VCoords,  # X positions
        [string[]]$HLabels,  # Labels for horizontal axes (left-to-right lines, arranged bottom to top)
        [double[]]$HCoords   # Y positions
    )

    $sb = New-Object System.Text.StringBuilder

    # Helper functions to append DXF groups
    function Add-Group([int]$code, [string]$val) {
        [void]$sb.AppendLine("$code")
        [void]$sb.AppendLine("$val")
    }

    # --- HEADER ---
    Add-Group 0 "SECTION"
    Add-Group 2 "HEADER"
    Add-Group 9 "`$ACADVER"
    Add-Group 1 "AC1009"        # AutoCAD R12 DXF - maximum compatibility
    Add-Group 9 "`$INSUNITS"
    Add-Group 70 "4"            # Millimeters
    Add-Group 9 "`$MEASUREMENT"
    Add-Group 70 "1"            # Metric
    Add-Group 9 "`$LTSCALE"
    Add-Group 40 "1.0"
    Add-Group 0 "ENDSEC"

    # --- TABLES ---
    Add-Group 0 "SECTION"
    Add-Group 2 "TABLES"

    # Linetypes
    Add-Group 0 "TABLE"
    Add-Group 2 "LTYPE"
    Add-Group 70 "2"
    
    Add-Group 0 "LTYPE"
    Add-Group 2 "CONTINUOUS"
    Add-Group 70 "64"
    Add-Group 3 "Solid line"
    Add-Group 72 "65"
    Add-Group 73 "0"
    Add-Group 40 "0.0"

    Add-Group 0 "LTYPE"
    Add-Group 2 "CENTER"
    Add-Group 70 "64"
    Add-Group 3 "Center ____ _ ____ _ ____"
    Add-Group 72 "65"
    Add-Group 73 "4"
    Add-Group 40 "800.0"
    Add-Group 49 "500.0"
    Add-Group 49 "-100.0"
    Add-Group 49 "100.0"
    Add-Group 49 "-100.0"

    Add-Group 0 "ENDTAB"

    # Layers
    Add-Group 0 "TABLE"
    Add-Group 2 "LAYER"
    Add-Group 70 "5"

    # Layer 0
    Add-Group 0 "LAYER"
    Add-Group 2 "0"
    Add-Group 70 "0"
    Add-Group 62 "7"
    Add-Group 6 "CONTINUOUS"

    # Layer TRUC (Center line - Red)
    Add-Group 0 "LAYER"
    Add-Group 2 "TRUC"
    Add-Group 70 "0"
    Add-Group 62 "1"           # Color 1: Red
    Add-Group 6 "CENTER"

    # Layer BONG_BONG (Circle head - Yellow)
    Add-Group 0 "LAYER"
    Add-Group 2 "BONG_BONG"
    Add-Group 70 "0"
    Add-Group 62 "2"           # Color 2: Yellow
    Add-Group 6 "CONTINUOUS"

    # Layer TEXT_TRUC (Text - Green)
    Add-Group 0 "LAYER"
    Add-Group 2 "TEXT_TRUC"
    Add-Group 70 "0"
    Add-Group 62 "3"           # Color 3: Green
    Add-Group 6 "CONTINUOUS"

    # Layer DIM (Dimensions - Cyan)
    Add-Group 0 "LAYER"
    Add-Group 2 "DIM"
    Add-Group 70 "0"
    Add-Group 62 "4"           # Color 4: Cyan
    Add-Group 6 "CONTINUOUS"

    Add-Group 0 "ENDTAB"

    # Text Styles
    Add-Group 0 "TABLE"
    Add-Group 2 "STYLE"
    Add-Group 70 "1"

    Add-Group 0 "STYLE"
    Add-Group 2 "STANDARD"
    Add-Group 70 "0"
    Add-Group 40 "0.0"
    Add-Group 41 "1.0"
    Add-Group 50 "0.0"
    Add-Group 71 "0"
    Add-Group 42 "300.0"
    Add-Group 3 "txt"
    Add-Group 4 ""

    Add-Group 0 "ENDTAB"
    Add-Group 0 "ENDSEC"

    # --- BLOCKS (empty) ---
    Add-Group 0 "SECTION"
    Add-Group 2 "BLOCKS"
    Add-Group 0 "ENDSEC"

    # --- ENTITIES ---
    Add-Group 0 "SECTION"
    Add-Group 2 "ENTITIES"

    # Entity helpers
    function Add-Line([string]$layer, [double]$x1, [double]$y1, [double]$x2, [double]$y2) {
        Add-Group 0 "LINE"
        Add-Group 8 $layer
        Add-Group 10 ([string]::Format([System.Globalization.CultureInfo]::InvariantCulture, "{0:F2}", $x1))
        Add-Group 20 ([string]::Format([System.Globalization.CultureInfo]::InvariantCulture, "{0:F2}", $y1))
        Add-Group 30 "0.0"
        Add-Group 11 ([string]::Format([System.Globalization.CultureInfo]::InvariantCulture, "{0:F2}", $x2))
        Add-Group 21 ([string]::Format([System.Globalization.CultureInfo]::InvariantCulture, "{0:F2}", $y2))
        Add-Group 31 "0.0"
    }

    function Add-Circle([string]$layer, [double]$cx, [double]$cy, [double]$radius) {
        Add-Group 0 "CIRCLE"
        Add-Group 8 $layer
        Add-Group 10 ([string]::Format([System.Globalization.CultureInfo]::InvariantCulture, "{0:F2}", $cx))
        Add-Group 20 ([string]::Format([System.Globalization.CultureInfo]::InvariantCulture, "{0:F2}", $cy))
        Add-Group 30 "0.0"
        Add-Group 40 ([string]::Format([System.Globalization.CultureInfo]::InvariantCulture, "{0:F2}", $radius))
    }

    function Add-Text([string]$layer, [double]$x, [double]$y, [double]$height, [string]$val, [double]$rot = 0.0, [int]$hJust = 1, [int]$vJust = 2) {
        Add-Group 0 "TEXT"
        Add-Group 8 $layer
        $xStr = [string]::Format([System.Globalization.CultureInfo]::InvariantCulture, "{0:F2}", $x)
        $yStr = [string]::Format([System.Globalization.CultureInfo]::InvariantCulture, "{0:F2}", $y)
        Add-Group 10 $xStr
        Add-Group 20 $yStr
        Add-Group 30 "0.0"
        Add-Group 40 ([string]::Format([System.Globalization.CultureInfo]::InvariantCulture, "{0:F2}", $height))
        Add-Group 1 $val
        Add-Group 7 "STANDARD"
        if ($rot -ne 0.0) {
            Add-Group 50 ([string]::Format([System.Globalization.CultureInfo]::InvariantCulture, "{0:F2}", $rot))
        }
        if ($hJust -ne 0 -or $vJust -ne 0) {
            Add-Group 72 "$hJust"
            Add-Group 11 $xStr
            Add-Group 21 $yStr
            Add-Group 31 "0.0"
            Add-Group 73 "$vJust"
        }
    }

    # Bounds
    $minX = $VCoords[0]
    $maxX = $VCoords[-1]
    $minY = $HCoords[0]
    $maxY = $HCoords[-1]

    $ext = 1200.0   # Grid line extension past intersection
    $bubbleR = 450.0 # Bubble circle radius
    $bubbleDist = $ext + $bubbleR  # Distance from intersection to bubble center
    $textH = 400.0

    # 1. DRAW VERTICAL AXIS LINES (Trục dọc)
    for ($i = 0; $i -lt $VCoords.Length; $i++) {
        $x = $VCoords[$i]
        $label = $VLabels[$i]

        $yStart = $minY - $ext
        $yEnd = $maxY + $ext
        # Grid line
        Add-Line "TRUC" $x $yStart $x $yEnd

        # Bottom bubble
        $byBottom = $minY - $bubbleDist
        Add-Circle "BONG_BONG" $x $byBottom $bubbleR
        Add-Text "TEXT_TRUC" $x $byBottom $textH $label 0.0 1 2

        # Top bubble
        $byTop = $maxY + $bubbleDist
        Add-Circle "BONG_BONG" $x $byTop $bubbleR
        Add-Text "TEXT_TRUC" $x $byTop $textH $label 0.0 1 2
    }

    # 2. DRAW HORIZONTAL AXIS LINES (Trục ngang)
    for ($j = 0; $j -lt $HCoords.Length; $j++) {
        $y = $HCoords[$j]
        $label = $HLabels[$j]

        $xStart = $minX - $ext
        $xEnd = $maxX + $ext
        # Grid line
        Add-Line "TRUC" $xStart $y $xEnd $y

        # Left bubble
        $bxLeft = $minX - $bubbleDist
        Add-Circle "BONG_BONG" $bxLeft $y $bubbleR
        Add-Text "TEXT_TRUC" $bxLeft $y $textH $label 0.0 1 2

        # Right bubble
        $bxRight = $maxX + $bubbleDist
        Add-Circle "BONG_BONG" $bxRight $y $bubbleR
        Add-Text "TEXT_TRUC" $bxRight $y $textH $label 0.0 1 2
    }

    # 3. DIMENSIONS (KÍCH THƯỚC TRỤC)
    $tickSize = 100.0
    function Add-DimTick([double]$x, [double]$y) {
        Add-Line "DIM" ($x - $tickSize) ($y - $tickSize) ($x + $tickSize) ($y + $tickSize)
    }

    # A. Bottom Dimensions (Kích thước nhịp dọc theo phương X)
    # Row 1: Bay dimensions (Từng nhịp)
    $dimY1 = $minY - 700.0
    Add-Line "DIM" $minX $dimY1 $maxX $dimY1
    for ($i = 0; $i -lt $VCoords.Length; $i++) {
        $x = $VCoords[$i]
        Add-DimTick $x $dimY1
        # Extension line
        Add-Line "DIM" $x ($minY - 200.0) $x ($dimY1 - 250.0)
    }
    for ($i = 0; $i -lt ($VCoords.Length - 1); $i++) {
        $span = $VCoords[$i+1] - $VCoords[$i]
        $midX = ($VCoords[$i] + $VCoords[$i+1]) / 2.0
        Add-Text "DIM" $midX ($dimY1 + 180.0) 250.0 "$([int]$span)" 0.0 1 1
    }

    # Row 2: Total dimension (Tổng chiều dài)
    $dimY2 = $minY - $bubbleDist - $bubbleR - 600.0
    Add-Line "DIM" $minX $dimY2 $maxX $dimY2
    Add-DimTick $minX $dimY2
    Add-DimTick $maxX $dimY2
    Add-Line "DIM" $minX ($dimY1 - 200.0) $minX ($dimY2 - 250.0)
    Add-Line "DIM" $maxX ($dimY1 - 200.0) $maxX ($dimY2 - 250.0)
    $totalSpanX = $maxX - $minX
    $midXTotal = ($minX + $maxX) / 2.0
    Add-Text "DIM" $midXTotal ($dimY2 + 180.0) 280.0 "$([int]$totalSpanX)" 0.0 1 1

    # B. Left Dimensions (Kích thước nhịp dọc theo phương Y)
    # Row 1: Bay dimensions (Từng nhịp)
    $dimX1 = $minX - 700.0
    Add-Line "DIM" $dimX1 $minY $dimX1 $maxY
    for ($j = 0; $j -lt $HCoords.Length; $j++) {
        $y = $HCoords[$j]
        Add-DimTick $dimX1 $y
        Add-Line "DIM" ($minX - 200.0) $y ($dimX1 - 250.0) $y
    }
    for ($j = 0; $j -lt ($HCoords.Length - 1); $j++) {
        $span = $HCoords[$j+1] - $HCoords[$j]
        $midY = ($HCoords[$j] + $HCoords[$j+1]) / 2.0
        # Rotated 90 deg text
        Add-Text "DIM" ($dimX1 - 180.0) $midY 250.0 "$([int]$span)" 90.0 1 1
    }

    # Row 2: Total dimension (Tổng chiều cao)
    $dimX2 = $minX - $bubbleDist - $bubbleR - 600.0
    Add-Line "DIM" $dimX2 $minY $dimX2 $maxY
    Add-DimTick $dimX2 $minY
    Add-DimTick $dimX2 $maxY
    Add-Line "DIM" ($dimX1 - 200.0) $minY ($dimX2 - 250.0) $minY
    Add-Line "DIM" ($dimX1 - 200.0) $maxY ($dimX2 - 250.0) $maxY
    $totalSpanY = $maxY - $minY
    $midYTotal = ($minY + $maxY) / 2.0
    Add-Text "DIM" ($dimX2 - 180.0) $midY 280.0 "$([int]$totalSpanY)" 90.0 1 1

    # 4. TITLE / BAN VE
    $titleY = $dimY2 - 1200.0
    Add-Text "TEXT_TRUC" $midXTotal $titleY 450.0 $Title 0.0 1 2
    Add-Line "TEXT_TRUC" ($midXTotal - 2200.0) ($titleY - 350.0) ($midXTotal + 2200.0) ($titleY - 350.0)
    Add-Text "DIM" $midXTotal ($titleY - 650.0) 250.0 "TY LE: 1/100" 0.0 1 2

    # --- ENDSEC & EOF ---
    Add-Group 0 "ENDSEC"
    Add-Group 0 "EOF"

    [System.IO.File]::WriteAllText($FilePath, $sb.ToString(), [System.Text.Encoding]::ASCII)
    Write-Host "Created DXF: $FilePath"
}

# 1. Option 1: Vertical 1, 2, 3 and Horizontal A, B, C (Standard Vietnamese Architectural Drawing)
Create-DxfGrid `
    -FilePath "c:\Users\huuki\Desktop\LV autocad\luoi_truc_123_ABC.dxf" `
    -Title "MAT BANG LUOI TRUC KET CAU (1-2-3 VA A-B-C)" `
    -VLabels @("1", "2", "3") `
    -VCoords @(0.0, 4000.0, 8500.0) `
    -HLabels @("A", "B", "C") `
    -HCoords @(0.0, 4000.0, 8000.0)

# 2. Option 2: Vertical A, B, C and Horizontal 1, 2, 3
Create-DxfGrid `
    -FilePath "c:\Users\huuki\Desktop\LV autocad\luoi_truc_ABC_123.dxf" `
    -Title "MAT BANG LUOI TRUC KET CAU (A-B-C VA 1-2-3)" `
    -VLabels @("A", "B", "C") `
    -VCoords @(0.0, 4000.0, 8500.0) `
    -HLabels @("1", "2", "3") `
    -HCoords @(0.0, 4000.0, 8000.0)

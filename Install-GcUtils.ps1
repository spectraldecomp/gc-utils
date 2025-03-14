# Install-geocachingUtils.ps1
#
# A PowerShell script to install geocaching-utils and set up the environment
#
# Usage:
#   1. Open PowerShell
#   2. Navigate to the geocaching-utils directory
#   3. Run: .\Install-geocachingUtils.ps1
#

[CmdletBinding()]
param (
    [switch]$InstallInVenv = $true,
    [switch]$DevelopmentMode = $true,
    [switch]$RunTests = $false
)

function Write-ColorOutput {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Message,
        [Parameter(Mandatory = $false)]
        [string]$ForegroundColor = "White"
    )
    
    $originalColor = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    Write-Output $Message
    $host.UI.RawUI.ForegroundColor = $originalColor
}

# Display header
Write-ColorOutput "====================================" "Cyan"
Write-ColorOutput "   geocaching-Utils Installation Script     " "Cyan"
Write-ColorOutput "====================================" "Cyan"
Write-ColorOutput "`n"

# Check if Python is installed
try {
    $pythonVersion = python --version
    Write-ColorOutput "Found Python: $pythonVersion" "Green"
} catch {
    Write-ColorOutput "Python not found. Please install Python 3.6 or newer." "Red"
    Write-ColorOutput "You can download Python from https://www.python.org/downloads/" "Yellow"
    exit 1
}

# Check if pip is installed
try {
    $pipVersion = python -m pip --version
    Write-ColorOutput "Found pip: $pipVersion" "Green"
} catch {
    Write-ColorOutput "pip not found. Installing pip..." "Yellow"
    try {
        Invoke-WebRequest -Uri https://bootstrap.pypa.io/get-pip.py -OutFile get-pip.py
        python get-pip.py
        Remove-Item get-pip.py
    } catch {
        Write-ColorOutput "Failed to install pip. Please install pip manually." "Red"
        exit 1
    }
}

# Set up virtual environment if requested
if ($InstallInVenv) {
    Write-ColorOutput "Setting up a virtual environment..." "Yellow"
    
    # Check if venv module is available
    python -c "import venv" 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-ColorOutput "venv module not available. Installing virtualenv..." "Yellow"
        python -m pip install virtualenv
        $venvCmd = "virtualenv"
        $venvArgs = @("venv")
    } else {
        $venvCmd = "python"
        $venvArgs = @("-m", "venv", "venv")
    }
    
    # Create virtual environment
    & $venvCmd $venvArgs
    if ($LASTEXITCODE -ne 0) {
        Write-ColorOutput "Failed to create virtual environment. Continuing with system Python..." "Red"
        $InstallInVenv = $false
    } else {
        Write-ColorOutput "Virtual environment created." "Green"
    }
    
    # Activate virtual environment
    if ($InstallInVenv) {
        Write-ColorOutput "Activating virtual environment..." "Yellow"
        & .\venv\Scripts\Activate.ps1
        if ($LASTEXITCODE -ne 0) {
            Write-ColorOutput "Failed to activate virtual environment. Continuing with system Python..." "Red"
            $InstallInVenv = $false
        } else {
            Write-ColorOutput "Virtual environment activated." "Green"
        }
    }
}

# Install geocaching-utils
Write-ColorOutput "Installing geocaching-utils..." "Yellow"
if ($DevelopmentMode) {
    python -m pip install -e .
} else {
    python -m pip install .
}

if ($LASTEXITCODE -ne 0) {
    Write-ColorOutput "Installation failed." "Red"
    exit 1
} else {
    Write-ColorOutput "geocaching-utils installed successfully!" "Green"
}

# Run tests if requested
if ($RunTests) {
    Write-ColorOutput "Running tests..." "Yellow"
    python -m pip install pytest
    python -m pytest tests/
    
    if ($LASTEXITCODE -ne 0) {
        Write-ColorOutput "Some tests failed." "Red"
    } else {
        Write-ColorOutput "All tests passed!" "Green"
    }
}

# Display usage information
Write-ColorOutput "`n" 
Write-ColorOutput "====================================" "Cyan"
Write-ColorOutput "        geocaching-Utils Quick Start        " "Cyan"
Write-ColorOutput "====================================" "Cyan"
Write-ColorOutput "`n"
Write-ColorOutput "Decode a cipher:" "White"
Write-ColorOutput "  geocaching-utils cipher --method caesar `"Uryyb, jbeyq!`"" "Gray"
Write-ColorOutput "`n"
Write-ColorOutput "Convert coordinates:" "White"
Write-ColorOutput "  geocaching-utils coords `"N 47° 36.123 W 122° 19.456`"" "Gray"
Write-ColorOutput "`n"
Write-ColorOutput "Calculate distance:" "White"
Write-ColorOutput "  geocaching-utils distance `"N 47° 36.123 W 122° 19.456`" `"N 40° 42.768 W 074° 00.360`"" "Gray"
Write-ColorOutput "`n"
Write-ColorOutput "Calculate geometry:" "White"
Write-ColorOutput "  geocaching-utils geometry circumcenter `"N 47° 36.123 W 122° 19.456`" `"N 46° 12.345 W 121° 54.321`" `"N 48° 30.456 W 123° 45.789`"" "Gray"
Write-ColorOutput "`n"
Write-ColorOutput "Use puzzle tools:" "White"
Write-ColorOutput "  geocaching-utils tools ascii-to-text `"72 101 108 108 111`"" "Gray"
Write-ColorOutput "`n"
Write-ColorOutput "For more information, run:" "White"
Write-ColorOutput "  geocaching-utils --help" "Gray"
Write-ColorOutput "  geocaching-utils <command> --help" "Gray"
Write-ColorOutput "`n"
Write-ColorOutput "Happy geocaching!" "Green" 
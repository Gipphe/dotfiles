[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

. "$Dirname\utils.ps1"
. "$Dirname\stamp.ps1"

Function Install-Wsl
{
  [CmdletBinding()]
  Param ()

  Register-Stamp "install-wsl" {
    Invoke-Native { wsl --install }
    Invoke-Native { wsl --install -d "Debian" }
  }

  Register-Stamp "configure-debian" {
    Invoke-Native {
      wsl -d "Debian" -- `
        ! test -s '$HOME/projects/git-config' `
        '&&' sudo apt update `
        '&&' sudo apt install -y git `
        '&&' git clone https://codeberg.org/Gipphe/git-config.git '$HOME/projects/git-config' `
        '&&' cd '$HOME/projects/git-config' `
        '&&' make
    }
  }

  Register-Stamp "configure-cuda-wsl" {
    $CudaDir = "$Env:SystemRoot\System32\lxss\lib"
    $LinkType = (Get-Item "$CudaDir\libcuda.so").LinkType
    if (-Not ($LinkType -eq "HardLink" -or $LinkType -eq "SymbolicLink"))
    {
      Remove-Item "$CudaDir\libcuda.so"
      Remove-Item "$CudaDir\libcuda.so.1"
      New-Item -ItemType SymbolicLink -Path "$CudaDir\libcuda.so.1.1" -Target "$CudaDir\libcuda.so"
      New-Item -ItemType SymbolicLink -Path "$CudaDir\libcuda.so.1.1" -Target "$CudaDir\libcuda.so.1"
      Invoke-Native { wsl -d 'Debian' -- sudo ldconfig }
    }
  }
}

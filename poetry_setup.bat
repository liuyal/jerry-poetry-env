set VER=3.14.5

cd %USERPROFILE%
rm -rf %USERPROFILE%/.pyenv
rm -rf %USERPROFILE%/.local
rm -rf %USERPROFILE%/pipx
rm -rf %USERPROFILE%/pyenv-win-master
rm -rf %USERPROFILE%/AppData/Local/pypoetry/*
rm -rf %USERPROFILE%/AppData/Local/pipx/*

curl -LO https://github.com/pyenv-win/pyenv-win/archive/master.zip --ssl-no-revoke
powershell -command "Expand-Archive -Path master.zip -DestinationPath ."
ren pyenv-win-master .pyenv
rm master.zip

setx PYENV %USERPROFILE%\.pyenv\pyenv-win\
setx PYENV_ROOT %USERPROFILE%\.pyenv\pyenv-win\
setx PYENV_HOME %USERPROFILE%\.pyenv\pyenv-win\

powershell -command "$p = [System.Environment]::GetEnvironmentVariable('path', 'User'); $add = $env:USERPROFILE + '\.pyenv\pyenv-win\bin'; if ($p -notlike '*' + $add + '*') { [System.Environment]::SetEnvironmentVariable('path', $add + ';' + $p, 'User') }"
powershell -command "$p = [System.Environment]::GetEnvironmentVariable('path', 'User'); $add = $env:USERPROFILE + '\.pyenv\pyenv-win\shims'; if ($p -notlike '*' + $add + '*') { [System.Environment]::SetEnvironmentVariable('path', $add + ';' + $p, 'User') }"
powershell -command "$p = [System.Environment]::GetEnvironmentVariable('path', 'User'); $add = $env:USERPROFILE + '\.local\bin'; if ($p -notlike '*' + $add + '*') { [System.Environment]::SetEnvironmentVariable('path', $add + ';' + $p, 'User') }"

call %USERPROFILE%\.pyenv\pyenv-win\bin\pyenv --version
call %USERPROFILE%\.pyenv\pyenv-win\bin\pyenv install %VER%
call %USERPROFILE%\.pyenv\pyenv-win\bin\pyenv global %VER%

call %USERPROFILE%\.pyenv\pyenv-win\versions\%VER%\python -m pip install --user pipx
call %USERPROFILE%\.pyenv\pyenv-win\versions\%VER%\python -m pipx install poetry --force

powershell -command "$currentPath = [System.Environment]::GetEnvironmentVariable('path', 'User'); $filtered = ($currentPath -split ';' | Where-Object { $_ -notlike ($env:USERPROFILE + '\.pyenv\pyenv-win\versions\*') }) -join ';'; [System.Environment]::SetEnvironmentVariable('path', $filtered, 'User')"

set python_path=%USERPROFILE%\.pyenv\pyenv-win\versions\%VER%;
powershell -command "$p = [System.Environment]::GetEnvironmentVariable('path', 'User'); $add = $env:python_path.TrimEnd(';'); if ($p -notlike '*' + $add + '*') { [System.Environment]::SetEnvironmentVariable('path', $add + ';' + $p, 'User') }"

python --version
poetry --version

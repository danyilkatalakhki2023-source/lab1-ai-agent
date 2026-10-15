@echo off
setlocal
set "ROOT=%~dp0"
set "PYTHON=%ROOT%.venv\Scripts\python.exe"
set "EXE=%ROOT%dist\hello.exe"

cd /d "%ROOT%"
if errorlevel 1 (
    echo ERROR: failed to change to project root "%ROOT%".
    exit /b 1
)

if not exist "%ROOT%src\__init__.py" (
    echo ERROR: project root validation failed: src\__init__.py is missing.
    exit /b 1
)

if exist "%ROOT%.venv\" (
    if not exist "%PYTHON%" (
        echo ERROR: existing .venv Python interpreter is missing or not runnable; it was not deleted.
        exit /b 1
    )
) else (
    where python >nul 2>&1
    if errorlevel 1 (
        echo ERROR: system Python 3.13 is required to create .venv.
        exit /b 1
    )
    python --version 2>&1 | findstr /r /c:"Python 3\.13" >nul
    if errorlevel 1 (
        echo ERROR: system Python 3.13 is required to create .venv.
        exit /b 1
    )
    python -m venv .venv
    if errorlevel 1 (
        echo ERROR: failed to create .venv with system Python 3.13.
        exit /b 1
    )
)

"%PYTHON%" --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: .venv Python interpreter is not runnable.
    exit /b 1
)
"%PYTHON%" --version 2>&1 | findstr /r /c:"Python 3\.13" >nul
if errorlevel 1 (
    echo ERROR: existing .venv interpreter is not Python 3.13; it was not deleted.
    exit /b 1
)

"%PYTHON%" -m pip install -r "%ROOT%requirements-dev.txt"
if errorlevel 1 exit /b 1

"%PYTHON%" -m pytest "%ROOT%tests"
if errorlevel 1 (
    exit /b 1
)

"%PYTHON%" -m PyInstaller --onefile --name hello --distpath dist --workpath build/pyinstaller --specpath build src/hello.py
if errorlevel 1 exit /b 1

if not exist "%EXE%" (
    echo ERROR: expected executable was not created.
    exit /b 1
)

"%PYTHON%" -c "import subprocess, sys; p = subprocess.run([sys.argv[1]], capture_output=True, text=True); expected = ('Hello World', 'Hello World\n'); print('Executable return code:', p.returncode); print('Executable stdout:', repr(p.stdout)); sys.exit(0 if p.returncode == 0 and p.stdout in expected else 1)" "%EXE%"
if errorlevel 1 (
    echo ERROR: hello.exe did not return code 0 with stdout equal to Hello World.
    exit /b 1
)

echo Build and test succeeded.
exit /b 0

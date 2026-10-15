# Project Guidelines

## Architecture

This repository defines a staged Copilot workflow for generating and checking
a cross-platform Python 3.13 Hello World project. The project-specific agent
is [build-engineer](./agents/build-engineer.agent.md); prompts are the
stage entry points, and skills contain the detailed implementation rules.

Run stages in this order:

`git-init` -> `create-project` -> `create-build` -> `create-actions` -> `check`

The generated application is intentionally separate from the current
instruction scaffold:

- `create-project` creates `src/__init__.py` and `src/hello.py`, with
  `python -m src.hello` as the module entry point.
- `create-build` adds `add(a, b)`, `tests/test_hello.py`, the development
  dependencies, and the root `ci.bat`/`ci.sh` scripts.
- `create-actions` adds one matrix workflow for Ubuntu, Windows, and macOS.
  The workflow delegates build/test work to the platform-specific scripts and
  uploads the resulting executable.

Read the stage prompt and its assigned skill before executing a stage. The
orchestrator stops at the first failed stage, and `check` is read-only with
respect to source, configuration, and documentation.

## Build and Test

The generated project uses the `.venv` interpreter for all dependency,
test, and packaging operations; do not require activation of the environment.
The documented local entry points are:

```text
python -m src.hello
python -m pytest
python -m pytest tests/test_hello.py
python -m pytest tests/test_hello.py -k test_BasicAddition
ci.bat                 # Windows
bash ci.sh             # Linux/macOS
```

`ci.bat` and `ci.sh` are expected to install `requirements-dev.txt`, run
pytest, build with PyInstaller, and execute the resulting `Hello World`
binary. The required PyInstaller invocation is:

```text
python -m PyInstaller --onefile --name hello --distpath dist --workpath build/pyinstaller --specpath build src/hello.py
```

Expected outputs are `dist/hello.exe` on Windows and `dist/hello` on
Linux/macOS. Build outputs, `.venv`, and test caches are ignored and must not
be committed. No lint command is currently defined.

## Conventions

- Preserve the existing README identity data (ПІБ `Каталах Д.Б.` and group
  `КІ-408`) and documentation links when editing project files.
- Keep the exact public test name `test_BasicAddition` and import `add` from
  `src.hello`.
- Build scripts must determine the repository root from their own location,
  fail on the first error, and use the platform's `.venv` Python executable.
- Keep PyInstaller's spec file under `build/` and its work directory under
  `build/pyinstaller`; do not introduce a second packaging configuration.
- The workflow must use one job with a matrix containing
  `ubuntu-latest`, `windows-latest`, and `macos-latest`; it must call
  `ci.bat` through `cmd` on Windows and `ci.sh` through `bash` elsewhere.
  Do not duplicate dependency installation, pytest, or PyInstaller steps in
  the workflow.
- Workflow YAML validation must use `yaml.BaseLoader` so the `on` key remains
  a string.
- Keep local verification results separate from GitHub Actions results. Never
  claim another operating system or CI run was verified without factual
  evidence.
- Preserve existing files and user changes on reruns. Do not delete files,
  force-rewrite Git history, commit or push without an explicit request, or
  use secrets.

See [architecture.md](../docs/architecture.md), [usage.md](../docs/usage.md),
and the relevant files under [prompts](./prompts/) and [skills](./skills/) for
the authoritative stage-specific requirements.

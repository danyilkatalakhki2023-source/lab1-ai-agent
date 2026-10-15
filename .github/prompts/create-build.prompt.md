---
name: create-build
description: "Створити тестування, локальні скрипти та PyInstaller-пакування Python-проєкту."
agent: build-engineer
---

# Команда `create-build`

## Передумови та вхідні дані

Перед виконанням прочитай цей prompt і
[skill build-and-test](../skills/build-and-test/SKILL.md). Потрібні корінь
репозиторію, Python 3.13 і робочі `src/__init__.py` та `src/hello.py` з
Hello World.

## Дії

1. Застосуй вимоги [skill build-and-test](../skills/build-and-test/SKILL.md).
2. Додай `add(a, b)` до `src/hello.py`, зберігши запуск Hello World.
3. Створи `tests/test_hello.py` із `test_BasicAddition`, який імпортує саме
   `add` із `src.hello`.
4. Створи `requirements-dev.txt` із `pytest`, `PyInstaller` і `PyYAML`.
5. Створи кореневі `ci.bat` і `ci.sh`.
6. На поточній ОС запусти відповідний скрипт, перевір код завершення,
   проходження тесту, пакування та запуск створеного файла.

## Очікувані результати та перевірка

Очікуються `tests/test_hello.py`, `requirements-dev.txt`, `ci.bat`, `ci.sh`,
оновлений `src/hello.py`, виконуваний файл у `dist/` і spec-файл у `build/`.
Перевіряй через відповідний скрипт: `ci.bat` на Windows або `bash ci.sh` на
Linux/macOS. Не заявляй про перевірку іншої ОС.

## Помилки

При помилці середовища, залежностей, pytest, PyInstaller, виконуваного файла
або його виводу повідом етап і причину, поверни ненульовий результат та
зупини оркестрацію. Не приховуй помилку повторними спробами.

## Повторний запуск

Використовуй працездатний `.venv` Python 3.13, не видаляй невідповідне
середовище автоматично, не дублюй тест чи конфігурацію та не видаляй файли
користувача. `build/` і `dist/` не комітяться.

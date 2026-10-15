---
name: create-project
description: "Створити початковий Python-проєкт Hello World за інструкцією project-scaffold."
agent: build-engineer
---

# Команда `create-project`

## Передумови та вхідні дані

Перед виконанням прочитай цей prompt і
[skill project-scaffold](../skills/project-scaffold/SKILL.md). Переконайся, що
визначено корінь репозиторію, назву проєкту та мову Python 3.13, а також
перевірено README і `.gitignore`.

## Дії

1. Застосуй усі вимоги [skill project-scaffold](../skills/project-scaffold/SKILL.md).
2. Створи `src/__init__.py` та `src/hello.py` з `main()` і захистом
   `if __name__ == "__main__":`.
3. Збережи наявні ПІБ, групу та посилання README.
4. Не створюй тести, requirements, скрипти складання або workflow.

## Очікувані результати та перевірка

Очікуються `src/__init__.py`, `src/hello.py` і лише необхідні доповнення до
README та `.gitignore`. Із кореня репозиторію виконай `python -m src.hello` і
перевір, що стандартний вивід дорівнює `Hello World`. Цей етап не вимагає
pytest або CI.

## Помилки

Якщо skill відсутній, файл конфліктує, запуск має помилку або вивід
відрізняється, повідом причину, не заявляй про успіх і зупини наступні етапи.

## Повторний запуск

Зберігай коректні файли й зміни користувача, не дублюй README або
`.gitignore`, не перезаписуй несумісний вміст і не видаляй файли.

---
name: create-actions
description: "Створити кросплатформний GitHub Actions workflow для готових скриптів."
agent: build-engineer
---

# Команда `create-actions`

## Передумови та вхідні дані

Перед виконанням прочитай цей prompt і
[skill github-actions](../skills/github-actions/SKILL.md). Перевір наявність
кореневих `ci.bat` і `ci.sh`, готової програми та правил `.gitignore`.

## Дії

1. Застосуй вимоги [skill github-actions](../skills/github-actions/SKILL.md).
2. Створи `.github/workflows/ci.yml` з однією job і matrix для
   `ubuntu-latest`, `windows-latest`, `macos-latest`.
3. Додай checkout і Python 3.13.
4. Викликай `ci.bat` через `cmd` на Windows та `ci.sh` через `bash` на
   Linux/macOS.
5. Додай перевірку виконуваного файла й окреме завантаження артефакту для
   кожної ОС.
6. Не дублюй у workflow встановлення залежностей, pytest або PyInstaller.

## Очікувані результати та перевірка

Очікується `.github/workflows/ci.yml` із тригерами `push` для `develop`,
`master`, `feature/**` і `pull_request` для `develop`, `master`. Перевір
YAML-синтаксис, структуру matrix, виклики скриптів і шляхи `dist/hello.exe`
та `dist/hello`. Перевірка конфігурації не є фактичним запуском GitHub Actions.

## Помилки

При відсутньому skill, помилці YAML, скрипті або шляху виконуваного файла
повідом точну причину й зупинися. Не публікуй відсутній артефакт і не заявляй
про успіх GitHub Actions без фактичного запуску.

## Повторний запуск

Зберігай інші workflow та зміни користувача, не дублюй job, steps, triggers чи
artifact-назви та не коміть `dist/`.

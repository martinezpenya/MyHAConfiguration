# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

This is a personal **Home Assistant** configuration directory (not an application codebase). It is bind-mounted into a running `homeassistant/home-assistant` Docker container named `ha` (host path `/docker/ha` → container path `/config`). Editing YAML/Python here directly changes the live smart-home installation on the next reload/restart.

## Commands

There is no build step, package manager, or test suite. The relevant operations are all done through the running container:

```bash
# Validate configuration without restarting (fails fast on YAML/schema errors)
docker exec ha python -m homeassistant --script check_config --config /config

# Reload after editing YAML (pick a domain-specific reload when possible instead of a full restart)
docker exec ha ha automation reload      # if the `ha` CLI is available in the container
docker restart ha                        # full restart, needed for custom_components / core config changes

# Tail logs while debugging
tail -f /docker/ha/home-assistant.log
docker logs -f ha
```

When editing a single automation/script/sensor file, prefer Home Assistant's targeted reload (Developer Tools → YAML in the UI, or the corresponding `homeassistant.reload_config_entry` / `automation.reload` service) over a full container restart — it's faster and won't drop other in-memory state.

Always run `check_config` before assuming a YAML edit is valid — Home Assistant's `!include*` directives make it easy to introduce a syntax error in one file that only surfaces at load time.

## Architecture: how configuration.yaml wires everything together

`configuration.yaml` is the entry point and almost entirely composed of `!include` / `!include_dir_*` directives that pull in the real content from sibling directories/files. To understand or change any given piece of behavior, find the relevant include in `configuration.yaml` first, then edit the target file(s) — don't expect logic to live inline in `configuration.yaml` itself.

Key include mappings (see `configuration.yaml` for the authoritative list):

- `packages: !include_dir_named packages` — the primary extension mechanism for grouping a device/integration's `sensor:`/`switch:`/`command_line:`/etc. keys into one self-contained file (e.g. `packages/gasolina_command_line.yaml`, `packages/switch/*.yaml`, `packages/camera/*.yaml`). Prefer adding new integrations as a package rather than editing top-level domain files.
- `automation: !include_dir_merge_list automations` — every `.yaml` file under `automations/` is merged into one automation list. Naming convention is `<Device/Area>_<Trigger>_<Action>.yaml` (e.g. `Door_Sensor_Front_Battery_off.yaml`, `ESPHome2_Led_on_PIR.yaml`).
- `automations/InteractiveMenu/` — a Telegram-bot-driven inline-keyboard menu system. `TCB_*` / `TC_*` files are menu screens; `.btn` files (e.g. `TCB_start_menu_buttons.btn`) define the `inline_keyboard` layout referenced via `!include` from the matching menu automation. Emoji in Telegram messages are written as `\UXXXXXXXX` escapes — see `documentation/interactive_menu_tips.txt` for the conversion tools; a wrong escape has broken automations before (see git history).
- `sensor: !include_dir_merge_list sensors`, `template: !include_dir_merge_list templates` — template and platform sensors.
- `switch: !include_dir_merge_list switches` — mostly MQTT/Tasmota switches, plus `mqtt.switch: !include_dir_merge_list switches` also folds in via the MQTT platform block.
- `group: !include_dir_named groups`, `notify: !include_dir_merge_list notify`.
- `mqtt:` block inlines `covers/covers.yaml`, `binary_sensors.yaml`, and `!include_dir_merge_list switches` for MQTT-specific entities (mostly Tasmota-flashed Sonoff/BlitzWolf devices).
- `script: !include scripts.yaml`, `device_tracker: !include device_tracker.yaml`, and single-purpose top-level files: `customize.yaml`, `input_boolean.yaml`, `input_number.yaml`, `input_select.yaml`, `input_text.yaml`, `timer.yaml`, `utility_meter.yaml`.
- `config/alexa.yaml` — Alexa Smart Home (haaska) entity exposure config.
- `blueprints/{automation,script,template}/` — reusable HA blueprints.
- `custom_components/` — third-party integrations installed manually or via HACS (e.g. `smartir`, `xiaomi_miot`, `xiaomi_cloud_map_extractor`, `alexa_media`, `garmin_connect`, `mopidy`, `webrtc`, `hacs` itself). Treat these as vendored dependencies, not first-party code — avoid modifying them except for upstream-tracked bugfixes.

## Secrets

All credentials, hostnames, tokens, and coordinates are referenced via `!secret <name>` and live in `secrets.yaml`, which is **gitignored and never committed**. When adding a new integration that needs a credential/host/IP, add the key to `secrets.yaml` (not committed) and reference it with `!secret` in the tracked YAML — never hardcode a real secret value in a tracked file. `secretsRENAME.yaml` is a template/reference of expected keys, not a live file.

## Other gitignored/runtime paths

`.storage/`, `home-assistant_v2.db*`, `home-assistant.log*`, `known_devices*.yaml`, `tts/`, `.cache/`, `.cloud/`, `backups/`, and `.HA_VERSION` are runtime state generated by Home Assistant itself — don't hand-edit or commit these; they regenerate on restart.

## Conventions observed in this repo

- One automation per file under `automations/`, named descriptively after the device/area and trigger/action rather than grouped by domain.
- Device-specific entities (a single Tasmota switch, an ESPHome node, a camera) are grouped into one file per device under `packages/<domain>/` or `switches/`/`sensors/` rather than appended to a shared file.
- `documentation/*.md` holds setup notes for physical hardware (ESPHome flashing, Tasmota OTA, Broadlink RM mini3, door sensors, SSL/Let's Encrypt, Pi-hole) — consult these before re-deriving hardware setup steps from scratch.

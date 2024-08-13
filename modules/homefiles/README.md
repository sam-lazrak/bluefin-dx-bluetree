# `homefiles`

This module, instead of using external repositories, uses something like `config/homefiles/common` in your bluebuild repo.

`config/homefiles/common` would be a chezmoi source (initialised by `chezmoi init`, for example).

## Example

```yaml
type: homefiles
add:
  - common
disable-service: false # default: false, the systemd service is disabled by default
```

## What does the module do?

Step 1.
  - Copy systemd service, `.path` systemd file, and script used by the service. This service is a user service and just does a `chezmoi apply` (with some arguments)
Step 2.
  - If `disable-service: true` then disable the service by default, otherwise enable
Step 3.
  - Copy all entries listed into /usr/share/bluebuild/homefiles/$entry
Step 4.
  - Applies this entry to destination at `/etc/skel`

## Systemd Service - How does it work?

- This service runs at login, and whenever `/usr/share/bluebuild/homefiles/` changes

### What does the script do?

- The service runs `chezmoi apply` for every entry.
- I use `yes "skip" | chezmoi apply ...` to automatically skip any files in the user's home directory that are different from the source.
- state file is set to `~/.local/state/bluebuild/homefiles/($entry_name)/chezmoi-state`
- `--no-tty --keep-going` is also tacked on, idk what it does but someone else used it so I did.
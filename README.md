# MiniPi

Personal pi extensions and agent configuration repository.

## Install package

```bash
pi install git:github.com/koko-t7i/MiniPi
```

If pi is already running, reload resources:

```text
/reload
```

## Extensions

- **status-footer** — compact one-line status bar (model · cwd · branch · context · progress). Run `/bar` to configure segments.
- **cliproxy** — registers a `cliproxy` provider for [CLIProxyAPI](https://github.com/router-for-me/CLIProxyAPI) (e.g. `cliproxy/gpt-5.5`). Reads its token from `/redacted/token` and mirrors the Codex CLI request headers. Override defaults with `CLIPROXY_API_KEY`, `CLIPROXY_BASE_URL`, `CLIPROXY_USER_AGENT`, or `CLIPROXY_ORIGINATOR`.

## One-key agent config

Clone this repo, then run:

```bash
bash install.sh
```

The installer backs up existing pi settings, merges recommended packages, and writes default local config files.

Then run:

```bash
pi update --extensions
```

Restart pi, or run `/reload` inside pi.

## Security

MiniPi is intended for personal setup sync. Review code before installing because pi extensions run with local user permissions.

MiniPi does **not** include or manage:

- auth files
- API keys or tokens
- session history
- private SSH keys
- local `.env` files

MiniPi reads the CLIProxyAPI token from `/redacted/token` (or `CLIPROXY_API_KEY` if set) at request time; it does not store or generate CLIProxyAPI credentials.

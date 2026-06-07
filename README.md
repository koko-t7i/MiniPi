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

## CLIProxy provider

MiniPi registers a Pi provider named `cliproxy` for [CLIProxyAPI](https://github.com/router-for-me/CLIProxyAPI). It uses the OpenAI Responses-compatible endpoint at `https://redacted.example/v1` by default and exposes Codex models through CLIProxyAPI.

By default the provider reads its API key by running `cat /redacted/token` at request time (Pi's `!command` API-key form). No extra setup is needed if that token file exists.

1. Select a model in Pi, for example:

```text
/model cliproxy/gpt-5.4-mini
```

Available static model entries:

- `cliproxy/gpt-5.3-codex-spark`
- `cliproxy/gpt-5.4`
- `cliproxy/gpt-5.4-mini`
- `cliproxy/gpt-5.5`

To override the defaults, set either environment variable:

```bash
export CLIPROXY_API_KEY="your-cli-proxy-api-key"    # overrides the token-file lookup
export CLIPROXY_BASE_URL="http://localhost:8317/v1" # overrides the default endpoint
export CLIPROXY_USER_AGENT="codex_cli_rs/0.20.0"    # overrides the request User-Agent
```

The provider sends a Codex-style `User-Agent` because the gateway's WAF rejects the
OpenAI SDK's default `OpenAI/JS …` agent with `403 Your request was blocked.`

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

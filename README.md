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

## CLIProxy Codex provider

MiniPi registers a Pi provider named `cliproxy-codex` for [CLIProxyAPI](https://github.com/router-for-me/CLIProxyAPI). It uses the OpenAI Responses-compatible endpoint at `http://localhost:8317/v1` by default and exposes Codex models through CLIProxyAPI.

1. Start CLIProxyAPI and configure an `api-keys` value in its config.
2. Export the same key for Pi:

```bash
export CLIPROXY_API_KEY="your-cli-proxy-api-key"
```

3. Select a model in Pi, for example:

```text
/model cliproxy-codex/gpt-5.4-mini
```

Available static model entries:

- `cliproxy-codex/gpt-5.3-codex-spark`
- `cliproxy-codex/gpt-5.4`
- `cliproxy-codex/gpt-5.4-mini`
- `cliproxy-codex/gpt-5.5`

Use `CLIPROXY_BASE_URL` to override the default endpoint:

```bash
export CLIPROXY_BASE_URL="http://localhost:8317/v1"
```

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

MiniPi only references `CLIPROXY_API_KEY`; it does not store or generate CLIProxyAPI credentials.

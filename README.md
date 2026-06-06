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

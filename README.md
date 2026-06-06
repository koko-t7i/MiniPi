# MiniPi

Personal pi package and bootstrap config for my agent setup.

## What it installs

MiniPi exposes one pi extension:

- `extensions/status-footer.ts` — compact `pi-bar` footer/statusline.

Default footer shape:

```text
gpt-5.5 xhigh · ~/rpc-gateway · test · 4.1% / 272k · xxxxx
```

Segments:

1. model + thinking level
2. current working directory (`~` shortened)
3. git branch
4. context usage
5. live progress text
6. extension statuses

## Direct install

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

The installer:

- checks that `pi` and `node` exist
- backs up `~/.pi/agent/settings.json`
- merges recommended packages from `config/settings.packages.json`
- removes `npm:pi-bar`
- adds `git:github.com/koko-t7i/MiniPi`
- writes `~/.pi/agent/pi-bar.json` from `config/pi-bar.json`

Then run:

```bash
pi update --extensions
```

Restart pi, or run `/reload` inside pi.

## Configure footer

Inside pi:

```text
/bar
```

Useful commands:

```text
/bar segments list
/bar segments only model cwd branch context progress extensions
/bar segments hide progress
/bar status
```

Choices persist in:

```text
~/.pi/agent/pi-bar.json
```

## Files

```text
.
├── config/
│   ├── pi-bar.json
│   └── settings.packages.json
├── extensions/
│   └── status-footer.ts
├── install.sh
├── package.json
└── README.md
```

## Security

Pi packages run with your local user permissions. Review extension code before installing.

MiniPi does **not** include or manage:

- `~/.pi/agent/auth.json`
- API keys or tokens
- session history
- private SSH keys
- local `.env` files

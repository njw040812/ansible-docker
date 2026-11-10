# Example: production-oriented Docker host

This directory is a small wrapper around the `ansible-docker` role. It is not a
replacement for the role; it shows a repeatable way to configure a cloud server.

What it configures:

- Docker Engine + Compose v2
- `json-file` logging with `max-size=100m` / `max-file=3`
- `live-restore` so containers keep running during a daemon restart
- weekly cleanup of unused images older than 7 days
- a verification script for `docker info`, `daemon.json`, logging driver and cron

## Usage

```bash
# 1. Install the role from this fork
ansible-galaxy install -r requirements.yml

# 2. Copy the inventory and edit host/user/key
cp inventory.example inventory

# 3. Syntax check and dry run
ansible-playbook -i inventory site.yml --syntax-check
ansible-playbook -i inventory site.yml --check --diff

# 4. Apply
ansible-playbook -i inventory site.yml

# 5. Verify on the host
scp verify-docker-host.sh ubuntu@<host>:/tmp/
ssh ubuntu@<host> "chmod +x /tmp/verify-docker-host.sh && /tmp/verify-docker-host.sh"
```

## Variables

`group_vars/docker_hosts.yml` sets:

| Variable | Purpose |
|----------|---------|
| `docker__users` | users allowed to run Docker without sudo |
| `docker__default_daemon_json` | log driver, rotation, live-restore, buildkit |
| `docker__cron_jobs` | weekly `docker image prune` with a 7-day filter |

Keep `docker__default_daemon_json` valid JSON fragments: the role wraps it in
`/etc/docker/daemon.json`.

## Why this example

The upstream role already supports every option used here. The value of this
directory is the **opinionated defaults + verification**: log rotation prevents
`/var/lib/docker` from filling the disk, `live-restore` reduces restart impact,
and the cleanup job keeps image layers bounded.

Upstream role: https://github.com/nickjj/ansible-docker (MIT).

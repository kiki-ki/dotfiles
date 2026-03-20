#!/usr/bin/env python3
import json, sys, subprocess, os

R = '\033[0m'
DIM = '\033[2m'
CYAN = '\033[36m'
GREEN = '\033[32m'
YELLOW = '\033[33m'
MAGENTA = '\033[95m'
RINGS = ['○', '◔', '◑', '◕', '●']
SEP = f' {DIM}|{R} '


def gradient(pct):
  if pct < 50:
    return f'\033[38;2;{int(pct * 5.1)};200;80m'
  return f'\033[38;2;255;{max(int(200 - (pct - 50) * 4), 0)};60m'


def ring(label, pct):
  return f'{label} {gradient(pct)}{RINGS[min(int(pct / 25), 4)]} {round(pct)}%{R}'


def run(cmd):
  return subprocess.check_output(cmd, text=True, stderr=subprocess.DEVNULL).strip()


def git_info():
  try:
    run(['git', 'rev-parse', '--git-dir'])
  except (subprocess.CalledProcessError, FileNotFoundError):
    return ''
  branch = run(['git', 'branch', '--show-current'])
  staged = run(['git', 'diff', '--cached', '--numstat'])
  modified = run(['git', 'diff', '--numstat'])
  status = ''
  if staged:
    status += f'{GREEN}+{len(staged.splitlines())}{R}'
  if modified:
    status += f'{YELLOW}~{len(modified.splitlines())}{R}'
  return f'#{branch}{R} {status}'


def fmt_duration(ms):
  s = ms // 1000
  d, s = divmod(s, 86400)
  h, s = divmod(s, 3600)
  m, s = divmod(s, 60)
  if d:
    return f'{d}d{h}h'
  if h:
    return f'{h}h{m}m'
  return f'{m}m{s}s'


data = json.load(sys.stdin)


def val(*keys):
  d = data
  for k in keys:
    d = d.get(k, {}) if isinstance(d, dict) else {}
  return d or 0


model = val('model', 'display_name') or 'Claude'
directory = os.path.basename(val('workspace', 'current_dir') or '')

print(SEP.join([
  f'{MAGENTA}{model}{R}',
  f'{CYAN}{directory}{git_info()}{R}',
  fmt_duration(int(val('cost', 'total_duration_ms'))),
]))

metrics = [ring('ctx', val('context_window', 'used_percentage'))]
for key, label in [('five_hour', '5h'), ('seven_day', '7d')]:
  pct = val('rate_limits', key, 'used_percentage')
  if pct:
    metrics.append(ring(label, pct))
metrics.append(f'${val("cost", "total_cost_usd"):.2f}')

print(SEP.join(metrics))

# action_gate

**One capability bit from GBT V8, packaged standalone.** No. 241 of 341,
`system` domain (System).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> 先看→动脑→执行 前置闸（主人令「做事拥有先看在动脑执行，拒绝所有的无脑操作以及盲猜」）：**没证据不许动手**（evidence 必须真在盘上）· **证据要新**（默认 ≤600s，旧读数不许当现状）· **必须写预期**（hypothesis ≥8 字，否则算盲猜）· **写/执行要票**（scope 或 owner 类许可）。过了发 gate_id，做完 `close` 回填结果+**亲眼看到的**（saw 不许空）。台账 state/action_gate.jsonl。op=observe/preflight/close/status/verify/where

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-action-gate.git
cd gbt-action-gate
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_action_gate info                  # capability card
python -m gbt_action_gate spec --json           # machine-readable contract
python -m gbt_action_gate check --payload '{}'
python -m gbt_action_gate run   --payload '{}'
```

Real `info` output from this machine:

```text
action_gate  (system)  v1.0.0
----------------------------------------
先看→动脑→执行 前置闸（主人令「做事拥有先看在动脑执行，拒绝所有的无脑操作以及盲猜」）：**没证据不许动手**（evidence 必须真在盘上）· **证据要新**（默认 ≤600s，旧读数不许当现状）· **必须写预期**（hypothesis ≥8 字，否则算盲猜）· **写/执行要票**（scope 或 owner 类许可）。过了发 gate_id，做完 `close` 回填结果+**亲眼看到的**（saw 不许空）。台账 state/action_gate.jsonl。op=observe/preflight/close/status/verify/where

gated      : False
external   : False
multi-op   : True
params     : (none)
values     : observe, preflight, close, status, verify, where
```

Wire a real implementation:

```python
from gbt_action_gate import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表登记的取值 / 子动作（6 个）**：`observe`、`preflight`、`close`、`status`、`verify`、`where`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Not gated: the registry marks this bit `safe: true`.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.15s
```

## Provenance

| field | value |
|---|---|
| capability | `action_gate` |
| domain | `system` |
| handler | `action_gate` |
| safe | `True` (gated = `False`) |
| external | `False` |
| atlas page | [system/action_gate](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/system/action_gate.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.

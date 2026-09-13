# mezze-python

Python interop for [Mezze](https://mezze-lang.org) — packaged as an
external `mez` dependency (polyglot-as-a-package pilot).

## Install

```toml
# your Mezze.toml

[dependencies]
mezze_python = "github:mezze-lang/mezze-python@0.1.1"

[polyglot.python]
packages = ["numpy>=1.24.0"]
```

Then `mez sync` and you can:

```mezze
use mezze_python::python::{ Python, GraalPy, PyForeign }

pub let main = {} -> perform GraalPy in do
  let np    = Python.import { module = "numpy" }
  let arr_r = match np is
    Ok { val = np } -> np.method { name = "array", args = [] }
    Err { error } -> Err { error }
  ...
```

## What ships

- `src/python.mz` — `effect Python`, `impl Python for GraalPy`,
  inherent methods on `PyForeign` (Python-idiomatic + universal
  InteropLibrary vocabulary), language-tagged constructors.
- `src/codec.mz` — `PythonC` codec + tier-4 `ToPy` / `FromPy` sugar.
- `jars/polyglot-python-natives-0.1.0.jar` — the SPI-loaded native
  handler pack that registers `__native_python_eval` /
  `__native_python_import_module` against the interpreter's
  `NativeDispatch` table.
- `Mezze.toml [polyglot.provider]` — install-command template for
  the mezze-python provider (used by `mez sync` when a user project
  declares `[polyglot.python] packages`).
- `Mezze.toml [jars]` — the GraalPy runtime jars (`python-language`,
  `python-resources`, `python-launcher`) plus the native-handler
  jar, each pinned by `#sha256:` and verified against
  `~/.mezze/store/jars/<sha>/<name>.jar`.

## Requirements

- `mez` (Mezze CLI) 0.1 or later.
- GraalVM 25.0.3 with GraalPy set up (Mezze's `mezze-runtime.jar`
  currently bundles GraalPy directly; a future release will source
  it exclusively from this package's `[jars]` table).
- A GraalPy venv populated with any pip packages declared under
  `[polyglot.python].packages`.

## License

MIT — see `LICENSE`.

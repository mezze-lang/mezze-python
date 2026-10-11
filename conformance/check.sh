#!/usr/bin/env bash
# Conformance gate for the mezze-python provider.
#
# Runs the TYPE-LEVEL gate (`mez check`) on the conformance app: it references
# every PyForeign verb + both constructor families and calls each crossing verb
# on a Result receiver, so the whole surface AND the `impl Result PyForeign`
# mirror must compile against the current toolchain. Backed by the toolchain's
# #22 foreign-kind gate, this alone proves surface completeness + mirror
# soundness. Runtime-free, so it needs no GraalPy — ideal for CI.
#
# The behavioural layer (`mez dev --no-watch`, which needs GraalPy) is run with
# MEZ_CONFORMANCE_BEHAVIOURAL=1.
#
# Set MEZ to the mez binary. Defaults to a sibling dev build of the toolchain.
set -euo pipefail
cd "$(dirname "$0")"

MEZ="${MEZ:-../../mezze/cli/build/install/mez/bin/mez}"
export MEZZE_HOME="${MEZZE_HOME-}"

echo "→ mez sync"
"$MEZ" sync

echo "→ mez check (type-level conformance: verb surface + Result mirror)"
"$MEZ" check

if [ "${MEZ_CONFORMANCE_BEHAVIOURAL:-0}" = "1" ]; then
  echo "→ mez dev --no-watch (behavioural round-trips; needs GraalPy)"
  "$MEZ" dev --no-watch
fi

echo "✓ mezze-python conformance passed"

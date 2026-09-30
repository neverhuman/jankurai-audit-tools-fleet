#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
mkdir -p target/kernel-mirror-test/bin
cat > target/kernel-mirror-test/bin/git <<'STUB'
#!/usr/bin/env bash
printf '%s\n' "${MIRROR_TEST_OUTPUT:-}"
exit "${MIRROR_TEST_STATUS:-0}"
STUB
chmod +x target/kernel-mirror-test/bin/git
stub_path="$PWD/target/kernel-mirror-test/bin:$PATH"
if PATH="$stub_path" MIRROR_TEST_OUTPUT=$'0000000000000000000000000000000000000000\trefs/tags/jankurai-tools-kernel-v1.7.0-split.1' bash scripts/check-kernel-mirror.sh > target/kernel-mirror-test/wrong-sha.log 2>&1; then
  echo 'mirror guard accepted a moved tag' >&2; exit 1
fi
if PATH="$stub_path" MIRROR_TEST_STATUS=7 bash scripts/check-kernel-mirror.sh > target/kernel-mirror-test/network-failure.log 2>&1; then
  echo 'mirror guard accepted a failed query' >&2; exit 1
fi
echo 'kernel mirror guard: moved tag and failed query rejected'

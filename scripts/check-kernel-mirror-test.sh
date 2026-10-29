#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
mkdir -p target/kernel-mirror-test
fixture_bin=$(mktemp -d "$PWD/target/kernel-mirror-test/bin.XXXXXX")
# Only the fixture executable created below is removed; evidence logs remain.
trap 'rm -f "$fixture_bin/git"; rmdir "$fixture_bin"' EXIT
cat > "$fixture_bin/git" <<'STUB'
#!/usr/bin/env bash
printf '%s\n' "${MIRROR_TEST_OUTPUT:-}"
exit "${MIRROR_TEST_STATUS:-0}"
STUB
chmod +x "$fixture_bin/git"
stub_path="$fixture_bin:$PATH"
PATH="$stub_path" MIRROR_TEST_OUTPUT=$'65e8344ff3718ede0e05c55ee27003d9673c17f0\trefs/tags/ci-65e8344ff3718ede0e05c55ee27003d9673c17f0' bash scripts/check-kernel-mirror.sh > target/kernel-mirror-test/exact-sha.log 2>&1
if PATH="$stub_path" MIRROR_TEST_OUTPUT=$'0000000000000000000000000000000000000000\trefs/tags/ci-65e8344ff3718ede0e05c55ee27003d9673c17f0' bash scripts/check-kernel-mirror.sh > target/kernel-mirror-test/wrong-sha.log 2>&1; then
  echo 'mirror guard accepted a moved tag' >&2; exit 1
fi
if PATH="$stub_path" MIRROR_TEST_STATUS=7 bash scripts/check-kernel-mirror.sh > target/kernel-mirror-test/network-failure.log 2>&1; then
  echo 'mirror guard accepted a failed query' >&2; exit 1
fi
tag=refs/tags/ci-65e8344ff3718ede0e05c55ee27003d9673c17f0
sha=65e8344ff3718ede0e05c55ee27003d9673c17f0
object=1111111111111111111111111111111111111111
annotated=$(printf '%s\t%s\n%s\t%s^{}' "$object" "$tag" "$sha" "$tag")
PATH="$stub_path" MIRROR_TEST_OUTPUT="$annotated" bash scripts/check-kernel-mirror.sh > target/kernel-mirror-test/annotated.log 2>&1
for invalid in \
  "$(printf '%s\t%s\n%s\t%s^{}' "$object" "$tag" "$object" "$tag")" \
  "$(printf '%s\t%s^{}' "$sha" "$tag")" \
  "$(printf '%s\t%s\n%s\t%s' "$sha" "$tag" "$sha" "$tag")" \
  "$(printf '%s\trefs/tags/other' "$sha")" \
  'malformed' ''
do
  if PATH="$stub_path" MIRROR_TEST_OUTPUT="$invalid" bash scripts/check-kernel-mirror.sh >> target/kernel-mirror-test/invalid-refs.log 2>&1; then
    echo 'mirror guard accepted invalid tag refs' >&2; exit 1
  fi
done
echo 'kernel mirror guard: lightweight/annotated identities accepted; invalid refs and failed query rejected'

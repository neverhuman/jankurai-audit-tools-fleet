#!/usr/bin/env bash
# Verify the public route without Git URL rewrites, credentials or a Cargo cache.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
url=https://github.com/neverhuman/jankurai-audit-tools-kernel.git
source_url=https://git.jeryu.ai/git/root/jankurai-tools-kernel
tag=ci-65e8344ff3718ede0e05c55ee27003d9673c17f0
# The immutable kernel revision shared by the 1.7.6 release composition.
sha=65e8344ff3718ede0e05c55ee27003d9673c17f0
grep -Fq "git = \"$source_url\", tag = \"$tag\"" crates/jankurai-fleet/Cargo.toml
grep -Fxq "source = \"git+$source_url?tag=$tag#$sha\"" Cargo.lock
# / is outside a checkout: no repo-local config. Strip injected Git config too.
actual=$(env -u GIT_CONFIG_PARAMETERS -u GIT_CONFIG_COUNT -u GIT_DIR \
  -u GIT_WORK_TREE -u GIT_COMMON_DIR GIT_CONFIG_NOSYSTEM=1 \
  GIT_CONFIG_GLOBAL=/dev/null GIT_TERMINAL_PROMPT=0 \
  git -C / -c credential.helper= ls-remote --exit-code "$url" "refs/tags/$tag" "refs/tags/$tag^{}")
direct='' peeled=''
while IFS=$'\t' read -r object ref extra; do
  [[ "$object" =~ ^[0-9a-f]{40}$ && -z "$extra" ]] || { echo 'malformed mirror tag response' >&2; exit 1; }
  case "$ref" in
    "refs/tags/$tag")
      [[ -z "$direct" ]] || { echo 'duplicate mirror tag response' >&2; exit 1; }
      direct="$object" ;;
    "refs/tags/$tag^{}")
      [[ -z "$peeled" ]] || { echo 'duplicate peeled mirror tag response' >&2; exit 1; }
      peeled="$object" ;;
    *) echo 'unexpected mirror tag response' >&2; exit 1 ;;
  esac
done <<<"$actual"
[[ -n "$direct" && "${peeled:-$direct}" == "$sha" ]] || { echo 'kernel mirror tag does not peel to the accepted locked commit' >&2; exit 1; }
printf 'kernel mirror: public tag and accepted lock identity agree at %s\n' "$sha"

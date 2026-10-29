# jankurai-tools-fleet

Status: initial split-family extraction
Owner: Jankurai maintainers
Last reviewed: 2026-06-12
Applies to: jankurai-tools-fleet

## Role

Fleet dashboard, diff-audit, score history, trend, and repair-task bank source snapshots.

## Repositories

- Authoritative Jeryu repo: `root/jankurai-tools-fleet`
- Public GitHub mirror: `neverhuman/jankurai-audit-tools-fleet`
- Release tag pattern: `jankurai-tools-fleet-v1.7.0-split.0`
- Source extraction commit: `cea83b0cbe204be276a2f0299cd760f6812ea2b0`

## Split Rules

- Jeryu is authoritative; GitHub is the public publishing mirror.
- Release builds depend on immutable tags, not branches. The kernel uses the
  authoritative forge URL `https://git.jeryu.ai/git/root/jankurai-tools-kernel`;
  the historical GitHub kernel repository is disabled.
- Local development uses the hub `scripts/fuse.sh` output under `.fusion/`.
- Committed manifests must not depend on sibling checkout paths.
- Generated outputs are regenerated from their source contracts or build commands.

## Required Local Check

```bash
bash scripts/ci-local.sh required
```

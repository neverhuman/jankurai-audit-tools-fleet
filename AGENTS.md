# jankurai-tools-fleet Agent Instructions

Read `SPLIT.md` first. This repository is one member of the Jankurai split family.

- Authority: `root/jankurai-tools-fleet` on the hosted Jeryu forge.
- Primary remote: `https://git.neverhuman.org/git/root/jankurai-tools-fleet.git`.
- Public publishing mirror: `neverhuman/jankurai-audit-tools-fleet`.
- Do not add committed cross-repo `path = "../..."` dependencies. Use the hub fusion workspace for local path patches.
- Do not hand-edit generated artifacts listed in `agent/generated-zones.toml`.
- Do not edit `CHANGELOG.md` in a change: release notes are generated at release time from commit subjects and `Todo:` trailers.
- Run `bash scripts/ci-local.sh required` before handing off changes.

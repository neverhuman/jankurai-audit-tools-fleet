# Kernel source and public mirror

Fleet consumes `root/jankurai-tools-kernel` from the authoritative forge URL
`https://git.jeryu.ai/git/root/jankurai-tools-kernel`, at immutable tag
`ci-65e8344ff3718ede0e05c55ee27003d9673c17f0` (commit `65e8344ff3718ede0e05c55ee27003d9673c17f0`).
The historical `neverhuman/jankurai-tools-kernel` GitHub repository is disabled.
This source and revision are shared with the auditor 1.7.6 composition.

The public publishing mirror remains
`https://github.com/neverhuman/jankurai-audit-tools-kernel.git`, as declared in
the hub's `repos.manifest.toml`. The mirror is an availability check;
Cargo's manifest and lock use the forge identity. Member authority metadata
names the hosted forge and its existing publishing mirror.

`bash scripts/check-kernel-mirror.sh` first checks the direct dependency and
Cargo lock for that exact forge URL, tag and commit. It then queries the public
mirror with system, global, repository-local and injected Git configuration
disabled and no credential helper. A missing tag, moved tag or failed query
fails the required lane. The offline fixtures exercise a matching identity,
a changed commit and a network failure. The script never resolves or rewrites
Cargo.lock. This public read is not an ownership attestation or a substitute
for reviewing the forge revision.

The required lane retains its public availability check before the locked,
offline metadata, formatting, lint and Rust tests. Network unavailability
therefore fails the lane even if Cargo already has the pinned sources cached.

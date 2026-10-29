# Kernel publishing route

Fleet keeps the kernel content that accepted main already locked:
`92511486b87518bad58b04caff3e772c9c72906d`, tagged
`jankurai-tools-kernel-v1.7.0-split.1` in the authoritative
`root/jankurai-tools-kernel` forge repository. Only the fetch URL changes from
`https://github.com/neverhuman/jankurai-tools-kernel.git` to
`https://github.com/neverhuman/jankurai-audit-tools-kernel.git`.
The old route did not allow an anonymous fetch during qualification; the new
route returned that exact tag and commit. No claim about a different GitHub
owner is needed to justify this change.

`bash scripts/check-kernel-mirror.sh` verifies the manifest and lock still name
that exact identity, then queries the new public tag with system, global,
repository-local and injected Git configuration disabled, no credential helper,
and no Cargo cache involved. The required lane runs this proof before its
unchanged locked offline format, lint and test steps. A missing/moved tag or
network failure fails the gate. Two negative fixtures verify rejection of a
moved tag and a failed remote query. It does not resolve or update the lockfile.

The authoritative forge tag was independently read with `git ls-remote origin
refs/tags/jankurai-tools-kernel-v1.7.0-split.1` in the kernel repository and matched
the same commit. The existing fleet publishing metadata is separate from this
dependency URL repair; changing other member mirror settings is outside this PR.

This reachability check is not an ownership attestation. Mirror ownership and
the accepted base lock identity require independent forge/maintainer evidence.
The required gate deliberately depends on public tag availability; this trades
offline gate availability for continuous verification of the repaired route.

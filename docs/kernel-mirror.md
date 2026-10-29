# Kernel publishing route

Fleet keeps the kernel content that accepted main already locked:
`92511486b87518bad58b04caff3e772c9c72906d`, tagged
`jankurai-tools-kernel-v1.7.0-split.1` in the authoritative
`root/jankurai-tools-kernel` forge repository. Only the fetch URL changes from
`https://github.com/neverhuman/jankurai-tools-kernel.git` to
`https://github.com/neverhuman/jankurai-audit-tools-kernel.git`.
The authoritative hub already declares this publishing route. Its accepted
main commit `928c7fc91fc266a533837b55729858d271b48a60`, in
`repos.manifest.toml`, sets `authority_forge = "jeryu"`,
`mirror_repo_prefix = "jankurai-audit"`, and the kernel member explicitly has:

```toml
name = "jankurai-tools-kernel"
slug = "root/jankurai-tools-kernel"
hosted = "https://git.neverhuman.org/git/root/jankurai-tools-kernel.git"
github = "https://github.com/neverhuman/jankurai-audit-tools-kernel.git"
github_slug = "neverhuman/jankurai-audit-tools-kernel"
```

Inspect that existing authority independently with:

```sh
git -C ../jankurai show 928c7fc91fc266a533837b55729858d271b48a60:repos.manifest.toml
```

The member's `agent/split-member.toml`, `SPLIT.md`, `AGENTS.md` and `.jeryu/repo.toml`
now also name the existing Jeryu authority and the fleet publishing mirror
`neverhuman/jankurai-audit-tools-fleet`, matching that hub manifest. An anonymous
read of the declared kernel mirror returned the existing forge tag and locked
commit. This aligns member metadata with existing authority; it does not add a
reviewer URL map or change reviewer trust policy.

`bash scripts/check-kernel-mirror.sh` verifies the manifest and lock still name
that exact identity, then queries the new public tag with system, global,
repository-local and injected Git configuration disabled, no credential helper,
and no Cargo cache involved. The required lane runs this proof before its
unchanged locked offline format, lint and test steps. A missing/moved tag or
network failure fails the gate. A positive fixture verifies acceptance of the exact
identity; negative fixtures reject a moved tag and a failed remote query. It does not resolve or update the lockfile.

The authoritative forge tag was independently read with `git ls-remote origin
refs/tags/jankurai-tools-kernel-v1.7.0-split.1` in the kernel repository and matched
the same commit. The fleet publishing metadata is aligned to the same accepted hub authority.
Other members are outside this PR.

This reachability check is not an ownership attestation. Mirror authorization comes from the
pre-existing accepted hub manifest above, not from a network success or this
document. The original base and head lock source lines are included in the PR
description for comparison; the commit after `#` is identical.
The required gate deliberately depends on public tag availability; this trades
offline gate availability for continuous verification of the repaired route.

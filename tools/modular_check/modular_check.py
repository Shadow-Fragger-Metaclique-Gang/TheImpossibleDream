#!/usr/bin/env python3
"""
Modularization checker / fixer.

Enforces the modularization guide so contributors don't have to do the
bookkeeping by hand.

Modes:
  check     report problems (CI). Exit code 1 if there are errors.
  fix       add the markers, README entries, .dme includes and so on
            for you, then report anything that still needs fixing.
  classify  print the PR's modularity class (or a corrected PR title).

Only the changes made since the merge-base with the base branch are looked at.
"""

from __future__ import annotations

import argparse
import os
import re
import subprocess
import sys
import tempfile
from dataclasses import dataclass, field
from typing import Dict, List, Optional, Set, Tuple

# ---------------------------------------------------------------- configuration

PREFIX = "SURREALIS"
MODULE_ROOT = "modular_tidi"
GLOBAL_MODULES = MODULE_ROOT + "/global_modules.dm"
CORE_DME = "roguetown.dme"
DEFAULT_BASES = ("upstream/main", "origin/main", "main")

IGNORED_PREFIXES = (
	".github/",
	".vscode/",
	"tools/",
	"html/changelogs/",
)
IGNORED_FILES = {".gitignore", ".gitattributes", ".editorconfig"}

MARKABLE_EXTS = (".dm",)

MODULE_SUBDIRS = {
	"code": (".dm",),
	"icons": (".dmi", ".png"),
	"maps": (".dmm",),
	"sounds": (".ogg", ".wav", ".mp3"),
}

MERGE_GAP = 2

KINDS = ("ADD", "EDIT", "REMOVE")
MARKER_RE = re.compile(r"^\s*//\s*\[(/?)" + PREFIX + r"-(ADD|EDIT|REMOVE)\](.*)$")
MARKER_TAG_RE = re.compile(r"^\s*-\s*([A-Za-z0-9_]+)")
NEAR_MISS_RE = re.compile(r"\[\s*/?\s*(?:SURREALIS|SRLS|SURR)[\s_-]*(?:ADD|EDIT|REMOVE|ADDITION|REMOVAL|EDITS?)\s*\]", re.I)
PLACEHOLDER_TAGS = {"YOUR_TAG", "TAG", "YOUR_MODULE"}
VALID_TAG_RE = re.compile(r"^[A-Z][A-Z0-9_]*$")
README_TAG_RE = re.compile(r"\*{0,2}Tag:?\*{0,2}:?\s*`?([A-Z][A-Z0-9_]*)`?")
INCLUDE_RE = re.compile(r'^\s*#include\s+"([^"]+)"')
CORE_FILES_HEADING_RE = re.compile(
	r"^#{1,6}\s*(core files? (changed|changes|modified)|modified core files|changes to core( files)?|non-modular changes)\b",
	re.I,
)
TITLE_TAG_RE = re.compile(r"\[?\b(?:SEMI|NON)[\s_-]?MODULAR\b\]?\s*[:-]?\s*", re.I)
COMMENTED_CODE_RE = re.compile(
	r"^\s*//(?!/)\s*(?:"
	r"(?:var|proc|verb)/\w"
	r"|/(?:obj|mob|datum|atom|turf|area|proc|client|world)\b[\w/]*"
	r"|(?:if|for|while|switch|else if)\s*\(.*\)\s*$"
	r"|(?:return|qdel|del|to_chat|spawn|sleep|\.\.\(\))\b.*[\)\];]\s*$"
	r"|[\w.\[\]]+\s*(?:[+\-*/|&]?=)\s*[^=\s].*$"
	r"|[\w.]+\(.*\)\s*$"
	r")"
)


# ---------------------------------------------------------------------- helpers

def git(*args: str, check: bool = True) -> str:
	proc = subprocess.run(
		["git", "-c", "core.quotepath=off", *args],
		stdout=subprocess.PIPE,
		stderr=subprocess.PIPE,
	)
	if check and proc.returncode != 0:
		raise SystemExit("git %s failed:\n%s" % (" ".join(args), proc.stderr.decode("utf-8", "replace")))
	return proc.stdout.decode("utf-8", "surrogateescape")


def read_lines(path: str) -> Tuple[List[str], bool]:
	with open(path, "rb") as f:
		text = f.read().decode("utf-8", "surrogateescape")
	if not text:
		return [], True
	trailing = text.endswith("\n")
	lines = text.split("\n")
	if trailing:
		lines.pop()
	return lines, trailing


def write_lines(path: str, lines: List[str], trailing: bool = True) -> None:
	text = "\n".join(lines) + ("\n" if trailing and lines else "")
	os.makedirs(os.path.dirname(path) or ".", exist_ok=True)
	with open(path, "wb") as f:
		f.write(text.encode("utf-8", "surrogateescape"))


def read_text(path: str) -> str:
	try:
		with open(path, "rb") as f:
			return f.read().decode("utf-8", "surrogateescape")
	except FileNotFoundError:
		return ""


def norm(path: str) -> str:
	return os.path.normpath(path.replace("\\", "/")).replace("\\", "/")


def is_ignored(path: str) -> bool:
	return path in IGNORED_FILES or path.startswith(IGNORED_PREFIXES)


def is_module_path(path: str) -> bool:
	return path.startswith(MODULE_ROOT + "/")


def module_of(path: str) -> Optional[str]:
	parts = path.split("/")
	if len(parts) >= 3 and parts[0] == MODULE_ROOT:
		return parts[1]
	return None


def indent_of(line: str) -> str:
	return line[: len(line) - len(line.lstrip(" \t"))]


@dataclass
class Issue:
	level: str  # "error" | "warning"
	path: str
	line: Optional[int]
	msg: str
	fixable: bool = False

	def render(self) -> str:
		loc = self.path + (":%d" % self.line if self.line else "")
		tag = " (fix can do this)" if self.fixable and self.level == "error" else ""
		return "%s: %s: %s%s" % (self.level.upper(), loc, self.msg, tag)


# ------------------------------------------------------------------------- diff

@dataclass
class Hunk:
	old_start: int
	old_len: int
	new_start: int
	new_len: int
	old_lines: List[str] = field(default_factory=list)
	new_lines: List[str] = field(default_factory=list)


HUNK_RE = re.compile(r"^@@ -(\d+)(?:,(\d+))? \+(\d+)(?:,(\d+))? @@")


def resolve_base(base: Optional[str], quiet: bool = False) -> str:
	"""
	Merge-base to diff against. Without --base, every candidate that exists is
	tried and the closest one wins (fewest commits to HEAD)
	"""
	candidates = [base] if base else list(DEFAULT_BASES)
	best = None
	for cand in candidates:
		if not git("rev-parse", "--verify", "--quiet", cand + "^{commit}", check=False).strip():
			continue
		mb = git("merge-base", cand, "HEAD", check=False).strip()
		if not mb:
			continue
		ahead = int(git("rev-list", "--count", mb + "..HEAD").strip() or 0)
		if best is None or ahead < best[0]:
			best = (ahead, cand, mb)
	if best is None:
		raise SystemExit("Could not find a base branch (tried %s). Pass --base <ref>." % ", ".join(candidates))
	if not quiet:
		print("Comparing against %s (merge-base %s, %d commit(s) on this branch)." % (best[1], best[2][:10], best[0]))
	return best[2]


def changed_files(mb: str) -> Tuple[Dict[str, str], Set[str]]:
	"""path -> status letter (A/M/D/T) for everything changed since mb"""
	out = git("diff", "--name-status", "-z", "--no-renames", mb)
	parts = [p for p in out.split("\0") if p]
	files: Dict[str, str] = {}
	for i in range(0, len(parts) - 1, 2):
		files[parts[i + 1]] = parts[i][0]
	untracked = set(p for p in git("ls-files", "--others", "--exclude-standard", "-z").split("\0") if p)
	for p in untracked:
		# Untracked but present at the base means it was deleted and restored
		# (e.g. to comment it out instead): a change to it, not a new file.
		files[p] = "M" if subprocess.run(["git", "cat-file", "-e", "%s:%s" % (mb, p)], capture_output=True).returncode == 0 else "A"
	return files, untracked


def all_hunks(mb: str, paths: List[str]) -> Dict[str, List[Hunk]]:
	result: Dict[str, List[Hunk]] = {}
	if not paths:
		return result
	return parse_hunks(git("diff", "-U0", "--no-color", "--no-ext-diff", "--no-renames", mb), set(paths))


def restored_hunks(mb: str, path: str) -> List[Hunk]:
	"""Hunks for an untracked file that also exists at mb, diffed against that version."""
	fd, tmp = tempfile.mkstemp(suffix=".dm")
	try:
		with os.fdopen(fd, "wb") as f:
			f.write(subprocess.run(["git", "show", "%s:%s" % (mb, path)], capture_output=True, check=True).stdout)
		out = subprocess.run(
			["git", "diff", "--no-index", "-U0", "--no-color", "--no-ext-diff", tmp, path],
			capture_output=True, text=True, encoding="utf-8", errors="replace",
		).stdout
	finally:
		os.remove(tmp)
	return parse_hunks(out, {path}).get(path, [])


def parse_hunks(out: str, wanted: Set[str]) -> Dict[str, List[Hunk]]:
	result: Dict[str, List[Hunk]] = {}
	cur: Optional[List[Hunk]] = None
	old_path = None
	for line in out.split("\n"):
		if line.startswith("diff --git "):
			cur = None
			continue
		if line.startswith("--- ") and cur is None:
			old_path = line[4:].rstrip("\t")
			continue
		if line.startswith("+++ ") and cur is None:
			p = line[4:].rstrip("\t")
			p = old_path if p == "/dev/null" else p
			if p and p.startswith(("a/", "b/")):
				p = p[2:]
			cur = result.setdefault(p, []) if p in wanted else None
			continue
		m = HUNK_RE.match(line)
		if m and cur is not None:
			cur.append(Hunk(
				int(m.group(1)), int(m.group(2) if m.group(2) is not None else 1),
				int(m.group(3)), int(m.group(4) if m.group(4) is not None else 1),
			))
			continue
		if cur and line[:1] == "-":
			cur[-1].old_lines.append(line[1:])
		elif cur and line[:1] == "+":
			cur[-1].new_lines.append(line[1:])
	return result


def untracked_hunks(path: str) -> List[Hunk]:
	lines, _ = read_lines(path)
	return [Hunk(0, 0, 1, len(lines), [], list(lines))] if lines else []


# ---------------------------------------------------------------------- markers

@dataclass
class Region:
	open_idx: int
	close_idx: int
	kind: str
	tag: Optional[str]


@dataclass
class MarkerInfo:
	regions: List[Region]
	errors: List[Tuple[int, str]]  # (line idx, message)
	opens: List[Tuple[int, str, Optional[str]]]  # (idx, kind, tag)


def parse_markers(lines: List[str]) -> MarkerInfo:
	regions: List[Region] = []
	errors: List[Tuple[int, str]] = []
	opens: List[Tuple[int, str, Optional[str]]] = []
	cur: Optional[Tuple[int, str, Optional[str]]] = None
	for i, line in enumerate(lines):
		m = MARKER_RE.match(line)
		if not m:
			continue
		closing, kind, rest = m.group(1) == "/", m.group(2), m.group(3)
		tm = MARKER_TAG_RE.match(rest)
		tag = tm.group(1) if tm else None
		if not closing:
			opens.append((i, kind, tag))
			if cur is not None:
				errors.append((cur[0], "[%s-%s] is never closed before the next marker on line %d" % (PREFIX, cur[1], i + 1)))
				errors.append((i, "marker opened inside another unclosed block (line %d); blocks can't nest" % (cur[0] + 1)))
			cur = (i, kind, tag)
		else:
			if cur is None:
				errors.append((i, "[/%s-%s] has no matching opening marker" % (PREFIX, kind)))
				continue
			if cur[1] != kind:
				errors.append((i, "[/%s-%s] closes a [%s-%s] block opened on line %d" % (PREFIX, kind, PREFIX, cur[1], cur[0] + 1)))
			regions.append(Region(cur[0], i, cur[1], cur[2]))
			cur = None
	if cur is not None:
		errors.append((cur[0], "[%s-%s] is never closed" % (PREFIX, cur[1])))
	return MarkerInfo(regions, errors, opens)


# ------------------------------------------------------------------------ lexer

def insertion_safety(lines: List[str]) -> List[bool]:
	"""
	safe[k] is True if a comment line may be inserted *before* line k
	(k == len(lines) means at end of file). Unsafe spots are inside {" "} strings,
	block comments, or after a backslash line continuation.
	"""
	safe = [True] * (len(lines) + 1)
	stack: List[list] = []  # ["str"|"mstr"|"file"|"emb", depth]
	block = 0
	for idx, line in enumerate(lines):
		i, n = 0, len(line)
		while i < n:
			ch, two = line[i], line[i:i + 2]
			top = stack[-1][0] if stack else None
			if block:
				if two == "/*":
					block += 1
					i += 2
				elif two == "*/":
					block -= 1
					i += 2
				else:
					i += 1
				continue
			if top in (None, "emb"):
				if two == "//":
					break
				if two == "/*":
					block = 1
					i += 2
					continue
				if two == '{"':
					stack.append(["mstr", 0])
					i += 2
					continue
				if ch == '"':
					stack.append(["str", 0])
				elif ch == "'":
					stack.append(["file", 0])
				elif top == "emb" and ch == "[":
					stack[-1][1] += 1
				elif top == "emb" and ch == "]":
					if stack[-1][1]:
						stack[-1][1] -= 1
					else:
						stack.pop()
				i += 1
				continue
			if ch == "\\":
				i += 2
				continue
			if top == "file":
				if ch == "'":
					stack.pop()
				i += 1
				continue
			if ch == "[":
				stack.append(["emb", 0])
			elif top == "str" and ch == '"':
				stack.pop()
			elif top == "mstr" and two == '"}':
				stack.pop()
				i += 2
				continue
			i += 1
		continued = line.rstrip(" \t").endswith("\\")
		in_mstr = any(s[0] == "mstr" for s in stack)
		if not in_mstr and stack and not continued:
			stack = []
			safe[idx + 1] = False
			continue
		safe[idx + 1] = not (block or stack or continued)
	return safe


# ---------------------------------------------------------------------- changes

@dataclass
class Change:
	old_lo: int
	old_hi: int
	new_lo: int
	new_hi: int
	old_text: List[str]

	def is_trivial(self, lines: List[str]) -> bool:
		return not any(l.strip() for l in self.old_text) and not any(l.strip() for l in lines[self.new_lo:self.new_hi])


def hunks_to_changes(hunks: List[Hunk]) -> List[Change]:
	changes = []
	for h in hunks:
		old_lo = h.old_start - 1 if h.old_len else h.old_start
		new_lo = h.new_start - 1 if h.new_len else h.new_start
		changes.append(Change(old_lo, old_lo + h.old_len, new_lo, new_lo + h.new_len, list(h.old_lines)))
	return changes


class ManualFix(Exception):
	pass


def merge_changes(a: Change, b: Change, lines: List[str]) -> Change:
	return Change(a.old_lo, b.old_hi, a.new_lo, b.new_hi, a.old_text + lines[a.new_hi:b.new_lo] + b.old_text)


def normalize_changes(changes: List[Change], lines: List[str], safe: List[bool], in_region: List[bool]) -> List[Change]:
	"""Merge nearby changes and grow each one until its markers can be inserted safely."""
	changes = sorted(changes, key=lambda c: c.new_lo)
	while True:
		merged: List[Change] = []
		for c in changes:
			if merged and c.new_lo - merged[-1].new_hi <= MERGE_GAP and not any(in_region[merged[-1].new_hi:c.new_lo]):
				merged[-1] = merge_changes(merged[-1], c, lines)
			else:
				merged.append(c)
		changes = merged
		grew = False
		for i, c in enumerate(changes):
			floor = changes[i - 1].new_hi if i else 0
			ceil = changes[i + 1].new_lo if i + 1 < len(changes) else len(lines)
			while not safe[c.new_lo]:
				j = c.new_lo - 1
				if j < floor:
					grew = True
					break
				if in_region[j]:
					raise ManualFix("line %d: change sits inside a multi-line string/expression that overlaps an existing marker block" % (c.new_lo + 1))
				c.old_text.insert(0, lines[j])
				c.new_lo -= 1
				c.old_lo -= 1
			while not safe[c.new_hi]:
				j = c.new_hi
				if j >= ceil:
					grew = True
					break
				if in_region[j]:
					raise ManualFix("line %d: change sits inside a multi-line string/expression that overlaps an existing marker block" % (c.new_lo + 1))
				c.old_text.append(lines[j])
				c.new_hi += 1
				c.old_hi += 1
		if not grew:
			return changes


def block_kind(c: Change, lines: List[str]) -> str:
	has_new = any(l.strip() for l in lines[c.new_lo:c.new_hi])
	has_old = any(l.strip() for l in c.old_text)
	if not has_old:
		return "ADD"
	if not has_new:
		return "REMOVE"
	return "EDIT"


def comment_out(old: List[str], ind: str) -> List[str]:
	"""Comment out removed/original code. /* */ like the guide, // if that would break."""
	body = list(old)
	while body and not body[0].strip():
		body.pop(0)
	while body and not body[-1].strip():
		body.pop()
	if any("/*" in l or "*/" in l for l in body):
		common = min((len(indent_of(l)) for l in body if l.strip()), default=0)
		out = []
		for l in body:
			text = l[common:] if l.strip() else ""
			if text.rstrip().endswith("\\"):
				text += " //"
			out.append((ind + "// " + text).rstrip())
		return out
	return [ind + "/*"] + body + [ind + "*/"]


def context_name(lines: List[str], idx: int) -> str:
	"""Nearest enclosing top-level definition (proc/type/define) above idx."""
	for j in range(min(idx, len(lines) - 1), -1, -1):
		l = lines[j]
		if not l or l[0] in " \t" or l.startswith("//") or MARKER_RE.match(l):
			continue
		m = re.match(r"^(/[\w/]+)", l)
		if m:
			return m.group(1)
		m = re.match(r"^#define\s+(\w+)", l)
		if m:
			return "#define " + m.group(1)
		m = re.match(r"^(\w[\w/]*)", l)
		if m and not l.startswith("#"):
			return m.group(1)
	return "file scope"


# ------------------------------------------------------------------- core files

@dataclass
class CoreFileResult:
	issues: List[Issue] = field(default_factory=list)
	tags: Dict[str, Set[str]] = field(default_factory=dict)  # tag -> descriptions
	needs_marking: bool = False


def process_core_dm(path: str, hunks: List[Hunk], fix_tag: Optional[str], known_tags: Dict[str, str]) -> CoreFileResult:
	res = CoreFileResult()
	lines, trailing = read_lines(path)
	info = parse_markers(lines)

	added: Set[int] = set()
	for h in hunks:
		if h.new_len:
			added.update(range(h.new_start - 1, h.new_start - 1 + h.new_len))

	struct_errors = [(i, msg) for i, msg in info.errors if i in added]
	for i, msg in struct_errors:
		res.issues.append(Issue("error", path, i + 1, msg))
	for i in sorted(added):
		if i < len(lines) and NEAR_MISS_RE.search(lines[i]) and not MARKER_RE.match(lines[i]):
			res.issues.append(Issue("error", path, i + 1, "malformed marker; use // [%s-ADD] - TAG, // [%s-EDIT] - TAG or // [%s-REMOVE] - TAG" % (PREFIX, PREFIX, PREFIX)))
	for i, kind, tag in info.opens:
		if i not in added:
			continue
		if not tag:
			res.issues.append(Issue("error", path, i + 1, "marker has no tag; write // [%s-%s] - YOUR_TAG" % (PREFIX, kind)))
		elif not VALID_TAG_RE.match(tag):
			res.issues.append(Issue("error", path, i + 1, "tag '%s' should be UPPER_SNAKE_CASE" % tag))
		elif tag not in known_tags:
			res.issues.append(Issue("error", path, i + 1, "no module for tag %s; expected %s/%s/ (or a README declaring **Tag:** `%s`)" % (tag, MODULE_ROOT, tag.lower(), tag), fixable=True))

	in_region = [False] * len(lines)
	region_at: List[Optional[Region]] = [None] * len(lines)
	for r in info.regions:
		for k in range(r.open_idx, r.close_idx + 1):
			in_region[k] = True
			region_at[k] = r

	changes = hunks_to_changes(hunks)
	uncovered: List[Change] = []
	extensions: Dict[int, Tuple[Region, List[Change]]] = {}
	for c in changes:
		straddles = False
		if c.new_hi > c.new_lo:
			span = range(c.new_lo, c.new_hi)
			covered = [in_region[k] for k in span]
			for k in span:
				if region_at[k] and region_at[k].tag:
					res.tags.setdefault(region_at[k].tag, set()).add("%s near `%s`" % (region_at[k].kind, context_name(lines, region_at[k].open_idx)))
			if all(covered):
				continue
			straddles = any(covered)
		else:
			p = c.new_lo
			r = region_at[p - 1] if 0 < p <= len(lines) and region_at[p - 1] else None
			if r is not None and r.close_idx >= p:
				if r.tag:
					res.tags.setdefault(r.tag, set()).add("%s near `%s`" % (r.kind, context_name(lines, r.open_idx)))
				continue
		if c.is_trivial(lines) and not straddles:
			uncovered.append(c)
			continue
		target, problem = extension_target(c, touching_regions(c, info.regions))
		if target is not None and fix_tag is not None and target.tag == fix_tag and not struct_errors:
			extensions.setdefault(target.open_idx, (target, []))[1].append(c)
			continue
		if straddles:
			if target is not None:
				res.needs_marking = True
				res.issues.append(Issue("error", path, c.new_lo + 1, "change straddles the edge of the %s block on line %d; fix with --tag %s extends that block over it" % (target.tag, target.open_idx + 1, target.tag), fixable=not struct_errors))
			else:
				res.issues.append(Issue("error", path, c.new_lo + 1, "change straddles the edge of a marker block (%s); move the marker so the whole change is inside" % problem))
			continue
		uncovered.append(c)

	if not uncovered and not extensions:
		return res
	real = [c for c in uncovered if not c.is_trivial(lines)]
	if not real and not extensions:
		return res

	if fix_tag is None or struct_errors:
		res.needs_marking = True
		for c in real:
			added_n = c.new_hi - c.new_lo
			msg = "core change is not inside a // [%s-...] block (%d line(s) added, %d removed)" % (PREFIX, added_n, len(c.old_text))
			res.issues.append(Issue("error", path, c.new_lo + 1, msg, fixable=not struct_errors))
		return res

	safe = insertion_safety(lines)
	try:
		blocks = normalize_changes(uncovered, lines, safe, in_region)
	except ManualFix as e:
		res.issues.append(Issue("error", path, None, "could not add markers automatically: %s" % e))
		return res

	inserts: Dict[int, List[str]] = {}
	for c in blocks:
		if c.is_trivial(lines):
			continue
		kind = block_kind(c, lines)
		src = lines[c.new_lo:c.new_hi] if kind != "REMOVE" else c.old_text
		ind = next((indent_of(l) for l in src if l.strip()), "")
		opener = ["%s// [%s-%s] - %s" % (ind, PREFIX, kind, fix_tag)]
		if kind == "EDIT":
			old_nb = [l for l in c.old_text if l.strip()]
			if len(old_nb) == 1:
				opener.append("%s// %s // %s-EDIT - ORIGINAL" % (ind, old_nb[0].strip(), PREFIX))
			else:
				opener.append("%s// %s-EDIT - ORIGINAL" % (ind, PREFIX))
				opener += comment_out(c.old_text, ind)
		elif kind == "REMOVE":
			opener += comment_out(c.old_text, ind)
		closer = ["%s// [/%s-%s]" % (ind, PREFIX, kind)]
		inserts.setdefault(c.new_lo, []).extend(opener)
		inserts.setdefault(c.new_hi, []).extend(closer)
		res.tags.setdefault(fix_tag, set()).add("%s near `%s`" % (kind, context_name(lines, c.new_lo)))

	drop: Set[int] = set()
	replace: Dict[int, str] = {}
	for region, absorbed in extensions.values():
		problem = apply_extension(region, absorbed, lines, safe, inserts, drop, replace)
		if problem:
			res.issues.append(Issue("error", path, region.open_idx + 1, "could not extend the %s block automatically: %s" % (region.tag, problem)))
			return res
		res.tags.setdefault(region.tag, set()).add("%s near `%s`" % ("EDIT" if region.open_idx in replace else region.kind, context_name(lines, region.open_idx)))

	out: List[str] = []
	for k in range(len(lines) + 1):
		out.extend(inserts.get(k, []))
		if k < len(lines) and k not in drop:
			out.append(replace.get(k, lines[k]))
	write_lines(path, out, trailing or not lines)
	return res


def touching_regions(c: Change, regions: List[Region]) -> List[Region]:
	"""Marker blocks a change overlaps, or sits directly above or below with no line in between."""
	found = []
	for r in regions:
		overlaps = c.new_hi > c.new_lo and r.open_idx < c.new_hi and r.close_idx >= c.new_lo
		touches = r.close_idx + 1 == c.new_lo or r.open_idx == c.new_hi
		if overlaps or touches:
			found.append(r)
	return found


def extension_target(c: Change, regions: List[Region]) -> Tuple[Optional[Region], str]:
	"""The one block this change can be folded into, or None and the reason it can't."""
	if not regions:
		return None, "no adjacent block"
	if len(regions) > 1:
		return None, "it touches %d marker blocks" % len(regions)
	r = regions[0]
	if r.kind == "REMOVE":
		return None, "a REMOVE block can't take new code"
	if not r.tag:
		return None, "the block has no tag"
	return r, ""


def original_comment(old_text: List[str], ind: str) -> List[str]:
	old_nb = [l for l in old_text if l.strip()]
	if not old_nb:
		return []
	if len(old_nb) == 1:
		return ["%s// %s // %s-EDIT - ORIGINAL" % (ind, old_nb[0].strip(), PREFIX)]
	return ["%s// %s-EDIT - ORIGINAL" % (ind, PREFIX)] + comment_out(old_text, ind)


def apply_extension(region: Region, absorbed: List[Change], lines: List[str], safe: List[bool], inserts: Dict[int, List[str]], drop: Set[int], replace: Dict[int, str]) -> str:
	"""Grow an existing block over changes beside or across its edges. Returns a problem, or "" when done."""
	new_open = min([region.open_idx] + [c.new_lo for c in absorbed])
	new_end = max([region.close_idx + 1] + [c.new_hi for c in absorbed])
	becomes_edit = region.kind == "ADD" and any(l.strip() for c in absorbed for l in c.old_text)
	opener = lines[region.open_idx]
	closer = lines[region.close_idx]
	if becomes_edit:
		opener = opener.replace("[%s-ADD]" % PREFIX, "[%s-EDIT]" % PREFIX, 1)
		closer = closer.replace("[/%s-ADD]" % PREFIX, "[/%s-EDIT]" % PREFIX, 1)
	ind = indent_of(lines[region.open_idx])
	if new_open < region.open_idx:
		if not safe[new_open]:
			return "line %d is inside a string or expression" % (new_open + 1)
		drop.add(region.open_idx)
		inserts.setdefault(new_open, []).insert(0, opener)
		open_at = new_open
	else:
		replace[region.open_idx] = opener
		open_at = region.open_idx + 1
	if new_end > region.close_idx + 1:
		if not safe[new_end]:
			return "line %d is inside a string or expression" % (new_end + 1)
		drop.add(region.close_idx)
		inserts.setdefault(new_end, []).append(closer)
	else:
		replace[region.close_idx] = closer
	for c in absorbed:
		original = original_comment(c.old_text, ind)
		if not original:
			continue
		at = c.new_lo
		if c.new_hi == c.new_lo and at == region.close_idx + 1:
			at = region.close_idx
		if at <= region.open_idx:
			at = open_at if new_open < region.open_idx else region.open_idx + 1
			if new_open < region.open_idx:
				inserts.setdefault(at, []).extend(original)
				continue
		if not safe[at]:
			return "line %d is inside a string or expression" % (at + 1)
		inserts.setdefault(at, []).extend(original)
	return ""


# ---------------------------------------------------------------------- modules

def module_dirs() -> List[str]:
	if not os.path.isdir(MODULE_ROOT):
		return []
	return sorted(d for d in os.listdir(MODULE_ROOT) if os.path.isdir(os.path.join(MODULE_ROOT, d)))


def load_known_tags() -> Dict[str, str]:
	"""tag -> module dir. Directory name uppercased, plus any **Tag:** in a README."""
	tags: Dict[str, str] = {}
	for d in module_dirs():
		tags.setdefault(d.upper().replace("-", "_"), d)
		for m in README_TAG_RE.finditer(read_text(os.path.join(MODULE_ROOT, d, "README.md"))):
			tags[m.group(1)] = d
	return tags


def collect_includes() -> Set[str]:
	"""Every file reachable by an #include from the core .dme or any module file."""
	sources = [CORE_DME]
	for root, _, files in os.walk(MODULE_ROOT):
		for f in files:
			if f.endswith((".dme", ".dm")):
				sources.append(norm(os.path.join(root, f)))
	found: Set[str] = set()
	for src in sources:
		base = os.path.dirname(src)
		for line in read_text(src).split("\n"):
			m = INCLUDE_RE.match(line)
			if not m:
				continue
			inc = m.group(1).replace("\\", "/")
			found.add(norm(os.path.join(base, inc)).lower())
			found.add(norm(inc).lower())
	return found


def module_dme(mod: str) -> Optional[str]:
	d = os.path.join(MODULE_ROOT, mod)
	dmes = sorted(f for f in os.listdir(d) if f.endswith(".dme")) if os.path.isdir(d) else []
	if not dmes:
		return None
	pref = "_%s.dme" % mod
	return norm(os.path.join(d, pref if pref in dmes else dmes[0]))


def readme_mentions(text: str, path: str) -> bool:
	return path in text or path.replace("/", "\\") in text


def all_readmes_text() -> str:
	return "\n".join(read_text(os.path.join(MODULE_ROOT, d, "README.md")) for d in module_dirs())


README_TEMPLATE = """# {title}

**Tag:** `{tag}`

**Created in:** <!-- link to the PR that created this module -->

**Major changes:** <!-- links to later PRs that changed this module a lot -->

## Description

<!-- What does this module do? -->

## Core files changed
"""


def scaffold_module(tag: str, issues: List[Issue]) -> str:
	mod = tag.lower()
	d = os.path.join(MODULE_ROOT, mod)
	readme = os.path.join(d, "README.md")
	if not os.path.exists(readme):
		write_lines(readme, README_TEMPLATE.format(title=tag.replace("_", " ").title(), tag=tag).rstrip("\n").split("\n"))
		issues.append(Issue("warning", norm(readme), None, "created README for module %s; fill in the description and PR link" % tag))
	return mod


def module_has_code(mod: str) -> bool:
	for _, _, names in os.walk(os.path.join(MODULE_ROOT, mod)):
		if any(n.endswith(".dm") for n in names):
			return True
	return False


def add_readme_entries(readme: str, entries: List[str]) -> None:
	lines, _ = read_lines(readme) if os.path.exists(readme) else ([], True)
	head = next((i for i, l in enumerate(lines) if CORE_FILES_HEADING_RE.match(l)), None)
	if head is None:
		while lines and not lines[-1].strip():
			lines.pop()
		lines += ["", "## Core files changed", ""] + entries
	else:
		end = len(lines)
		for j in range(head + 1, len(lines)):
			if lines[j].startswith("#"):
				end = j
				break
		pos = end
		while pos > head + 1 and not lines[pos - 1].strip():
			pos -= 1
		block = entries
		if pos == head + 1:
			block = [""] + entries
		lines[pos:pos] = block
	write_lines(readme, lines)


def add_global_include(dme: str) -> None:
	inc = os.path.relpath(dme, MODULE_ROOT).replace("/", "\\").replace(os.sep, "\\")
	line = '#include "%s"' % inc
	lines, _ = read_lines(GLOBAL_MODULES) if os.path.exists(GLOBAL_MODULES) else ([], True)
	idx = [i for i, l in enumerate(lines) if INCLUDE_RE.match(l)]
	pos = len(lines)
	for i in idx:
		if INCLUDE_RE.match(lines[i]).group(1).lower() > inc.lower():
			pos = i
			break
	else:
		if idx:
			pos = idx[-1] + 1
	lines.insert(pos, line)
	write_lines(GLOBAL_MODULES, lines)


def check_modules(files: Dict[str, str], fix: bool, issues: List[Issue]) -> None:
	touched = sorted(set(m for p, s in files.items() if s != "D" and is_module_path(p) and (m := module_of(p))))
	if not touched:
		return
	includes = collect_includes()
	core_dirs = set(d.lower() for d in os.listdir("code") if os.path.isdir(os.path.join("code", d))) if os.path.isdir("code") else set()

	for mod in touched:
		d = norm(os.path.join(MODULE_ROOT, mod))
		if not os.path.isdir(d):
			continue
		if not os.path.exists(os.path.join(d, "README.md")):
			if fix:
				scaffold_module(mod.upper(), issues)
			else:
				issues.append(Issue("error", d, None, "module has no README.md", fixable=True))
		dme = module_dme(mod)
		if dme is None and module_has_code(mod):
			if fix:
				write_lines(os.path.join(d, "_%s.dme" % mod), [])
				dme = module_dme(mod)
			else:
				issues.append(Issue("error", d, None, "module has no _%s.dme" % mod, fixable=True))

		if dme:
			if dme.lower() not in includes:
				if fix:
					add_global_include(dme)
					includes.add(dme.lower())
				else:
					issues.append(Issue("error", dme, None, "not included from %s" % GLOBAL_MODULES, fixable=True))
			dlines, dtrail = read_lines(dme)
			changed = False
			for i, l in enumerate(dlines):
				m = INCLUDE_RE.match(l)
				if not m or MODULE_ROOT not in m.group(1).replace("\\", "/"):
					continue
				target = norm(m.group(1))
				local = os.path.relpath(target, d).replace(os.sep, "\\").replace("/", "\\")
				if fix and os.path.exists(target) and not local.startswith(".."):
					dlines[i] = l.replace(m.group(1), local)
					changed = True
				else:
					issues.append(Issue("error", dme, i + 1, 'use a path relative to the module: #include "%s"' % local, fixable=True))
			if changed:
				write_lines(dme, dlines, dtrail)

		for p, status in sorted(files.items()):
			if status == "D" or module_of(p) != mod:
				continue
			rel = p[len(d) + 1:]
			parts = rel.split("/")
			ext = os.path.splitext(p)[1].lower()
			if len(parts) == 1:
				if not (rel == "README.md" or ext in (".dm", ".dme")):
					issues.append(Issue("warning", p, None, "only README.md, .dme and .dm files belong in the module root; use code/, icons/, maps/ or sounds/"))
			else:
				sub = parts[0]
				if sub not in MODULE_SUBDIRS:
					issues.append(Issue("warning", p, None, "'%s/' is not one of the standard module folders (%s)" % (sub, ", ".join(MODULE_SUBDIRS))))
				elif ext not in MODULE_SUBDIRS[sub]:
					issues.append(Issue("error", p, None, "%s/ should only hold %s files" % (sub, "/".join(MODULE_SUBDIRS[sub]))))
				if sub == "code" and len(parts) > 2 and parts[1].lower() in core_dirs:
					issues.append(Issue("error", p, None, "don't mirror the core folder layout inside a module; put it at %s/code/%s" % (d, parts[-1])))
			if ext == ".dm" and status == "A" and norm(p).lower() not in includes:
				if fix and dme:
					inc = os.path.relpath(p, d).replace("/", "\\").replace(os.sep, "\\")
					dl, _ = read_lines(dme)
					while dl and not dl[-1].strip():
						dl.pop()
					dl.append('#include "%s"' % inc)
					write_lines(dme, dl, True)
					includes.add(norm(p).lower())
				else:
					issues.append(Issue("error", p, None, "new file is not #included from the module's .dme", fixable=True))


def check_commented_code(path: str, hunks: List[Hunk], issues: List[Issue]) -> None:
	for h in hunks:
		for k, l in enumerate(h.new_lines):
			if COMMENTED_CODE_RE.match(l) and not NEAR_MISS_RE.search(l) and "ORIGINAL" not in l:
				issues.append(Issue("warning", path, h.new_start + k, "looks like commented-out code; in modules, delete it instead (git keeps the history)"))


# ----------------------------------------------------------------- classification

def classify(paths: List[str]) -> str:
	paths = [p for p in paths if not is_ignored(p)]
	core = any(not is_module_path(p) for p in paths)
	mod = any(is_module_path(p) for p in paths)
	if core and mod:
		return "SEMI-MODULAR"
	if core:
		return "NON-MODULAR"
	return "MODULAR"


def fix_title(title: str, cls: str) -> str:
	stripped = TITLE_TAG_RE.sub("", title).strip()
	if cls == "MODULAR":
		return stripped
	return "[%s] %s" % (cls, stripped)


# ------------------------------------------------------------------------ main

def ask_yes_no_all(question: str) -> str:
	"""Console prompt. Returns 'y', 'n', 'a' (yes to all) or 'q' (no to all)."""
	while True:
		try:
			answer = input(question + " [y]es / [n]o / [a]ll / [q]uit: ").strip().lower()
		except EOFError:
			return "q"
		if answer[:1] in ("y", "n", "a", "q"):
			return answer[:1]


def move_new_core_files(paths: List[str], tag: Optional[str], known: Dict[str, str], mode: str, issues: List[Issue]) -> List[str]:
	"""
	Offer to move new core .dm files into the module and drop their roguetown.dme
	include (check_modules() then adds them to the module's .dme). mode is
	'ask', 'yes' or 'no'. Returns the paths that were moved.
	"""
	if mode == "no" or not paths:
		return []
	if tag is None:
		print("Can't move new core files without knowing the module; re-run with --tag YOUR_TAG.")
		return []
	mod = known.get(tag) or scaffold_module(tag, issues)
	known[tag] = mod
	moved: List[str] = []
	answer_all = mode == "yes"
	for p in paths:
		dest = norm(os.path.join(MODULE_ROOT, mod, "code", os.path.basename(p)))
		if os.path.exists(dest):
			issues.append(Issue("error", p, None, "can't move it: %s already exists" % dest))
			continue
		if not answer_all:
			print()
			print("%s is a new file outside %s/." % (p, MODULE_ROOT), flush=True)
			a = ask_yes_no_all("Move it to %s and fix the #includes?" % dest)
			if a == "q":
				break
			if a == "n":
				continue
			if a == "a":
				answer_all = True
		os.makedirs(os.path.dirname(dest), exist_ok=True)
		os.replace(p, dest)
		moved.append(p)
		dlines, dtrail = read_lines(CORE_DME)
		keep = [l for l in dlines if not ((m := INCLUDE_RE.match(l)) and norm(m.group(1)).lower() == p.lower())]
		if len(keep) != len(dlines):
			write_lines(CORE_DME, keep, dtrail)
		print("Moved %s -> %s" % (p, dest), flush=True)
		if re.search(r"^\s*#define\b", read_text(dest), re.M):
			issues.append(Issue("warning", dest, None, "this file has #defines and now compiles after all core code; if core code uses them, move them to a _defines.dm included from %s" % CORE_DME))
	return moved


def analyze(base: Optional[str], fix: bool, tag: Optional[str], quiet: bool = False, move: str = "no") -> Tuple[List[Issue], str, Optional[str]]:
	mb = resolve_base(base, quiet)
	files, untracked = changed_files(mb)
	known = load_known_tags()
	issues: List[Issue] = []

	core = {p: s for p, s in files.items() if not is_ignored(p) and not is_module_path(p)}
	core_dm = sorted(p for p, s in core.items() if s != "D" and p.endswith(MARKABLE_EXTS) and os.path.exists(p))

	if fix and tag is None:
		touched_mods = sorted(set(m for p in files if (m := module_of(p))))
		if len(touched_mods) == 1:
			mod = touched_mods[0]
			tag = next((t for t, d in known.items() if d == mod and t != mod.upper()), mod.upper().replace("-", "_"))
	if tag is not None:
		tag = tag.upper()
		if tag in PLACEHOLDER_TAGS:
			raise SystemExit("'%s' is the template placeholder; pass your module's real tag (e.g. --tag NOCS_BULB)." % tag)
		if not VALID_TAG_RE.match(tag):
			raise SystemExit("Tag '%s' must be UPPER_SNAKE_CASE (e.g. NOCS_BULB)." % tag)

	if fix:
		new_core = [p for p in core_dm if core[p] == "A"]
		if move_new_core_files(new_core, tag, known, move, issues):
			files, untracked = changed_files(mb)
			core = {p: s for p, s in files.items() if not is_ignored(p) and not is_module_path(p)}
			core_dm = sorted(p for p, s in core.items() if s != "D" and p.endswith(MARKABLE_EXTS) and os.path.exists(p))

	tracked_dm = [p for p in core_dm if p not in untracked]
	hunks = all_hunks(mb, tracked_dm + [p for p in files if is_module_path(p) and p.endswith(".dm") and p not in untracked and files[p] != "D"])
	for p in files:
		if p in untracked and p.endswith(".dm"):
			hunks[p] = restored_hunks(mb, p) if files[p] == "M" else untracked_hunks(p)

	tag_files: Dict[str, Dict[str, Set[str]]] = {}
	unmarked = False
	for p in core_dm:
		if core[p] == "A":
			issues.append(Issue("error", p, None, "new file outside %s/; fix can move it into the module for you (answer yes when asked, or pass --move-new-files)" % MODULE_ROOT, fixable=True))
			continue
		res = process_core_dm(p, hunks.get(p, []), tag if fix else None, known)
		issues.extend(res.issues)
		unmarked |= res.needs_marking
		for t, descs in res.tags.items():
			tag_files.setdefault(t, {}).setdefault(p, set()).update(descs)

	readmes = all_readmes_text()
	for p, s in sorted(core.items()):
		if p in core_dm:
			continue
		if s == "D" and p.endswith(MARKABLE_EXTS):
			issues.append(Issue("warning", p, None, "core file deleted; upstream merges go smoother if you comment it out in a // [%s-REMOVE] block instead" % PREFIX))
		if readme_mentions(readmes, p):
			continue
		if fix and tag:
			tag_files.setdefault(tag, {}).setdefault(p, set()).add({"D": "deleted"}.get(s, "changed"))
		else:
			issues.append(Issue("error", p, None, "core file changed but not listed in any %s/*/README.md" % MODULE_ROOT, fixable=True))

	for t, paths in sorted(tag_files.items()):
		mod = known.get(t)
		if mod is None:
			if not fix:
				continue
			mod = scaffold_module(t, issues)
			known[t] = mod
			files[norm(os.path.join(MODULE_ROOT, mod, "README.md"))] = "A"
		readme = os.path.join(MODULE_ROOT, mod, "README.md")
		text = read_text(readme)
		missing = [p for p in sorted(paths) if not readme_mentions(text, p)]
		if not missing:
			continue
		if fix:
			add_readme_entries(readme, ["- `%s`: %s" % (p, ", ".join(sorted(paths[p]))) for p in missing])
		else:
			for p in missing:
				issues.append(Issue("error", norm(readme), None, "must list core file `%s` under 'Core files changed'" % p, fixable=True))

	check_modules(files, fix, issues)
	for p, hs in hunks.items():
		if is_module_path(p):
			check_commented_code(p, hs, issues)

	if unmarked and not fix:
		issues.append(Issue("error", "", None, "unmarked core changes found", fixable=True))
	return issues, classify(list(files)), tag


def emit(issues: List[Issue], github: bool) -> None:
	for i in issues:
		if not i.path and i.msg == "unmarked core changes found":
			continue
		print(i.render())
		if github:
			msg = i.msg.replace("%", "%25").replace("\r", "%0D").replace("\n", "%0A")
			props = ["title=Modularization"]
			if i.path:
				props.insert(0, "file=" + i.path)
				if i.line:
					props.insert(1, "line=%d" % i.line)
			print("::%s %s::%s" % (i.level, ",".join(props), msg))


def write_summary(issues: List[Issue], cls: str) -> None:
	path = os.environ.get("GITHUB_STEP_SUMMARY")
	if not path:
		return
	errors = [i for i in issues if i.level == "error" and i.path]
	warns = [i for i in issues if i.level == "warning"]
	out = ["## Modularization", "", "PR class: **%s**" % cls, ""]
	if not errors and not warns:
		out.append("Everything is marked and documented. :white_check_mark:")
	if errors:
		out += ["### Errors", ""] + ["- `%s%s`: %s" % (i.path, ":%d" % i.line if i.line else "", i.msg) for i in errors] + [""]
	if warns:
		out += ["### Warnings", ""] + ["- `%s%s`: %s" % (i.path, ":%d" % i.line if i.line else "", i.msg) for i in warns] + [""]
	if any(i.fixable for i in errors):
		out += [
			"### Fixing it",
			"",
			"Most of this is fixed for you. Either download the `modularize-patch` artifact from this run and `git apply` it, or run this from the repo root and commit the result:",
			"",
			"```",
			"tools/modularize.bat --tag YOUR_TAG      (Windows)",
			"tools/modularize.sh --tag YOUR_TAG       (Linux/macOS/Git Bash)",
			"```",
			"",
			"`--tag` can be left out if your PR only touches one `%s/` module." % MODULE_ROOT,
		]
	with open(path, "a", encoding="utf-8") as f:
		f.write("\n".join(out) + "\n")


def main() -> int:
	ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
	sub = ap.add_subparsers(dest="cmd", required=True)
	for name in ("check", "fix"):
		p = sub.add_parser(name)
		p.add_argument("--base", help="branch/commit to compare against (default: upstream/main, origin/main, main)")
		p.add_argument("--github", action="store_true", help="emit GitHub annotations and a step summary")
		if name == "fix":
			p.add_argument("--tag", help="module tag for new markers, e.g. NOCS_BULB (inferred if only one module is touched)")
			moves = p  # combinable; precedence: --move-new-files, --no-input, --ask
			moves.add_argument("--move-new-files", action="store_true", help="move new core .dm files into the module without asking")
			moves.add_argument("--ask", action="store_true", help="ask before moving new core files even if the terminal doesn't look interactive (e.g. Git Bash)")
			moves.add_argument("--no-input", action="store_true", help="never ask; leave new core files where they are")
	c = sub.add_parser("classify")
	c.add_argument("--files-from", help="file with one changed path per line (default: git diff against --base)")
	c.add_argument("--base")
	c.add_argument("--title", help="print this PR title corrected for the class instead of the class")
	args = ap.parse_args()

	os.chdir(git("rev-parse", "--show-toplevel").strip())

	if args.cmd == "classify":
		if args.files_from:
			with open(args.files_from, encoding="utf-8") as f:
				paths = [l.strip() for l in f if l.strip()]
		else:
			paths = list(changed_files(resolve_base(args.base, quiet=True))[0])
		cls = classify(paths)
		print(fix_title(args.title, cls) if args.title is not None else cls)
		return 0

	if args.cmd == "fix":
		if args.move_new_files:
			move = "yes"
		elif args.no_input:
			move = "no"
		elif args.ask or sys.stdin.isatty():
			move = "ask"
		else:
			move = "no"
		issues, cls, tag = analyze(args.base, True, args.tag, move=move)
		issues2, cls, _ = analyze(args.base, False, None, quiet=True)
		created = [i for i in issues if ("created README" in i.msg or "has #defines" in i.msg or "can't move it" in i.msg)]
		remaining = issues2 + created
		if tag is None and any(i.fixable for i in issues2):
			print("Couldn't tell which module these changes belong to. Re-run with --tag YOUR_TAG (e.g. --tag NOCS_BULB).")
		emit(remaining, False)
		errs = [i for i in issues2 if i.level == "error"]
		print("\nPR class: %s. %s" % (cls, "Done, nothing left to fix." if not errs else "%d problem(s) need a human." % len([e for e in errs if e.path])))
		return 1 if errs else 0

	issues, cls, _ = analyze(args.base, False, None)
	emit(issues, args.github)
	if args.github:
		write_summary(issues, cls)
	errs = [i for i in issues if i.level == "error"]
	print("\nPR class: %s. %d error(s), %d warning(s)." % (cls, len([e for e in errs if e.path]), len(issues) - len(errs)))
	if any(i.fixable for i in errs):
		print("Run `tools/modularize.bat --tag YOUR_TAG` (or tools/modularize.sh) to fix the fixable ones automatically.")
	return 1 if errs else 0


if __name__ == "__main__":
	sys.exit(main())

#!/bin/sh

# Copyright (c) 2012 - 2016 dak180 and contributors. See
# https://opensource.org/licenses/mit-license.php or the included
# COPYING.md for licence terms.
#
# autorevision - extracts metadata about the head version from your
# repository.

# Usage message.
arUsage() {
	cat > "/dev/stderr" << EOF
usage: autorevision {-t output-type | -s symbol} [-o cache-file [-f] ] [-V]
	Options include:
	-t output-type		= specify output type
	-s symbol		= specify symbol output
	-o cache-file		= specify cache file location
	-f			= force the use of cache data
	-U			= check for untracked files in svn
	-V			= emit version and exit
	-?			= help message

The following are valid output types:
	clojure			= clojure file
	c			= C/C++ file
	h			= Header for use with c/c++
	hpp			= Alternate C++ header strings with namespace
	ini			= INI file
	java			= Java file
	javaprop		= Java properties file
	js			= javascript file
	json			= JSON file
	lua			= Lua file
	m4			= m4 file
	matlab			= matlab file
	octave			= octave file
	php			= PHP file
	pl			= Perl file
	py			= Python file
	rpm			= rpm file
	scheme			= scheme file
	sh			= Bash sytax
	swift			= Swift file
	tex			= (La)TeX file
	xcode			= Header useful for populating info.plist files


The following are valid symbols:
	VCS_TYPE
	VCS_BASENAME
	VCS_UUID
	VCS_NUM
	VCS_DATE
	VCS_BRANCH
	VCS_TAG
	VCS_TICK
	VCS_EXTRA
	VCS_FULL_HASH
	VCS_SHORT_HASH
	VCS_WC_MODIFIED
	VCS_ACTION_STAMP
EOF
	exit 1
}

# Config
ARVERSION="&&ARVERSION&&"
TARGETFILE="/dev/stdout"
while getopts ":t:o:s:VfU" OPTION; do
	case "${OPTION}" in
		t)
			AFILETYPE="${OPTARG}"
		;;
		o)
			CACHEFILE="${OPTARG}"
		;;
		f)
			CACHEFORCE="1"
		;;
		s)
			VAROUT="${OPTARG}"
		;;
		U)
			UNTRACKEDFILES="1"
		;;
		V)
			echo "autorevision ${ARVERSION}"
			exit 0
		;;
		?)
			# If an unknown flag is used (or -?):
			arUsage
		;;
	esac
done

if [ ! -z "${VAROUT}" ] && [ ! -z "${AFILETYPE}" ]; then
	# If both -s and -t are specified:
	echo "error: Improper argument combination." 1>&2
	exit 1
elif [ -z "${VAROUT}" ] && [ -z "${AFILETYPE}" ]; then
	# If neither -s or -t are specified:
	arUsage
elif [ -z "${CACHEFILE}" ] && [ "${CACHEFORCE}" = "1" ]; then
	# If -f is specified without -o:
	arUsage
elif [ ! -f "${CACHEFILE}" ] && [ "${CACHEFORCE}" = "1" ]; then
	# If we are forced to use the cache but it does not exist.
	echo "error: Cache forced but no cache found." 1>&2
	exit 1
fi

# Make sure that the path we are given is one we can source
# (dash, we are looking at you).
if [ ! -z "${CACHEFILE}" ] && ! echo "${CACHEFILE}" | grep -q '^\.*/'; then
	CACHEFILE="./${CACHEFILE}"
fi


# Functions to extract data from different repo types.
# For git repos
# shellcheck disable=SC2039,SC2164,SC2155
gitRepo() {
	local oldPath="${PWD}"

	cd "$(git rev-parse --show-toplevel)"

	VCS_TYPE="git"

	VCS_BASENAME="$(basename "${PWD}")"

	VCS_UUID="$(git rev-list --max-parents=0 --date-order --reverse HEAD 2>/dev/null | sed -n 1p)"
	if [ -z "${VCS_UUID}" ]; then
		VCS_UUID="$(git rev-list --topo-order HEAD | tail -n 1)"
	fi

	# Is the working copy clean?
	test -z "$(git status --untracked-files=normal --porcelain)"
	VCS_WC_MODIFIED="${?}"

	# Enumeration of changesets
	VCS_NUM="$(git rev-list --count HEAD 2>/dev/null)"
	if [ -z "${VCS_NUM}" ]; then
		echo "warning: Counting the number of revisions may be slower due to an outdated git version less than 1.7.2.3. If something breaks, please update it." 1>&2
		VCS_NUM="$(git rev-list HEAD | wc -l)"
	fi

	# This may be a git-svn remote.  If so, report the Subversion revision.
	if [ -z "$(git config svn-remote.svn.url 2>/dev/null)" ]; then
		# The full revision hash
		VCS_FULL_HASH="$(git rev-parse HEAD)"

		# The short hash
		VCS_SHORT_HASH="$(echo "${VCS_FULL_HASH}" | cut -b 1-7)"
	else
		# The git-svn revision number
		VCS_FULL_HASH="$(git svn find-rev HEAD)"
		VCS_SHORT_HASH="${VCS_FULL_HASH}"
	fi

	# Current branch
	VCS_BRANCH="$(git rev-parse --symbolic-full-name --verify "$(git name-rev --name-only --no-undefined HEAD 2>/dev/null)" 2>/dev/null | sed -e 's:refs/heads/::' | sed -e 's:refs/::')"

	# Cache the description
	local DESCRIPTION="$(git describe --long --tags 2>/dev/null)"

	# Current or last tag ancestor (empty if no tags)
	VCS_TAG="$(echo "${DESCRIPTION}" | sed -e "s:-g${VCS_SHORT_HASH}\$::" -e 's:-[0-9]*$::')"

	# Distance to last tag or an alias of VCS_NUM if there is no tag
	if [ ! -z "${DESCRIPTION}" ]; then
		VCS_TICK="$(echo "${DESCRIPTION}" | sed -e "s:${VCS_TAG}-::" -e "s:-g${VCS_SHORT_HASH}::")"
	else
		VCS_TICK="${VCS_NUM}"
	fi

	# Date of the current commit
	VCS_DATE="$(TZ=UTC git show -s --date=iso-strict-local --pretty=format:%ad | sed -e 's|+00:00|Z|')"
	if [ -z "${VCS_DATE}" ]; then
		echo "warning: Action stamps require git version 2.7+." 1>&2
		VCS_DATE="$(git log -1 --pretty=format:%ci | sed -e 's: :T:' -e 's: ::' -e 's|+00:00|Z|')"
		local ASdis="1"
	fi

	# Action Stamp
	if [ -z "${ASdis}" ]; then
		VCS_ACTION_STAMP="${VCS_DATE}!$(git show -s --pretty=format:%cE)"
	else
		VCS_ACTION_STAMP=""
	fi

	cd "${oldPath}"
}

# For hg repos
# shellcheck disable=SC2039,SC2164
hgRepo() {
	local oldPath="${PWD}"

	cd "$(hg root)"

	VCS_TYPE="hg"

	VCS_BASENAME="$(basename "${PWD}")"

	VCS_UUID="$(hg log -r "0" -l 1 --template '{node}\n')"

	# Is the working copy clean?
	test -z "$(hg status -duram)"
	VCS_WC_MODIFIED="${?}"

	# Enumeration of changesets
	VCS_NUM="$(hg id -n | tr -d '+')"

	# The full revision hash
	VCS_FULL_HASH="$(hg log -r "${VCS_NUM}" -l 1 --template '{node}\n')"

	# The short hash
	VCS_SHORT_HASH="$(hg id -i | tr -d '+')"

	# Current bookmark (bookmarks are roughly equivalent to git's branches)
	# or branch if no bookmark
	VCS_BRANCH="$(hg id -B | cut -d ' ' -f 1)"
	# Fall back to the branch if there are no bookmarks
	if [ -z "${VCS_BRANCH}" ]; then
		VCS_BRANCH="$(hg id -b)"
	fi

	# Current or last tag ancestor (excluding auto tags, empty if no tags)
	VCS_TAG="$(hg log -r "${VCS_NUM}" -l 1 --template '{latesttag}\n' 2>/dev/null | sed -e 's:qtip::' -e 's:tip::' -e 's:qbase::' -e 's:qparent::' -e "s:$(hg --config 'extensions.color=' --config 'extensions.mq=' --color never qtop 2>/dev/null)::" | cut -d ' ' -f 1)"

	# Distance to last tag or an alias of VCS_NUM if there is no tag
	if [ ! -z "${VCS_TAG}" ]; then
		VCS_TICK="$(hg log -r "${VCS_NUM}" -l 1 --template '{latesttagdistance}\n' 2>/dev/null)"
	else
		VCS_TICK="${VCS_NUM}"
	fi

	# Date of the current commit
	VCS_DATE="$(hg log -r "${VCS_NUM}" -l 1 --template '{date|isodatesec}\n' 2>/dev/null | sed -e 's: :T:' -e 's: ::' -e 's|+00:00|Z|')"

	# Action Stamp
	VCS_ACTION_STAMP="$(TZ=UTC hg log -r "${VCS_NUM}" -l 1 --template '{date|localdate|rfc3339date}\n' 2>/dev/null | sed -e 's|+00:00|Z|')!$(hg log -r "${VCS_NUM}" -l 1 --template '{author|email}\n' 2>/dev/null)"

	cd "${oldPath}"
}

# For bzr repos
# shellcheck disable=SC2039,SC2164
bzrRepo() {
	local oldPath="${PWD}"

	cd "$(bzr root)"

	VCS_TYPE="bzr"

	VCS_BASENAME="$(basename "${PWD}")"

	# Currently unimplemented because more investigation is needed.
	VCS_UUID=""

	# Is the working copy clean?
	bzr version-info --custom --template='{clean}\n' | grep -q '1'
	VCS_WC_MODIFIED="${?}"

	# Enumeration of changesets
	VCS_NUM="$(bzr revno)"

	# The full revision hash
	VCS_FULL_HASH="$(bzr version-info --custom --template='{revision_id}\n')"

	# The short hash
	VCS_SHORT_HASH="${VCS_NUM}"

	# Nick of the current branch
	VCS_BRANCH="$(bzr nick)"

	# Current or last tag ancestor (excluding auto tags, empty if no tags)
	VCS_TAG="$(bzr tags --sort=time | sed '/?$/d' | tail -n1 | cut -d ' ' -f1)"

	# Distance to last tag or an alias of VCS_NUM if there is no tag
	if [ ! -z "${VCS_TAG}" ]; then
		VCS_TICK="$(bzr log --line -r "tag:${VCS_TAG}.." | tail -n +2 | wc -l | sed -e 's:^ *::')"
	else
		VCS_TICK="${VCS_NUM}"
	fi

	# Date of the current commit
	VCS_DATE="$(bzr version-info --custom --template='{date}\n' | sed -e 's: :T:' -e 's: ::')"

	# Action Stamp
	# Currently unimplemented because more investigation is needed.
	VCS_ACTION_STAMP=""

	cd "${oldPath}"
}

# For svn repos
# shellcheck disable=SC2039,SC2164,SC2155
svnRepo() {
	local oldPath="${PWD}"

	VCS_TYPE="svn"

	case "${PWD}" in
	/*trunk*|/*branches*|/*tags*)
		local fn="${PWD}"
		while [ "$(basename "${fn}")" != 'trunk' ] && [ "$(basename "${fn}")" != 'branches' ] && [ "$(basename "${fn}")" != 'tags' ] && [ "$(basename "${fn}")" != '/' ]; do
			local fn="$(dirname "${fn}")"
		done
		local fn="$(dirname "${fn}")"
		if [ "${fn}" = '/' ]; then
			VCS_BASENAME="$(basename "${PWD}")"
		else
			VCS_BASENAME="$(basename "${fn}")"
		fi
		;;
	*) VCS_BASENAME="$(basename "${PWD}")" ;;
	esac

	VCS_UUID="$(svn info --xml | sed -n -e 's:<uuid>::' -e 's:</uuid>::p')"

	# Cache svnversion output
	local SVNVERSION="$(svnversion)"

	# Is the working copy clean?
	echo "${SVNVERSION}" | grep -q "M"
	case "${?}" in
		0)
			VCS_WC_MODIFIED="1"
		;;
		1)
			if [ ! -z "${UNTRACKEDFILES}" ]; then
			# `svnversion` does not detect untracked files and `svn status` is really slow, so only run it if we really have to.
				if [ -z "$(svn status)" ]; then
					VCS_WC_MODIFIED="0"
				else
					VCS_WC_MODIFIED="1"
				fi
			else
				VCS_WC_MODIFIED="0"
			fi
		;;
	esac

	# Enumeration of changesets
	VCS_NUM="$(echo "${SVNVERSION}" | cut -d : -f 1 | sed -e 's:M::' -e 's:S::' -e 's:P::')"

	# The full revision hash
	VCS_FULL_HASH="${SVNVERSION}"

	# The short hash
	VCS_SHORT_HASH="${VCS_NUM}"

	# Current branch
	case "${PWD}" in
	/*trunk*|/*branches*|/*tags*)
		local lastbase=""
		local fn="${PWD}"
		while :
		do
			base="$(basename "${fn}")"
			if [ "${base}" = 'trunk' ]; then
				VCS_BRANCH='trunk'
				break
			elif [ "${base}" = 'branches' ] || [ "${base}" = 'tags' ]; then
				VCS_BRANCH="${lastbase}"
				break
			elif [ "${base}" = '/' ]; then
				VCS_BRANCH=""
				break
			fi
			local lastbase="${base}"
			local fn="$(dirname "${fn}")"
		done
		;;
	*) VCS_BRANCH="" ;;
	esac

	# Current or last tag ancestor (empty if no tags). But "current
	# tag" can't be extracted reliably because Subversion doesn't
	# have tags the way other VCSes do.
	VCS_TAG=""
	VCS_TICK=""

	# Date of the current commit
	VCS_DATE="$(svn info --xml | sed -n -e 's:<date>::' -e 's:</date>::p')"

	# Action Stamp
	VCS_ACTION_STAMP="${VCS_DATE}!$(svn log --xml -l 1 -r "${VCS_SHORT_HASH}" | sed -n -e 's:<author>::' -e 's:</author>::p')"

	cd "${oldPath}"
}


# Functions to output data in different formats.
# For bash output
shOutput() {
	cat > "${TARGETFILE}" << EOF
# Generated by autorevision - do not hand-hack!

VCS_TYPE="${VCS_TYPE}"
VCS_BASENAME="${VCS_BASENAME}"
VCS_UUID="${VCS_UUID}"
VCS_NUM="${VCS_NUM}"
VCS_DATE="${VCS_DATE}"
VCS_BRANCH="${VCS_BRANCH}"
VCS_TAG="${VCS_TAG}"
VCS_TICK="${VCS_TICK}"
VCS_EXTRA="${VCS_EXTRA}"

VCS_ACTION_STAMP="${VCS_ACTION_STAMP}"
VCS_FULL_HASH="${VCS_FULL_HASH}"
VCS_SHORT_HASH="${VCS_SHORT_HASH}"

VCS_WC_MODIFIED="${VCS_WC_MODIFIED}"

# end
EOF
}

# For source C output
cOutput() {
	cat > "${TARGETFILE}" << EOF
/* Generated by autorevision - do not hand-hack! */

const char *VCS_TYPE         = "${VCS_TYPE}";
const char *VCS_BASENAME     = "${VCS_BASENAME}";
const char *VCS_UUID         = "${VCS_UUID}";
const int VCS_NUM            = ${VCS_NUM};
const char *VCS_DATE         = "${VCS_DATE}";
const char *VCS_BRANCH       = "${VCS_BRANCH}";
const char *VCS_TAG          = "${VCS_TAG}";
const int VCS_TICK           = ${VCS_TICK};
const char *VCS_EXTRA        = "${VCS_EXTRA}";

const char *VCS_ACTION_STAMP = "${VCS_ACTION_STAMP}";
const char *VCS_FULL_HASH    = "${VCS_FULL_HASH}";
const char *VCS_SHORT_HASH   = "${VCS_SHORT_HASH}";

const int VCS_WC_MODIFIED     = ${VCS_WC_MODIFIED};

/* end */
EOF
}

# For header output
hOutput() {
	cat > "${TARGETFILE}" << EOF
/* Generated by autorevision - do not hand-hack! */
#ifndef AUTOREVISION_H
#define AUTOREVISION_H

#define VCS_TYPE		"${VCS_TYPE}"
#define VCS_BASENAME	"${VCS_BASENAME}"
#define VCS_UUID		"${VCS_UUID}"
#define VCS_NUM			${VCS_NUM}
#define VCS_DATE		"${VCS_DATE}"
#define VCS_BRANCH		"${VCS_BRANCH}"
#define VCS_TAG			"${VCS_TAG}"
#define VCS_TICK		${VCS_TICK}
#define VCS_EXTRA		"${VCS_EXTRA}"

#define VCS_ACTION_STAMP	"${VCS_ACTION_STAMP}"
#define VCS_FULL_HASH		"${VCS_FULL_HASH}"
#define VCS_SHORT_HASH		"${VCS_SHORT_HASH}"

#define VCS_WC_MODIFIED		${VCS_WC_MODIFIED}

#endif

/* end */
EOF
}

# A header output for use with xcode to populate info.plist strings
xcodeOutput() {
	cat > "${TARGETFILE}" << EOF
/* Generated by autorevision - do not hand-hack! */
#ifndef AUTOREVISION_H
#define AUTOREVISION_H

#define VCS_TYPE		${VCS_TYPE}
#define VCS_BASENAME	${VCS_BASENAME}
#define VCS_UUID		${VCS_UUID}
#define VCS_NUM			${VCS_NUM}
#define VCS_DATE		${VCS_DATE}
#define VCS_BRANCH		${VCS_BRANCH}
#define VCS_TAG			${VCS_TAG}
#define VCS_TICK		${VCS_TICK}
#define VCS_EXTRA		${VCS_EXTRA}

#define VCS_ACTION_STAMP	${VCS_ACTION_STAMP}
#define VCS_FULL_HASH		${VCS_FULL_HASH}
#define VCS_SHORT_HASH		${VCS_SHORT_HASH}

#define VCS_WC_MODIFIED		${VCS_WC_MODIFIED}

#endif

/* end */
EOF
}

# For Swift output
swiftOutput() {
	case "${VCS_WC_MODIFIED}" in
		0) VCS_WC_MODIFIED="false" ;;
		1) VCS_WC_MODIFIED="true" ;;
	esac
	# For values that may not exist depending on the type of repo we
	# have read from, set them to `nil` when they are empty.
	if [ -z "${VCS_UUID}" ]; then
		VCS_UUID="nil"
	else
		VCS_UUID="\"${VCS_UUID}\""
	fi
	if [ -z "${VCS_TAG}" ]; then
		VCS_TAG="nil"
	else
		VCS_TAG="\"${VCS_TAG}\""
	fi
	: "${VCS_TICK:="nil"}"
	if [ -z "${VCS_EXTRA}" ]; then
		VCS_EXTRA="nil"
	else
		VCS_EXTRA="\"${VCS_EXTRA}\""
	fi
	if [ -z "${VCS_ACTION_STAMP}" ]; then
		VCS_ACTION_STAMP="nil"
	else
		VCS_ACTION_STAMP="\"${VCS_ACTION_STAMP}\""
	fi
	cat > "${TARGETFILE}" << EOF
/* Generated by autorevision - do not hand-hack! */

let VCS_TYPE			= "${VCS_TYPE}"
let VCS_BASENAME		= "${VCS_BASENAME}"
let VCS_UUID:	String?	= ${VCS_UUID}
let VCS_NUM:	Int		= ${VCS_NUM}
let VCS_DATE			= "${VCS_DATE}"
let VCS_BRANCH:	String	= "${VCS_BRANCH}"
let VCS_TAG:	String?	= ${VCS_TAG}
let VCS_TICK:	Int?	= ${VCS_TICK}
let VCS_EXTRA:	String?	= ${VCS_EXTRA}

let VCS_ACTION_STAMP:	String?	= ${VCS_ACTION_STAMP}
let VCS_FULL_HASH:		String	= "${VCS_FULL_HASH}"
let VCS_SHORT_HASH:		String	= "${VCS_SHORT_HASH}"

let VCS_WC_MODIFIED:	Bool	= ${VCS_WC_MODIFIED}

/* end */
EOF
}

# For Python output
pyOutput() {
	case "${VCS_WC_MODIFIED}" in
		0) VCS_WC_MODIFIED="False" ;;
		1) VCS_WC_MODIFIED="True" ;;
	esac
	cat > "${TARGETFILE}" << EOF
# Generated by autorevision - do not hand-hack!

VCS_TYPE = "${VCS_TYPE}"
VCS_BASENAME = "${VCS_BASENAME}"
VCS_UUID = "${VCS_UUID}"
VCS_NUM = ${VCS_NUM}
VCS_DATE = "${VCS_DATE}"
VCS_BRANCH = "${VCS_BRANCH}"
VCS_TAG = "${VCS_TAG}"
VCS_TICK = ${VCS_TICK}
VCS_EXTRA = "${VCS_EXTRA}"

VCS_ACTION_STAMP = "${VCS_ACTION_STAMP}"
VCS_FULL_HASH = "${VCS_FULL_HASH}"
VCS_SHORT_HASH = "${VCS_SHORT_HASH}"

VCS_WC_MODIFIED = ${VCS_WC_MODIFIED}

# end
EOF
}

# For Perl output
plOutput() {
	cat << EOF
# Generated by autorevision - do not hand-hack!

\$VCS_TYPE = "${VCS_TYPE}";
\$VCS_BASENAME = "${VCS_BASENAME}"
\$VCS_UUID = "${VCS_UUID}"
\$VCS_NUM = ${VCS_NUM};
\$VCS_DATE = "${VCS_DATE}";
\$VCS_BRANCH = "${VCS_BRANCH}";
\$VCS_TAG = "${VCS_TAG}";
\$VCS_TICK = ${VCS_TICK};
\$VCS_EXTRA = "${VCS_EXTRA}";

\$VCS_ACTION_STAMP = "${VCS_ACTION_STAMP}";
\$VCS_FULL_HASH = "${VCS_FULL_HASH}";
\$VCS_SHORT_HASH = "${VCS_SHORT_HASH}";

\$VCS_WC_MODIFIED = ${VCS_WC_MODIFIED};

# end
EOF
}

# For lua output
luaOutput() {
	case "${VCS_WC_MODIFIED}" in
		0) VCS_WC_MODIFIED="false" ;;
		1) VCS_WC_MODIFIED="true" ;;
	esac
	cat > "${TARGETFILE}" << EOF
-- Generated by autorevision - do not hand-hack!

VCS_TYPE = "${VCS_TYPE}"
VCS_BASENAME = "${VCS_BASENAME}"
VCS_UUID = "${VCS_UUID}"
VCS_NUM = ${VCS_NUM}
VCS_DATE = "${VCS_DATE}"
VCS_BRANCH = "${VCS_BRANCH}"
VCS_TAG = "${VCS_TAG}"
VCS_TICK = ${VCS_TICK}
VCS_EXTRA = "${VCS_EXTRA}"

VCS_ACTION_STAMP = "${VCS_ACTION_STAMP}"
VCS_FULL_HASH = "${VCS_FULL_HASH}"
VCS_SHORT_HASH = "${VCS_SHORT_HASH}"

VCS_WC_MODIFIED = ${VCS_WC_MODIFIED}

-- end
EOF
}

# For php output
phpOutput() {
	case "${VCS_WC_MODIFIED}" in
		0) VCS_WC_MODIFIED="false" ;;
		1) VCS_WC_MODIFIED="true" ;;
	esac
	cat > "${TARGETFILE}" << EOF
<?php
# Generated by autorevision - do not hand-hack!

return array(
	"VCS_TYPE" => "${VCS_TYPE}",
	"VCS_BASENAME" => "${VCS_BASENAME}",
	"VCS_UUID" => "${VCS_UUID}",
	"VCS_NUM" => ${VCS_NUM},
	"VCS_DATE" => "${VCS_DATE}",
	"VCS_BRANCH" => "${VCS_BRANCH}",
	"VCS_TAG" => "${VCS_TAG}",
	"VCS_TICK" => ${VCS_TICK},
	"VCS_EXTRA" => "${VCS_EXTRA}",
	"VCS_ACTION_STAMP" => "${VCS_ACTION_STAMP}",
	"VCS_FULL_HASH" => "${VCS_FULL_HASH}",
	"VCS_SHORT_HASH" => "${VCS_SHORT_HASH}",
	"VCS_WC_MODIFIED" => ${VCS_WC_MODIFIED}
);

# end
?>
EOF
}

# For ini output
iniOutput() {
	case "${VCS_WC_MODIFIED}" in
		0) VCS_WC_MODIFIED="false" ;;
		1) VCS_WC_MODIFIED="true" ;;
	esac
	cat > "${TARGETFILE}" << EOF
; Generated by autorevision - do not hand-hack!
[VCS]
VCS_TYPE = "${VCS_TYPE}"
VCS_BASENAME = "${VCS_BASENAME}"
VCS_UUID = "${VCS_UUID}"
VCS_NUM = ${VCS_NUM}
VCS_DATE = "${VCS_DATE}"
VCS_BRANCH = "${VCS_BRANCH}"
VCS_TAG = "${VCS_TAG}"
VCS_TICK = ${VCS_TICK}
VCS_EXTRA = "${VCS_EXTRA}"
VCS_ACTION_STAMP = "${VCS_ACTION_STAMP}"
VCS_FULL_HASH = "${VCS_FULL_HASH}"
VCS_SHORT_HASH = "${VCS_SHORT_HASH}"
VCS_WC_MODIFIED = ${VCS_WC_MODIFIED}
; end
EOF
}

# For javascript output
jsOutput() {
	case "${VCS_WC_MODIFIED}" in
		1) VCS_WC_MODIFIED="true" ;;
		0) VCS_WC_MODIFIED="false" ;;
	esac
	cat > "${TARGETFILE}" << EOF
/** Generated by autorevision - do not hand-hack! */

var autorevision = {
	VCS_TYPE: "${VCS_TYPE}",
	VCS_BASENAME: "${VCS_BASENAME}",
	VCS_UUID: "${VCS_UUID}",
	VCS_NUM: ${VCS_NUM},
	VCS_DATE: "${VCS_DATE}",
	VCS_BRANCH: "${VCS_BRANCH}",
	VCS_TAG: "${VCS_TAG}",
	VCS_TICK: ${VCS_TICK},
	VCS_EXTRA: "${VCS_EXTRA}",

	VCS_ACTION_STAMP: "${VCS_ACTION_STAMP}",
	VCS_FULL_HASH: "${VCS_FULL_HASH}",
	VCS_SHORT_HASH: "${VCS_SHORT_HASH}",

	VCS_WC_MODIFIED: ${VCS_WC_MODIFIED}
};

/** Node.js compatibility */
if (typeof module !== 'undefined') {
	module.exports = autorevision;
}

/** end */
EOF
}

# For JSON output
jsonOutput() {
	case "${VCS_WC_MODIFIED}" in
		1) VCS_WC_MODIFIED="true" ;;
		0) VCS_WC_MODIFIED="false" ;;
	esac
	cat > "${TARGETFILE}" << EOF
{
	"VCS_TYPE": "${VCS_TYPE}",
	"VCS_BASENAME": "${VCS_BASENAME}",
	"VCS_UUID": "${VCS_UUID}",
	"VCS_NUM": ${VCS_NUM},
	"VCS_DATE": "${VCS_DATE}",
	"VCS_BRANCH":"${VCS_BRANCH}",
	"VCS_TAG": "${VCS_TAG}",
	"VCS_TICK": ${VCS_TICK},
	"VCS_EXTRA": "${VCS_EXTRA}",

	"VCS_ACTION_STAMP": "${VCS_ACTION_STAMP}",
	"VCS_FULL_HASH": "${VCS_FULL_HASH}",
	"VCS_SHORT_HASH": "${VCS_SHORT_HASH}",

	"VCS_WC_MODIFIED": ${VCS_WC_MODIFIED}
}
EOF
}

# For Java output
javaOutput() {
	case "${VCS_WC_MODIFIED}" in
		1) VCS_WC_MODIFIED="true" ;;
		0) VCS_WC_MODIFIED="false" ;;
	esac
	cat > "${TARGETFILE}" << EOF
/* Generated by autorevision - do not hand-hack! */

public class autorevision {
    public static final String VCS_TYPE = "${VCS_TYPE}";
    public static final String VCS_BASENAME = "${VCS_BASENAME}";
    public static final String VCS_UUID = "${VCS_UUID}";
    public static final long VCS_NUM = ${VCS_NUM};
    public static final String VCS_DATE = "${VCS_DATE}";
    public static final String VCS_BRANCH = "${VCS_BRANCH}";
    public static final String VCS_TAG = "${VCS_TAG}";
    public static final long VCS_TICK = ${VCS_TICK};
    public static final String VCS_EXTRA = "${VCS_EXTRA}";

    public static final String VCS_ACTION_STAMP = "${VCS_ACTION_STAMP}";
    public static final String VCS_FULL_HASH = "${VCS_FULL_HASH}";
    public static final String VCS_SHORT_HASH = "${VCS_SHORT_HASH}";

    public static final boolean VCS_WC_MODIFIED = ${VCS_WC_MODIFIED};
}
EOF
}

# For Java properties output
javapropOutput() {
	case "${VCS_WC_MODIFIED}" in
		1) VCS_WC_MODIFIED="true" ;;
		0) VCS_WC_MODIFIED="false" ;;
	esac
	cat > "${TARGETFILE}" << EOF
# Generated by autorevision - do not hand-hack!

VCS_TYPE=${VCS_TYPE}
VCS_BASENAME=${VCS_BASENAME}
VCS_UUID=${VCS_UUID}
VCS_NUM=${VCS_NUM}
VCS_DATE=${VCS_DATE}
VCS_BRANCH=${VCS_BRANCH}
VCS_TAG=${VCS_TAG}
VCS_TICK=${VCS_TICK}
VCS_EXTRA=${VCS_EXTRA}

VCS_ACTION_STAMP=${VCS_ACTION_STAMP}
VCS_FULL_HASH=${VCS_FULL_HASH}
VCS_SHORT_HASH=${VCS_SHORT_HASH}

VCS_WC_MODIFIED=${VCS_WC_MODIFIED}
EOF
}

# For m4 output
m4Output() {
	cat > "${TARGETFILE}" << EOF
define(\`VCS_TYPE', \`${VCS_TYPE}')dnl
define(\`VCS_BASENAME', \`${VCS_BASENAME}')dnl
define(\`VCS_UUID', \`${VCS_UUID}')dnl
define(\`VCS_NUM', \`${VCS_NUM}')dnl
define(\`VCS_DATE', \`${VCS_DATE}')dnl
define(\`VCS_BRANCH', \`${VCS_BRANCH}')dnl
define(\`VCS_TAG', \`${VCS_TAG}')dnl
define(\`VCS_TICK', \`${VCS_TICK}')dnl
define(\`VCS_EXTRA', \`${VCS_EXTRA}')dnl
define(\`VCS_ACTIONSTAMP', \`${VCS_ACTION_STAMP}')dnl
define(\`VCS_FULLHASH', \`${VCS_FULL_HASH}')dnl
define(\`VCS_SHORTHASH', \`${VCS_SHORT_HASH}')dnl
define(\`VCS_WC_MODIFIED', \`${VCS_WC_MODIFIED}')dnl
EOF
}

# For (La)TeX output
texOutput() {
	case "${VCS_WC_MODIFIED}" in
		0) VCS_WC_MODIFIED="false" ;;
		1) VCS_WC_MODIFIED="true" ;;
	esac
	cat > "${TARGETFILE}" << EOF
% Generated by autorevision - do not hand-hack!
\def \vcsType {${VCS_TYPE}}
\def \vcsBasename {${VCS_BASENAME}}
\def \vcsUUID {${VCS_UUID}}
\def \vcsNum {${VCS_NUM}}
\def \vcsDate {${VCS_DATE}}
\def \vcsBranch {${VCS_BRANCH}}
\def \vcsTag {${VCS_TAG}}
\def \vcsTick {${VCS_TICK}}
\def \vcsExtra {${VCS_EXTRA}}
\def \vcsACTIONSTAMP {${VCS_ACTION_STAMP}}
\def \vcsFullHash {${VCS_FULL_HASH}}
\def \vcsShortHash {${VCS_SHORT_HASH}}
\def \vcsWCModified {${VCS_WC_MODIFIED}}
\endinput
EOF
}

# For scheme output
schemeOutput() {
	case "${VCS_WC_MODIFIED}" in
		0) VCS_WC_MODIFIED="#f" ;;
		1) VCS_WC_MODIFIED="#t" ;;
	esac
	cat > "${TARGETFILE}" << EOF
;; Generated by autorevision - do not hand-hack!
(define VCS_TYPE        "${VCS_TYPE}")
(define VCS_BASENAME    "${VCS_BASENAME}")
(define VCS_UUID        "${VCS_UUID}")
(define VCS_NUM         ${VCS_NUM})
(define VCS_DATE        "${VCS_DATE}")
(define VCS_BRANCH      "${VCS_BRANCH}")
(define VCS_TAG         "${VCS_TAG}")
(define VCS_TICK        ${VCS_TICK})
(define VCS_EXTRA       "${VCS_EXTRA}")

(define VCS_ACTION_STAMP   "${VCS_ACTION_STAMP}")
(define VCS_FULL_HASH   "${VCS_FULL_HASH}")
(define VCS_SHORT_HASH  "${VCS_SHORT_HASH}")

(define VCS_WC_MODIFIED ${VCS_WC_MODIFIED})
;; end
EOF
}

# For clojure output
clojureOutput() {
	case "${VCS_WC_MODIFIED}" in
		0) VCS_WC_MODIFIED="false" ;;
		1) VCS_WC_MODIFIED="true" ;;
	esac
	cat > "${TARGETFILE}" << EOF
;; Generated by autorevision - do not hand-hack!
(def VCS_TYPE        "${VCS_TYPE}")
(def VCS_BASENAME    "${VCS_BASENAME}")
(def VCS_UUID        "${VCS_UUID}")
(def VCS_NUM         ${VCS_NUM})
(def VCS_DATE        "${VCS_DATE}")
(def VCS_BRANCH      "${VCS_BRANCH}")
(def VCS_TAG         "${VCS_TAG}")
(def VCS_TICK        ${VCS_TICK})
(def VCS_EXTRA       "${VCS_EXTRA}")

(def VCS_ACTION_STAMP   "${VCS_ACTION_STAMP}")
(def VCS_FULL_HASH      "${VCS_FULL_HASH}")
(def VCS_SHORT_HASH     "${VCS_SHORT_HASH}")

(def VCS_WC_MODIFIED ${VCS_WC_MODIFIED})
;; end
EOF
}

# For rpm spec file output
rpmOutput() {
	cat > "${TARGETFILE}" << EOF
# Generated by autorevision - do not hand-hack!
$([ "${VCS_TYPE}" ] && echo "%define vcs_type		${VCS_TYPE}")
$([ "${VCS_BASENAME}" ] && echo "%define vcs_basename		${VCS_BASENAME}")
$([ "${VCS_UUID}" ] && echo "%define vcs_uuid		${VCS_UUID}")
$([ "${VCS_NUM}" ] && echo "%define vcs_num			${VCS_NUM}")
$([ "${VCS_DATE}" ] && echo "%define vcs_date		${VCS_DATE}")
$([ "${VCS_BRANCH}" ] && echo "%define vcs_branch		${VCS_BRANCH}")
$([ "${VCS_TAG}" ] && echo "%define vcs_tag			${VCS_TAG}")
$([ "${VCS_TICK}" ] && echo "%define vcs_tick		${VCS_TICK}")
$([ "${VCS_EXTRA}" ] && echo "%define vcs_extra		${VCS_EXTRA}")

$([ "${VCS_ACTION_STAMP}" ] && echo "%define vcs_action_stamp		${VCS_ACTION_STAMP}")
$([ "${VCS_FULL_HASH}" ] && echo "%define vcs_full_hash		${VCS_FULL_HASH}")
$([ "${VCS_SHORT_HASH}" ] && echo "%define vcs_short_hash		${VCS_SHORT_HASH}")

$([ "${VCS_WC_MODIFIED}" ] && echo "%define vcs_wc_modified		${VCS_WC_MODIFIED}")
# end
EOF
}

# shellcheck disable=SC2155,SC2039
hppOutput() {
	local NAMESPACE="$(echo "${VCS_BASENAME}" | sed -e 's:_::g' | tr '[:lower:]' '[:upper:]')"
	cat > "${TARGETFILE}" << EOF
/* Generated by autorevision - do not hand-hack! */

#ifndef ${NAMESPACE}_AUTOREVISION_H
#define ${NAMESPACE}_AUTOREVISION_H

namespace $(echo "${NAMESPACE}" | tr '[:upper:]' '[:lower:]')
{
	const std::string VCS_TYPE		= "${VCS_TYPE}";
	const std::string VCS_BASENAME	= "${VCS_BASENAME}";
	const std::string VCS_UUID		= "${VCS_UUID}";
	const int VCS_NUM				= ${VCS_NUM};
	const std::string VCS_DATE		= "${VCS_DATE}";
	const std::string VCS_BRANCH	= "${VCS_BRANCH}";
	const std::string VCS_TAG		= "${VCS_TAG}";
	const int VCS_TICK				= ${VCS_TICK};
	const std::string VCS_EXTRA		= "${VCS_EXTRA}";

	const std::string VCS_ACTION_STAMP	= "${VCS_ACTION_STAMP}";
	const std::string VCS_FULL_HASH		= "${VCS_FULL_HASH}";
	const std::string VCS_SHORT_HASH	= "${VCS_SHORT_HASH}";

	const int VCS_WC_MODIFIED			= ${VCS_WC_MODIFIED};
}

#endif

/* end */
EOF
}

matlabOutput() {
	case "${VCS_WC_MODIFIED}" in
		0) VCS_WC_MODIFIED="FALSE" ;;
		1) VCS_WC_MODIFIED="TRUE" ;;
	esac
	cat > "${TARGETFILE}" << EOF
% Generated by autorevision - do not hand-hack!

VCS_TYPE = '${VCS_TYPE}';
VCS_BASENAME = '${VCS_BASENAME}';
VCS_UUID = '${VCS_UUID}';
VCS_NUM = ${VCS_NUM};
VCS_DATE = '${VCS_DATE}';
VCS_BRANCH = '${VCS_BRANCH}';
VCS_TAG = '${VCS_TAG}';
VCS_TICK = ${VCS_TICK};
VCS_EXTRA = '${VCS_EXTRA}';

VCS_ACTION_STAMP = '${VCS_ACTION_STAMP}';
VCS_FULL_HASH = '${VCS_FULL_HASH}';
VCS_SHORT_HASH = '${VCS_SHORT_HASH}';

VCS_WC_MODIFIED = ${VCS_WC_MODIFIED};

% end
EOF
}

octaveOutput() {
	cat > "${TARGETFILE}" << EOF
% Generated by autorevision - do not hand-hack!

VCS_TYPE = '${VCS_TYPE}';
VCS_BASENAME = '${VCS_BASENAME}';
VCS_UUID = '${VCS_UUID}';
VCS_NUM = ${VCS_NUM};
VCS_DATE = '${VCS_DATE}';
VCS_BRANCH = '${VCS_BRANCH}';
VCS_TAG = '${VCS_TAG}';
VCS_TICK = ${VCS_TICK};
VCS_EXTRA = '${VCS_EXTRA}';

VCS_ACTION_STAMP = '${VCS_ACTION_STAMP}';
VCS_FULL_HASH = '${VCS_FULL_HASH}';
VCS_SHORT_HASH = '${VCS_SHORT_HASH}';

VCS_WC_MODIFIED = ${VCS_WC_MODIFIED};

% end
EOF
}


# Helper functions
# Count path segments
# shellcheck disable=SC2039
pathSegment() {
	local pathz="${1}"
	local depth="0"

	if [ ! -z "${pathz}" ]; then
		# Continue until we are at / or there are no path separators left.
		while [ ! "${pathz}" = "/" ] && [ ! "${pathz}" = "$(echo "${pathz}" | sed -e 's:/::')" ]; do
			pathz="$(dirname "${pathz}")"
			depth="$((depth+1))"
		done
	fi
	echo "${depth}"
}

# Largest of four numbers
# shellcheck disable=SC2039
multiCompare() {
	local larger="${1}"
	local numA="${2}"
	local numB="${3}"
	local numC="${4}"

	[ "${numA}" -gt "${larger}" ] && larger="${numA}"
	[ "${numB}" -gt "${larger}" ] && larger="${numB}"
	[ "${numC}" -gt "${larger}" ] && larger="${numC}"
	echo "${larger}"
}

# Test for repositories
# shellcheck disable=SC2155,SC2039
repoTest() {
	REPONUM="0"
	if [ ! -z "$(git rev-parse HEAD 2>/dev/null)" ]; then
		local gitPath="$(git rev-parse --show-toplevel)"
		local gitDepth="$(pathSegment "${gitPath}")"
		REPONUM="$((REPONUM+1))"
	else
		local gitDepth="0"
	fi
	if [ ! -z "$(hg root 2>/dev/null)" ]; then
		local hgPath="$(hg root 2>/dev/null)"
		local hgDepth="$(pathSegment "${hgPath}")"
		REPONUM="$((REPONUM+1))"
	else
		local hgDepth="0"
	fi
	if [ ! -z "$(bzr root 2>/dev/null)" ]; then
		local bzrPath="$(bzr root 2>/dev/null)"
		local bzrDepth="$(pathSegment "${bzrPath}")"
		REPONUM="$((REPONUM+1))"
	else
		local bzrDepth="0"
	fi
	if [ ! -z "$(svn info 2>/dev/null)" ]; then
		local stringz="<wcroot-abspath>"
		local stringx="</wcroot-abspath>"
		local svnPath="$(svn info --xml | sed -n -e "s:${stringz}::" -e "s:${stringx}::p")"
		# An old enough svn will not be able give us a path; default
		# to 1 for that case.
		if [ -z  "${svnPath}" ]; then
			local svnDepth="1"
		else
			local svnDepth="$(pathSegment "${svnPath}")"
		fi
		REPONUM="$((REPONUM+1))"
	else
		local svnDepth="0"
	fi

	# Do not do more work then we have to.
	if [ "${REPONUM}" = "0" ]; then
		return
	fi

	# Figure out which repo is the deepest and use it.
	local wonRepo="$(multiCompare "${gitDepth}" "${hgDepth}" "${bzrDepth}" "${svnDepth}")"
	if [ "${wonRepo}" = "${gitDepth}" ]; then
		gitRepo
	elif [ "${wonRepo}" = "${hgDepth}" ]; then
		hgRepo
	elif [ "${wonRepo}" = "${bzrDepth}" ]; then
		bzrRepo
	elif [ "${wonRepo}" = "${svnDepth}" ]; then
		svnRepo
	fi
}



# Detect which repos we are in and gather data.
# shellcheck source=/dev/null
if [ -f "${CACHEFILE}" ] && [ "${CACHEFORCE}" = "1" ]; then
	# When requested only read from the cache to populate our symbols.
	. "${CACHEFILE}"
else
	# If a value is not set through the environment set VCS_EXTRA to nothing.
	: "${VCS_EXTRA:=""}"
	repoTest

	if [ -f "${CACHEFILE}" ] && [ "${REPONUM}" = "0" ]; then
		# We are not in a repo; try to use a previously generated cache to populate our symbols.
		. "${CACHEFILE}"
		# Do not overwrite the cache if we know we are not going to write anything new.
		CACHEFORCE="1"
	elif [ "${REPONUM}" = "0" ]; then
		echo "error: No repo or cache detected." 1>&2
		exit 1
	fi
fi


# -s output is handled here.
if [ ! -z "${VAROUT}" ]; then
	if [ "${VAROUT}" = "VCS_TYPE" ]; then
		echo "${VCS_TYPE}"
	elif [ "${VAROUT}" = "VCS_BASENAME" ]; then
		echo "${VCS_BASENAME}"
	elif [ "${VAROUT}" = "VCS_NUM" ]; then
		echo "${VCS_NUM}"
	elif [ "${VAROUT}" = "VCS_DATE" ]; then
		echo "${VCS_DATE}"
	elif [ "${VAROUT}" = "VCS_BRANCH" ]; then
		echo "${VCS_BRANCH}"
	elif [ "${VAROUT}" = "VCS_TAG" ]; then
		echo "${VCS_TAG}"
	elif [ "${VAROUT}" = "VCS_TICK" ]; then
		echo "${VCS_TICK}"
	elif [ "${VAROUT}" = "VCS_FULL_HASH" ]; then
		echo "${VCS_FULL_HASH}"
	elif [ "${VAROUT}" = "VCS_SHORT_HASH" ]; then
		echo "${VCS_SHORT_HASH}"
	elif [ "${VAROUT}" = "VCS_WC_MODIFIED" ]; then
		echo "${VCS_WC_MODIFIED}"
	elif [ "${VAROUT}" = "VCS_ACTION_STAMP" ]; then
		echo "${VCS_ACTION_STAMP}"
	else
		echo "error: Not a valid output symbol." 1>&2
		exit 1
	fi
fi


# Detect requested output type and use it.
if [ ! -z "${AFILETYPE}" ]; then
	if [ "${AFILETYPE}" = "c" ]; then
		cOutput
	elif [ "${AFILETYPE}" = "h" ]; then
		hOutput
	elif [ "${AFILETYPE}" = "xcode" ]; then
		xcodeOutput
	elif [ "${AFILETYPE}" = "swift" ]; then
		swiftOutput
	elif [ "${AFILETYPE}" = "sh" ]; then
		shOutput
	elif [ "${AFILETYPE}" = "py" ] || [ "${AFILETYPE}" = "python" ]; then
		pyOutput
	elif [ "${AFILETYPE}" = "pl" ] || [ "${AFILETYPE}" = "perl" ]; then
		plOutput
	elif [ "${AFILETYPE}" = "lua" ]; then
		luaOutput
	elif [ "${AFILETYPE}" = "php" ]; then
		phpOutput
	elif [ "${AFILETYPE}" = "ini" ]; then
		iniOutput
	elif [ "${AFILETYPE}" = "js" ]; then
		jsOutput
	elif [ "${AFILETYPE}" = "json" ]; then
		jsonOutput
	elif [ "${AFILETYPE}" = "java" ]; then
		javaOutput
	elif [ "${AFILETYPE}" = "javaprop" ]; then
		javapropOutput
	elif [ "${AFILETYPE}" = "tex" ]; then
		texOutput
	elif [ "${AFILETYPE}" = "m4" ]; then
		m4Output
	elif [ "${AFILETYPE}" = "scheme" ]; then
		schemeOutput
	elif [ "${AFILETYPE}" = "clojure" ]; then
		clojureOutput
	elif [ "${AFILETYPE}" = "rpm" ]; then
		rpmOutput
	elif [ "${AFILETYPE}" = "hpp" ]; then
		hppOutput
	elif [ "${AFILETYPE}" = "matlab" ]; then
		matlabOutput
	elif [ "${AFILETYPE}" = "octave" ]; then
		octaveOutput
	else
		echo "error: Not a valid output type." 1>&2
		exit 1
	fi
fi


# If requested, make a cache file.
if [ ! -z "${CACHEFILE}" ] && [ ! "${CACHEFORCE}" = "1" ]; then
	TARGETFILE="${CACHEFILE}.tmp"
	shOutput

	# Check to see if there have been any actual changes.
	if [ ! -f "${CACHEFILE}" ]; then
		mv -f "${CACHEFILE}.tmp" "${CACHEFILE}"
	elif cmp -s "${CACHEFILE}.tmp" "${CACHEFILE}"; then
		rm -f "${CACHEFILE}.tmp"
	else
		mv -f "${CACHEFILE}.tmp" "${CACHEFILE}"
	fi
fi

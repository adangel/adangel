#!/usr/bin/env bash

if [ -z "$GITHUB_TOKEN" ]; then
    echo "WARNING: No env var GITHUB_TOKEN specified, requests might fail due to rate limiting" >&2
    CURL_HEADER=()
else
    CURL_HEADER=(-H "Authorization: token $GITHUB_TOKEN")
fi

function latest_release() {
    owner="$1"
    repo="$2"
    prefix="$3"
    if [ -n "${prefix}" ]; then prefix="${prefix} "; fi
    RELEASE=$(curl "${CURL_HEADER[@]}" --silent --show-error "https://api.github.com/repos/$owner/$repo/releases/latest")
    release_date="$(echo "$RELEASE"|jq -r .published_at|cut -d T -f 1)"
    echo -e "$release_date\t*   [${prefix}$(echo "$RELEASE" | jq -r ".name")]($(echo "$RELEASE" | jq -r ".html_url")) - $release_date"
}

all_releases=$(
latest_release pmd pmd
latest_release pmd pmd-eclipse-plugin
latest_release pmd pmd-github-action "GitHub Action for PMD"
latest_release EasyScreenCast EasyScreenCast EasyScreenCast
latest_release liquibase liquibase-percona liquibase-percona
latest_release adangel chunk-php
latest_release apache maven-pmd-plugin "Maven PMD Plugin"
)
all_releases=$(echo "$all_releases" | sort --reverse | cut -f 2)


filename="README.md"
start_line=$(grep -n "#### 🚀 Recent releases ..." "$filename" | cut -d : -f 1)
header=$(head -n $start_line "$filename")
end_line=$(grep -n "#### 🌱 I'm currently learning ..." "$filename" | cut -d : -f 1)
footer=$(tail -n +$end_line "$filename")

echo "$header

$all_releases

$footer" > "$filename"

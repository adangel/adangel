#!/usr/bin/env bash

function latest_release() {
    owner="$1"
    repo="$2"
    prefix="$3"
    if [ -n "${prefix}" ]; then prefix="${prefix} "; fi
    RELEASE=$(curl --silent "https://api.github.com/repos/$owner/$repo/releases?per_page=1"|jq ".[0]")
    echo "*   [${prefix}$(echo "$RELEASE" | jq -r ".name")]($(echo "$RELEASE" | jq -r ".html_url")) - $(echo "$RELEASE"|jq -r .published_at|cut -d T -f 1)"
}

latest_release pmd pmd
latest_release pmd pmd-eclipse-plugin
latest_release pmd pmd-github-action "GitHub Action for PMD"
latest_release EasyScreenCast EasyScreenCast EasyScreenCast
latest_release liquibase liquibase-percona liquibase-percona
latest_release adangel chunk-php

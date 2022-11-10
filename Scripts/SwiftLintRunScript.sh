#!/bin/sh

#  SwiftLintRunScript.sh
#  Manifests
#
#  Created by 김세영 on 2022/11/10.
#

export PATH="$PATH:/opt/homebrew/bin"
if which swiftlint >/dev/null; then
    swiftlint
else
    echo "warning: SwiftLint not installed, download form https://github.com/realm/SwiftLint"
fi

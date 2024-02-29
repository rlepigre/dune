#!/bin/bash

# Reset to the version tag, to allow re-running the script.
mv script.sh script.sh.backup
git reset --hard 3.14.0
mv script.sh.backup script.sh

# Merge #10155: [coq] Fix performance regression in coqdep unescaping.
git cherry-pick -m 1 6d741e00b5c2fe3be19b84104774b67d32b7d72a

# Merge #9845: [coq] Delay boot type detection.
git cherry-pick -m 1 189a517e061f1e37c27a7b75e8d6f58172ebfb46

# Merge #10116: [coq] Memoize coqdep parsing.
git cherry-pick -m 1 42a203a8970e7cf6b59fd5db8d4d8d0aab3df9da

# Fix #10149: all coq files rebuilt after deps change.
git cherry-pick ffe84adcce14591e359c51212a840a85ed966871

# Recording the script.
git add script.sh
git commit \
  -m "Cherry-picking script used to create this branch." \
  --author "Rodolphe Lepigre <rodolphe@bedrocksystems.com>"

 Tagging and pushing.
TAG="3.14.0+bedrock"
git tag -f "$TAG"
git push --force-with-lease
git push -f --tags

echo "Sleeping for 10 seconds..."
sleep 10

wget "https://github.com/rlepigre/dune/archive/refs/tags/$TAG.tar.gz"

echo "md5=$(md5sum "$TAG.tar.gz" | cut -d' ' -f1)"
echo "sha256=$(sha256sum "$TAG.tar.gz" | cut -d' ' -f1)"
echo "sha512=$(sha512sum "$TAG.tar.gz" | cut -d' ' -f1)"
rm "$TAG.tar.gz"

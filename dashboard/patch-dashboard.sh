#!/bin/bash

echo "Patching Saleor Dashboard to re-enable App Store..."

# 1. Patch sidebar navigation to add App Store link
SIDEBAR_FILE="src/navigation/fixtures.ts"

if grep -q "App Store" "$SIDEBAR_FILE"; then
  echo "App Store link already patched in sidebar."
else
  sed -i '/Installed Apps/a\
  { label: "App Store", url: "/apps/app-store", permissions: [] },' "$SIDEBAR_FILE"
  echo "Patched App Store link into sidebar."
fi

# 2. Create App Store page route if not exist
APPSTORE_PAGE="src/pages/apps/app-store.tsx"

if [ ! -f "$APPSTORE_PAGE" ]; then
  mkdir -p src/pages/apps
  cat <<EOF > "$APPSTORE_PAGE"
import { AppsPage } from "../apps";

export default AppsPage;
EOF
  echo "Created App Store route page."
else
  echo "App Store route page already exists."
fi

echo "Patch complete."

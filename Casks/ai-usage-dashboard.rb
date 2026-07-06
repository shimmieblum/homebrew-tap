# Canonical Homebrew cask for AI Usage Dashboard.
#
# This file is the source of truth. On each release it is copied into the public
# tap repo (github.com/shimmieblum/homebrew-tap) at Casks/ai-usage-dashboard.rb,
# with `version` and `sha256` updated for the new release. See docs/RELEASING.md.
#
# The app is unsigned (ad-hoc signature only, no Apple notarization). macOS
# Gatekeeper would block a quarantined download, so the postflight below strips
# the com.apple.quarantine attribute after install. arm64-only.
cask "ai-usage-dashboard" do
  version "0.3.0"
  sha256 "01a9cd9a8944e006066222280d53825c712811b38d61884648b7b46ddb111b6b"

  # DMG asset is hosted on the PUBLIC tap repo's releases so the source repo
  # (shimmieblum/ai-dashboard) can stay private while brew still downloads it.
  url "https://github.com/shimmieblum/homebrew-tap/releases/download/v#{version}/AI-Usage-Dashboard-#{version}-arm64.dmg"
  name "AI Usage Dashboard"
  desc "macOS menu-bar dashboard for Claude / Codex / OpenRouter usage"
  homepage "https://github.com/shimmieblum/ai-dashboard"

  depends_on arch: :arm64
  depends_on macos: ">= :big_sur"

  app "AI Usage Dashboard.app"

  # Unsigned/ad-hoc app: strip quarantine so Gatekeeper doesn't block launch.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/AI Usage Dashboard.app"]
  end

  # Removes app-specific data only. The OpenRouter key lives in
  # secrets.json under Application Support (safeStorage). The Claude token is
  # deliberately NOT touched — it's read from the shared "Claude Code-credentials"
  # Keychain entry owned by Claude Code, not created by this app.
  zap trash: [
    "~/Library/Application Support/AI Usage Dashboard",
    "~/Library/Preferences/com.simonblum.ai-usage-dashboard.plist",
    "~/Library/Saved Application State/com.simonblum.ai-usage-dashboard.savedState",
    "~/Library/Logs/AI Usage Dashboard",
  ]
end

class ClaudeProfiles < Formula
  desc "Launch claude with only the plugins, skills, and MCP servers a profile defines"
  homepage "https://github.com/fuzzyalej/claude-profile"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fuzzyalej/claude-profile/releases/download/v0.7.0/claude-profiles-aarch64-apple-darwin.tar.xz"
      sha256 "a43cd04d4da557882abf6b4a25d88449c6c95cbfe564e77f4402eb7b8509dbb9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fuzzyalej/claude-profile/releases/download/v0.7.0/claude-profiles-x86_64-apple-darwin.tar.xz"
      sha256 "a62c3c7f36905464658a8eabef2ac0db86550ddd62d4c55306ac64d19018cfd6"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/fuzzyalej/claude-profile/releases/download/v0.7.0/claude-profiles-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "fd4b86e785ead27288de405fb1e33cb8d72aeea56993ca924ed86c57f1a0088f"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "claude-profile"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "claude-profile"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "claude-profile"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

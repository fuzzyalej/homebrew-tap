class ClaudeProfiles < Formula
  desc "Launch claude with only the plugins, skills, and MCP servers a profile defines"
  homepage "https://github.com/fuzzyalej/claude-profile"
  version "0.8.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fuzzyalej/claude-profile/releases/download/v0.8.1/claude-profiles-aarch64-apple-darwin.tar.xz"
      sha256 "bc6902b65dc2f75537e0f66dffba9c874b1cbf71e8a7facd402fc82f892c737d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fuzzyalej/claude-profile/releases/download/v0.8.1/claude-profiles-x86_64-apple-darwin.tar.xz"
      sha256 "619ed5e8b2d542a976202489fc71bbfaedf779e6cd62ec530f3afa1b6027aa14"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/fuzzyalej/claude-profile/releases/download/v0.8.1/claude-profiles-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "054a9e2e6e33d1f4eafc5b7ce220794d20e569454cba3c4b6b1f3712e6d5ba89"
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

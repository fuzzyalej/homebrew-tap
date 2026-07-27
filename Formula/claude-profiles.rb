class ClaudeProfiles < Formula
  desc "Launch claude with only the plugins, skills, and MCP servers a profile defines"
  homepage "https://github.com/fuzzyalej/claude-profile"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fuzzyalej/claude-profile/releases/download/v0.5.0/claude-profiles-aarch64-apple-darwin.tar.xz"
      sha256 "422a2b3eea51eb44417379ef43d336243baa529d376a15f91b5a04095743228b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fuzzyalej/claude-profile/releases/download/v0.5.0/claude-profiles-x86_64-apple-darwin.tar.xz"
      sha256 "5fc919e6d69a09dc22fab1ec1b44b735655169962de5603fc4700e70c1917abe"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/fuzzyalej/claude-profile/releases/download/v0.5.0/claude-profiles-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "fbcb5159aa6934b5b503e679ef60121726b7bd42b526e39bae8b08baba57fc3a"
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
    bin.install "claude-profile" if OS.mac? && Hardware::CPU.arm?
    bin.install "claude-profile" if OS.mac? && Hardware::CPU.intel?
    bin.install "claude-profile" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

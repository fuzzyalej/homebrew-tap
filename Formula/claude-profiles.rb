class ClaudeProfiles < Formula
  desc "Launch claude with only the plugins, skills, and MCP servers a profile defines"
  homepage "https://github.com/fuzzyalej/claude-profile"
  version "0.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fuzzyalej/claude-profile/releases/download/v0.5.1/claude-profiles-aarch64-apple-darwin.tar.xz"
      sha256 "899046a0e8a7f52407b0dbc3483b8f43c2f26dfa059cd8b7f50c2a3b91562f38"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fuzzyalej/claude-profile/releases/download/v0.5.1/claude-profiles-x86_64-apple-darwin.tar.xz"
      sha256 "5d75a4cdd706be5a3c624fbddaed448e216b57c30bbefd19cc904d7d5cec1b0e"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/fuzzyalej/claude-profile/releases/download/v0.5.1/claude-profiles-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "e7a7be00dafe8556186011bc08057107e67f1fbc485804a6f3c7fb47ef8d80a6"
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

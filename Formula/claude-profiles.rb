class ClaudeProfiles < Formula
  desc "Launch claude with only the plugins, skills, and MCP servers a profile defines"
  homepage "https://github.com/fuzzyalej/claude-profile"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fuzzyalej/claude-profile/releases/download/v0.6.0/claude-profiles-aarch64-apple-darwin.tar.xz"
      sha256 "198636c6c0d93ac9c9d4bdcfade4b92a99d5aecd273f3567edbaaf13d2cd39e6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fuzzyalej/claude-profile/releases/download/v0.6.0/claude-profiles-x86_64-apple-darwin.tar.xz"
      sha256 "b4cc18b525ddd5edbb899c809333f4c10b28240ef2f79da303e59cf4b5fb03a3"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/fuzzyalej/claude-profile/releases/download/v0.6.0/claude-profiles-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "d3fe475fc9f9330490f37bfaaee9a1ae9d9e2342da7dd92ca8002f77296a2ab2"
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

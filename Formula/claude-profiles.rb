class ClaudeProfiles < Formula
  desc "Launch claude with only the plugins, skills, and MCP servers a profile defines"
  homepage "https://github.com/fuzzyalej/claude-profile"
  version "0.4.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fuzzyalej/claude-profile/releases/download/v0.4.2/claude-profiles-aarch64-apple-darwin.tar.xz"
      sha256 "751218ab4c69079ae84fbaeeb335bba155d1a6886f298563a02f3f3587e9df68"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fuzzyalej/claude-profile/releases/download/v0.4.2/claude-profiles-x86_64-apple-darwin.tar.xz"
      sha256 "565ef181863ee76fac42a6128406cea884396c427ffbd788fd0a8ef158fb2323"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/fuzzyalej/claude-profile/releases/download/v0.4.2/claude-profiles-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "5f992f0b1bd6e9523f145956d38ea0a01ae71e6319107458cc2337609e58adea"
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

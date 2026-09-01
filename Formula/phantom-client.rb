class PhantomClient < Formula
  desc "Phantom Chat desktop client"
  homepage "https://github.com/gothLinus/phantom-chat"
  version "0.2.9"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/gothLinus/phantom-chat-releases/releases/download/v0.2.9/phantom-client-aarch64-apple-darwin.tar.xz"
    sha256 "a4aafe9bc7b71b81c926f5d5f80bf25c008917088f4d1674fa2e0ef4954d942a"
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
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
      bin.install "phantom-client"
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

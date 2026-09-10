class PhantomClient < Formula
  desc "Phantom Chat desktop client"
  homepage "https://github.com/gothLinus/phantom-chat"
  version "0.2.10"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/gothLinus/phantom-chat-releases/releases/download/v0.2.10/phantom-client-aarch64-apple-darwin.tar.xz"
    sha256 "51ef4ab5ea0eadbdb6cfd45b49be355325138cf65985532ba950c28ce35def8b"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gothLinus/phantom-chat-releases/releases/download/v0.2.10/phantom-client-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e3978463cef65c7315d0792607df0bf9515667f746ad6561922f7033ab59778d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gothLinus/phantom-chat-releases/releases/download/v0.2.10/phantom-client-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a522df70335f9c8dd8a9bdc63056d6dd403af91bdc255deeb17d3e4124efd11c"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-gnu":  {},
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
    if OS.linux? && Hardware::CPU.arm?
      bin.install "phantom-client"
    end
    if OS.linux? && Hardware::CPU.intel?
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

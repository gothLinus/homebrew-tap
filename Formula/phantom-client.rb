class PhantomClient < Formula
  desc "Phantom Chat desktop client"
  homepage "https://github.com/gothLinus/phantom-chat"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gothLinus/phantom-chat-releases/releases/download/phantom-client-0.1.2/phantom-client-aarch64-apple-darwin.tar.xz"
      sha256 "3e8398ac0990ceae8b0ec2e52d820173df59051571bc89b73abbf1e3d85a36c7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gothLinus/phantom-chat-releases/releases/download/phantom-client-0.1.2/phantom-client-x86_64-apple-darwin.tar.xz"
      sha256 "ce08e12200bfc7b9da89af946ec2d09d834cbd9ddf3e47ef9cd8f13d3ef56be7"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/gothLinus/phantom-chat-releases/releases/download/phantom-client-0.1.2/phantom-client-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "e05daf122a25e4aaccab21425a378148f0513467dea32de4875f3bdc293809ab"
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
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
      bin.install "phantom-client"
    end
    if OS.mac? && Hardware::CPU.intel?
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

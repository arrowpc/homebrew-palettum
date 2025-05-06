class Palettum < Formula
  desc "CLI tool that recolors images & GIFs with any palette"
  homepage "https://github.com/ArrowPC/palettum/"
  license "AGPL-3.0-only"
  version "0.5.0"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/arrowpc/palettum/releases/download/v0.5.0/palettum-macOS-x86_64.tar.gz"
      sha256 "c16579a9da5a1fe324c8d787cf310d2480f1957820aa918324ed6a9cae51978c"
    end

    if Hardware::CPU.arm?
      url "https://github.com/arrowpc/palettum/releases/download/v0.5.0/palettum-macOS-arm64.tar.gz"
      sha256 "a9023e3419b53ed3c9ebe8b58e49b30d6c0798c65e29a2f1f4292025b9181b6e"
    end
  end

  def install
    bin.install "palettum"
  end

  test do
    assert_match "palettum #{version}", shell_output("#{bin}/palettum --version")
  end
end

class Palettum < Formula
  desc "CLI tool that recolors images & GIFs with any palette"
  homepage "https://github.com/ArrowPC/palettum/"
  license "AGPL-3.0-only"
  version "0.5.1"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/arrowpc/palettum/releases/download/v0.5.1/palettum-macOS-x86_64.tar.gz"
      sha256 "90eb5c2247211f6ef7013cdec4dba4cbce175dc0b5c02ca76e9499ec54a9e1cc"
    end

    if Hardware::CPU.arm?
      url "https://github.com/arrowpc/palettum/releases/download/v0.5.1/palettum-macOS-arm64.tar.gz"
      sha256 "2e926f74f8f9234200d1a077a7d0780d2f53c5c740a876b50e962fb18f799cfd"
    end
  end

  def install
    bin.install "palettum"
  end

  test do
    assert_match "palettum #{version}", shell_output("#{bin}/palettum --version")
  end
end

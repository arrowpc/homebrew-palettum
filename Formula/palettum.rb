class Palettum < Formula
  desc "CLI tool that recolors images & GIFs with any palette"
  homepage "https://github.com/ArrowPC/palettum/"
  license "AGPL-3.0-only"
  version "0.5.2"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/arrowpc/palettum/releases/download/v0.5.2/palettum-macOS-x86_64.tar.gz"
      sha256 "18cd88844063edd6157a84f282d2d1bc7de871c76cc007709898656d4efe453e"
    end

    if Hardware::CPU.arm?
      url "https://github.com/arrowpc/palettum/releases/download/v0.5.2/palettum-macOS-arm64.tar.gz"
      sha256 "4b9732ffea1110851a510bec30fd4adc5e9c532a76b5c7a57c66fcc7dc3c16eb"
    end
  end

  def install
    bin.install "palettum"
  end

  test do
    assert_match "palettum #{version}", shell_output("#{bin}/palettum --version")
  end
end

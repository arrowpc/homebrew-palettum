class Palettum < Formula
  desc "CLI tool that recolors images & GIFs with any palette"
  homepage "https://github.com/ArrowPC/palettum/"
  license "AGPL-3.0-only"
  version "0.6.1"

  depends_on "ffmpeg"
  depends_on "pkg-config"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/arrowpc/palettum/releases/download/v0.6.1/palettum-x86_64-apple-darwin-video-gpu.tar.gz"
      sha256 "982a3117e2f802486de2a130491639211486854c2b077dbae592bb8d1dfa6b91"
    end

    if Hardware::CPU.arm?
      url "https://github.com/arrowpc/palettum/releases/download/v0.6.1/palettum-aarch64-apple-darwin-video-gpu.tar.gz"
      sha256 "7e2b07790c74d46e3c780b8dd20e10ea728b38f7bffe879b39c535dac3619ea3"
    end
  end

  def install
    bin.install "palettum"
  end

  test do
    assert_match "palettum #{version}", shell_output("#{bin}/palettum --version")
  end
end

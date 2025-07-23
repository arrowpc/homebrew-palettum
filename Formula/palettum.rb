class Palettum < Formula
  desc "CLI tool that recolors images & GIFs with any palette"
  homepage "https://github.com/ArrowPC/palettum/"
  license "AGPL-3.0-only"
  version "0.6.0"

  depends_on "ffmpeg"
  depends_on "pkg-config"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/arrowpc/palettum/releases/download/v0.6.0/palettum-x86_64-apple-darwin-video-gpu.tar.gz"
      sha256 "06de4038090e734cad202f07bdaff9d6a9b62fe37ccfdd363a7aecc11e66102e"
    end

    if Hardware::CPU.arm?
      url "https://github.com/arrowpc/palettum/releases/download/v0.6.0/palettum-aarch64-apple-darwin-video-gpu.tar.gz"
      sha256 "982a3117e2f802486de2a130491639211486854c2b077dbae592bb8d1dfa6b91"
    end
  end

  def install
    bin.install "palettum"
  end

  test do
    assert_match "palettum #{version}", shell_output("#{bin}/palettum --version")
  end
end

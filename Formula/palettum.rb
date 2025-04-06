class Palettum < Formula
  desc "Core functionality for the Palettum project"
  homepage "https://github.com/ArrowPC/palettum/"
  url "https://files.pythonhosted.org/packages/53/4b/2bdae45ff251c4cf79cf3e2b9b163e81cd2bbbaa64c4aada025f309fdf83/palettum-0.4.8.tar.gz"
  sha256 "d831ffd4f075c9752cbd835c1537a5d9e7621bd21b74b0e10417048ac3d6b3a0"
  license "AGPL-3.0-only"

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "ninja" => :build
  depends_on "python@3.12"

  # Runtime C++ Dependencies
  depends_on "giflib"
  depends_on "jpeg-turbo"
  depends_on "libomp"
  depends_on "libpng"
  depends_on "webp"
  depends_on "simde"
  depends_on "pybind11"
  depends_on "zlib"

  # Python dependencies
  resource "rich-click" do
    url "https://files.pythonhosted.org/packages/fa/69/963f0bf44a654f6465bdb66fb5a91051b0d7af9f742b5bd7202607165036/rich_click-1.8.8-py3-none-any.whl"
    sha256 "205aabd5a98e64ab2c105dee9e368be27480ba004c7dfa2accd0ed44f9f1550e"
  end
  resource "click" do
    url "https://files.pythonhosted.org/packages/7e/d4/7ebdbd03970677812aac39c869717059dbb71a4cfc033ca6e5221787892c/click-8.1.8-py3-none-any.whl"
    sha256 "63c132bbbed01578a06712a2d1f497bb62d9c1c0d329b7903a866228027263b2"
  end
  resource "rich" do
    url "https://files.pythonhosted.org/packages/0d/9b/63f4c7ebc259242c89b3acafdb37b41d1185c07ff0011164674e9076b491/rich-14.0.0-py3-none-any.whl"
    sha256 "1c9491e1951aac09caffd42f448ee3d04e58923ffe14993f6e83068dc395d7e0"
  end
  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8a/0b/9fcc47d19c48b59121088dd6da2488a49d5f72dacf8262e2790a1d2c7d15/pygments-2.19.1-py3-none-any.whl"
    sha256 "9ea1544ad55cecf4b8242fab6dd35a93bbce657034b0611ee383099054ab6d8c"
  end
  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/42/d7/1ec15b46af6af88f19b8e5ffea08fa375d433c998b8a7639e76935c14f1f/markdown_it_py-3.0.0-py3-none-any.whl"
    sha256 "355216845c60bd96232cd8d8c40e8f9765cc86f46880e43a8fd22dc1a1a8cab1"
  end
  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/b3/38/89ba8ad64ae25be8de66a6d463314cf1eb366222074cfda9ee839c56a4b4/mdurl-0.1.2-py3-none-any.whl"
    sha256 "84008a41e51615a49fc9966191ff91509e3c40b939176e643fd50a5c2196b8f8"
  end
  resource "typing_extensions" do
    url "https://files.pythonhosted.org/packages/76/ad/cd3e3465232ec2416ae9b983f27b9e94dc8171d56ac99b345319a9475967/typing_extensions-4.13.1.tar.gz"
    sha256 "98795af00fb9640edec5b8e31fc647597b4691f099ad75f469a2616be1a76dff"
  end

  include Language::Python::Virtualenv

  def install
    giflib_prefix = Formula["giflib"].opt_prefix
    libpng_prefix = Formula["libpng"].opt_prefix
    ENV.prepend_path "PKG_CONFIG_PATH", "#{giflib_prefix}/lib/pkgconfig"
    ENV["GIFLIB_PREFIX"] = giflib_prefix.to_s
    ENV["GIF_LIBRARY"] = "#{giflib_prefix}/lib/libgif.dylib"
    ENV["GIF_INCLUDE_DIR"] = "#{giflib_prefix}/include"
    ENV["PNG_LIBRARY"] = "#{libpng_prefix}/lib/libpng.dylib"
    ENV["PNG_INCLUDE_DIR"] = "#{libpng_prefix}/include"

    python_version = "python3.12"
    venv = virtualenv_create(libexec, python_version)
    site_packages = Language::Python.site_packages(python_version)
    palettum_pkg_dir = libexec/site_packages/"palettum"

    resources.each do |r|
      venv.pip_install r
    end

    venv.pip_install buildpath

    dylib_name = "libmtpng.dylib"
    so_name = "palettum.cpython-#{Language::Python.major_minor_version(python_version).to_s.delete(".")}-darwin.so"
    installed_so_path = palettum_pkg_dir/so_name

    source_paths = [
      buildpath/"external/mtpng/target/release/deps"/dylib_name,
      buildpath/"external/mtpng/target/release"/dylib_name
    ]

    source_dylib_path = source_paths.find(&:exist?)
    if source_dylib_path
      target_dylib_path = palettum_pkg_dir/dylib_name
      cp source_dylib_path, target_dylib_path

      otool_output = Utils.safe_popen_read("otool", "-L", installed_so_path)
      bad_path_line = otool_output.lines.find { |line| line.include?(source_dylib_path.to_s) }

      if bad_path_line
        original_path = bad_path_line.strip.split(" ")[0]
        correct_path = "@loader_path/#{dylib_name}"

        system "install_name_tool", "-change", original_path, correct_path, installed_so_path

        system "install_name_tool", "-id", correct_path, target_dylib_path
      end
    end

    bin.install_symlink libexec/"bin/palettum"
  end

  test do
    assert_match "palettum, version #{version}\n", shell_output("#{bin}/palettum --version")
  end
end

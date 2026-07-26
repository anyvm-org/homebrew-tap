class Anyvm < Formula
  include Language::Python::Shebang

  desc "Run any VM anywhere: BSD, Illumos, and Linux guests with QEMU"
  homepage "https://github.com/anyvm-org/anyvm"
  url "https://files.pythonhosted.org/packages/ef/5e/5ce8324c4d0dc90300054af9d855a10e7b3ccba0913930660a17db47b61e/anyvm_py-0.5.3.tar.gz"
  sha256 "d71afc3a3db99001bb3715ea18d49e86241f9f7e676c20545ecfd8d55a8aa4fc"
  license "MIT"

  depends_on "python@3.14"
  depends_on "qemu"
  depends_on "zstd"

  def install
    # anyvm.py is a single self-contained stdlib-only script; install it
    # directly instead of building the wheel so no pip/build backend is
    # needed at install time.
    rewrite_shebang detected_python_shebang, "anyvm.py"
    bin.install "anyvm.py"
    bin.install_symlink bin/"anyvm.py" => "anyvm"
  end

  test do
    assert_match "--os", shell_output("#{bin}/anyvm --help")
  end
end

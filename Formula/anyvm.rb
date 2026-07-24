class Anyvm < Formula
  include Language::Python::Shebang

  desc "Run any VM anywhere: BSD, Illumos, and Linux guests with QEMU"
  homepage "https://github.com/anyvm-org/anyvm"
  url "https://files.pythonhosted.org/packages/b4/98/7d457a8102e869714c0c0639b50cd289aedc6782a50178c461c05a209c12/anyvm_py-0.5.2.tar.gz"
  sha256 "4ed957944324b639aa6cb2f9eae3d023e2a59be4c85f6d3c5a47fdd2b642f31f"
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

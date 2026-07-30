class Anyvm < Formula
  include Language::Python::Shebang

  desc "Run any VM anywhere: BSD, Illumos, and Linux guests with QEMU"
  homepage "https://github.com/anyvm-org/anyvm"
  url "https://files.pythonhosted.org/packages/57/d0/13107e9fe6934ed93ad3553fcc9af7520dfc57f90f7ae7d5d7accd4e8d96/anyvm_py-0.5.4.tar.gz"
  sha256 "7047b18adb610ea75bf90d402749c6c0c0be12c8d98de5f1e4ec998b7c982b7a"
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

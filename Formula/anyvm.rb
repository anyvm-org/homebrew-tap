class Anyvm < Formula
  include Language::Python::Shebang

  desc "Run any VM anywhere: BSD, Illumos, and Linux guests with QEMU"
  homepage "https://github.com/anyvm-org/anyvm"
  url "https://files.pythonhosted.org/packages/9f/c4/0ccbb0be9be6a5c1a94444b47c8936238a24169e5796c5a0d9b7ebd13e77/anyvm_py-0.5.5.tar.gz"
  sha256 "ff3cfc1f113e0139f726b57de76c7977519419a2c56a514022176378b544d323"
  license "MIT"

  depends_on "python@3.14"
  depends_on "qemu"
  depends_on "zstd"

  def install
    # anyvm.py is a single self-contained stdlib-only script; install it
    # directly instead of building the wheel so no pip/build backend is
    # needed at install time.
    rewrite_shebang detected_python_shebang, "anyvm.py"
    libexec.install "anyvm.py"
    # The sdist ships anyvm.py mode 0644. Homebrew's cleaner only chmods
    # shebang scripts to 0555 under bin/sbin/lib, never under libexec, so
    # the wrapper below would exec a non-executable file (EACCES).
    chmod 0755, libexec/"anyvm.py"

    # ANYVM_INSTALLED tells anyvm this copy came from a packager, so it keeps
    # its multi-GB images in the per-user cache instead of beside itself in
    # the Cellar, where the next upgrade would drop them. anyvm does not infer
    # this from its own path on purpose: that misreads a vendored copy or a
    # checkout that happens to sit under such a directory.
    (bin/"anyvm.py").write_env_script libexec/"anyvm.py", ANYVM_INSTALLED: "1"
    bin.install_symlink bin/"anyvm.py" => "anyvm"
  end

  test do
    assert_match "--os", shell_output("#{bin}/anyvm --help")
    # The wrapper must carry the marker; without it anyvm would write into the
    # Cellar and lose everything on the next upgrade.
    assert_match "ANYVM_INSTALLED", (bin/"anyvm.py").read
  end
end

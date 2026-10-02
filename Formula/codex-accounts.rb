class CodexAccounts < Formula
  desc "Per-terminal Codex accounts with shared local conversations"
  homepage "https://github.com/codeasy-digix/codex-accounts"
  version "0.2.0"
  license "MIT"

  depends_on "tmux"

  on_macos do
    on_arm do
      url "https://github.com/codeasy-digix/codex-accounts/releases/download/v0.2.0/codex-accounts_0.2.0_darwin_arm64.tar.gz"
      sha256 "962d5ebf62fcf5bda9f1a512ca1412d6061e24c00ffd3867b76536da2af0b9a3"

      resource "codex-runtime" do
        url "https://github.com/openai/codex/releases/download/rust-v0.159.3/codex-package-aarch64-apple-darwin.tar.gz"
        sha256 "fad57a5681cabcef21d322af5aec938975cfb711b5f25d4ce4907e6561616d07"
      end
    end
    on_intel do
      url "https://github.com/codeasy-digix/codex-accounts/releases/download/v0.2.0/codex-accounts_0.2.0_darwin_amd64.tar.gz"
      sha256 "c2916871f66c02f286f5fd3fc2a2da94d55abbdff2c974aa8498e0c4f034ec42"

      resource "codex-runtime" do
        url "https://github.com/openai/codex/releases/download/rust-v0.159.3/codex-package-x86_64-apple-darwin.tar.gz"
        sha256 "fe3096a62b5d8395dd25abf9fe79334cf13c1520b825d236cd2b41eb75a63201"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/codeasy-digix/codex-accounts/releases/download/v0.2.0/codex-accounts_0.2.0_linux_arm64.tar.gz"
      sha256 "40727661af5a8a36058b922f9d1121f108bfa31214bdf138e344e21b5b0870a9"

      resource "codex-runtime" do
        url "https://github.com/openai/codex/releases/download/rust-v0.159.3/codex-package-aarch64-unknown-linux-musl.tar.gz"
        sha256 "20b7d673cf2b64b6c6208fa4fda06feb9dac0572da9987294b48cde1dab9d001"
      end
    end
    on_intel do
      url "https://github.com/codeasy-digix/codex-accounts/releases/download/v0.2.0/codex-accounts_0.2.0_linux_amd64.tar.gz"
      sha256 "a7007903c49e67d6047e73ae7c6e0e1bbba9d2f0b9ba562c1303ed3d926edbd3"

      resource "codex-runtime" do
        url "https://github.com/openai/codex/releases/download/rust-v0.159.3/codex-package-x86_64-unknown-linux-musl.tar.gz"
        sha256 "3930f31ac5fca861ea3e444e2683f261190d96b63fba58e0a40a879174369cdf"
      end
    end
  end

  def install
    bin.install "codex-accounts"
    resource("codex-runtime").stage do
      (libexec/"codex").install Dir["*"]
    end
    (pkgshare/"licenses").install Dir["third_party/*"]
  end

  def caveats
    <<~EOS
      Ready to use: codex-accounts --account ryu

      For per-terminal 'codex account NAME', add ONE line to your shell profile:
        Zsh (~/.zshrc):  eval "$(codex-accounts shell-init zsh)"
        Bash (~/.bashrc): eval "$(codex-accounts shell-init bash)"

      Run: codex account NAME; codex account NAME default; codex account default
      Resume quota-interrupted conversations: codex continue
      Your existing conversations and account credentials are retained on uninstall.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codex-accounts --version")
    assert_match "codex-cli 0.159.3", shell_output("#{bin}/codex-accounts run --version")
    assert_match "codex_account()", shell_output("#{bin}/codex-accounts shell-init zsh")
    ENV["HOME"] = testpath.to_s
    %w[
      CODEX_ACCOUNT CODEX_HOME CODEX_SQLITE_HOME CODEX_SHARED_HOME CODEX_ACCOUNTS_DIR CODEX_ACCOUNTS_RUNTIME
    ].each do |key|
      ENV.delete(key)
    end
    assert_match "No registered accounts", shell_output("#{bin}/codex-accounts account --list")
    assert_match "not signed in", shell_output("#{bin}/codex-accounts account")
    assert_match "No quota-interrupted", shell_output("#{bin}/codex-accounts continue --list")
  end
end

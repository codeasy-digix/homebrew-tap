class CodexAccounts < Formula
  desc "Per-terminal Codex accounts with shared local conversations"
  homepage "https://github.com/codeasy-digix/codex-accounts"
  version "0.3.0"
  license "MIT"

  depends_on "tmux"

  on_macos do
    on_arm do
      url "https://github.com/codeasy-digix/codex-accounts/releases/download/v0.3.0/codex-accounts_0.3.0_darwin_arm64.tar.gz"
      sha256 "5c4e6620331646e84b8ceec8219fdd7039d9c3a6a92c3875854ef249b4b7b066"

      resource "codex-runtime" do
        url "https://github.com/openai/codex/releases/download/rust-v0.159.3/codex-package-aarch64-apple-darwin.tar.gz"
        sha256 "fad57a5681cabcef21d322af5aec938975cfb711b5f25d4ce4907e6561616d07"
      end
    end
    on_intel do
      url "https://github.com/codeasy-digix/codex-accounts/releases/download/v0.3.0/codex-accounts_0.3.0_darwin_amd64.tar.gz"
      sha256 "bdbe9f197fc73e007fd2454b376bb670a7960fb93fe330d103523460fb0ef3c4"

      resource "codex-runtime" do
        url "https://github.com/openai/codex/releases/download/rust-v0.159.3/codex-package-x86_64-apple-darwin.tar.gz"
        sha256 "fe3096a62b5d8395dd25abf9fe79334cf13c1520b825d236cd2b41eb75a63201"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/codeasy-digix/codex-accounts/releases/download/v0.3.0/codex-accounts_0.3.0_linux_arm64.tar.gz"
      sha256 "d4157b6319b1a30bec28693033ad0f94ac10ecda6a39719bf9055ec5c8816704"

      resource "codex-runtime" do
        url "https://github.com/openai/codex/releases/download/rust-v0.159.3/codex-package-aarch64-unknown-linux-musl.tar.gz"
        sha256 "20b7d673cf2b64b6c6208fa4fda06feb9dac0572da9987294b48cde1dab9d001"
      end
    end
    on_intel do
      url "https://github.com/codeasy-digix/codex-accounts/releases/download/v0.3.0/codex-accounts_0.3.0_linux_amd64.tar.gz"
      sha256 "deaaf326037b0e0fc11cc3e7f7a423fc10c5c443adfc8d80df80d3531964d14e"

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

      Run: codex account NAME; codex account NAME --set-default; codex account default
      Resume quota and other interrupted conversations: codex continue
      Your existing conversations and account credentials are retained on uninstall.
      Support: support@digix.kr
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
    assert_match "No interrupted", shell_output("#{bin}/codex-accounts continue --list")
  end
end

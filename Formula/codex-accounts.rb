class CodexAccounts < Formula
  desc "Per-terminal Codex accounts with shared local conversations"
  homepage "https://github.com/codeasy-org/codex-accounts"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/codeasy-org/codex-accounts/releases/download/v0.1.0/codex-accounts_0.1.0_darwin_arm64.tar.gz"
      sha256 "15c4a27b8cfd43091e324cf03dda127ee8a20fcbdacac9afbc1ce4f962d47ab7"

      resource "codex-runtime" do
        url "https://github.com/openai/codex/releases/download/rust-v0.159.3/codex-package-aarch64-apple-darwin.tar.gz"
        sha256 "fad57a5681cabcef21d322af5aec938975cfb711b5f25d4ce4907e6561616d07"
      end
    end
    on_intel do
      url "https://github.com/codeasy-org/codex-accounts/releases/download/v0.1.0/codex-accounts_0.1.0_darwin_amd64.tar.gz"
      sha256 "e52ccc03bdca2b5dc1806b9bdc5825d23d4d5ac1d5442801ba0af866d0af2378"

      resource "codex-runtime" do
        url "https://github.com/openai/codex/releases/download/rust-v0.159.3/codex-package-x86_64-apple-darwin.tar.gz"
        sha256 "fe3096a62b5d8395dd25abf9fe79334cf13c1520b825d236cd2b41eb75a63201"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/codeasy-org/codex-accounts/releases/download/v0.1.0/codex-accounts_0.1.0_linux_arm64.tar.gz"
      sha256 "f2dfbfd4800042d679e4bf08e0fa10bd2597cd62e444d1054c25e3dfce13aa68"

      resource "codex-runtime" do
        url "https://github.com/openai/codex/releases/download/rust-v0.159.3/codex-package-aarch64-unknown-linux-musl.tar.gz"
        sha256 "20b7d673cf2b64b6c6208fa4fda06feb9dac0572da9987294b48cde1dab9d001"
      end
    end
    on_intel do
      url "https://github.com/codeasy-org/codex-accounts/releases/download/v0.1.0/codex-accounts_0.1.0_linux_amd64.tar.gz"
      sha256 "f0be44e07ccf69a4af56ecfbf412d98b847ecf2fba0340cdf96eda07b1ba2cd3"

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

      Run: codex account NAME; codex account; codex account default
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
  end
end

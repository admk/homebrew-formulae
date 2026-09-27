# typed: false

# frozen_string_literal: true

# borders.rb
class Borders < Formula
  env :std
  desc "A window border system for macOS"
  homepage "https://github.com/admk/JankyBorders"
  url "https://github.com/admk/JankyBorders/archive/refs/tags/v1.9.0-admk.1.tar.gz"
  sha256 "d6fd1df4d388d60bc540b9ad9e2a8fec7f00a6bc7aba647c6236d39ebd4edbaa"
  license "GPL-3.0-only"
  head "https://github.com/admk/JankyBorders.git", branch: "mission-control-transform-fix"

  def clear_env
    ENV.delete("CFLAGS")
    ENV.delete("LDFLAGS")
    ENV.delete("CXXFLAGS")
  end

  def install
    clear_env
    (var/"log/jankyborders").mkpath
    system "make"

    system "codesign", "--force", "-s", "-", "#{buildpath}/bin/borders"
    bin.install "#{buildpath}/bin/borders"

    man.mkpath
    man1.install "#{buildpath}/docs/borders.1"
  end

  service do
    run "#{opt_bin}/borders"
    environment_variables PATH: std_service_path_env, LANG: "en_US.UTF-8"
    keep_alive true
    process_type :interactive
    log_path "#{var}/log/borders/borders.out.log"
    error_log_path "#{var}/log/borders/borders.err.log"
  end

  test do
    echo "To test your installation run: borders \n"
  end
end

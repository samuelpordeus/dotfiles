# frozen_string_literal: true

# Based on https://github.com/mattbrictson/dotfiles

require 'fileutils'
require 'rake'
require 'shellwords'

IGNORE = %w[Rakefile README.md LICENSE].freeze

task default: 'install'

desc 'Install packages and dotfiles'
task install: %w[
  install:command_lint_tools
  install:homebrew
  install:link_dotfiles
  install:link_bins
  install:oh_my_zsh
  install:asdf_plugins
  install:shell_improvements
  install:configure_itermocil
  install:configure_sublime
  install:macos_customization
]

namespace :install do
  ##############################################################################
  # Update macOS and install Xcode
  ##############################################################################
  desc 'OS X Softwares updating and installing Xcode Command Line tools'
  task :command_lint_tools do
    log(:blue, '=> Updating MacOS and installing Xcode Command Line tools')

    if ask(:red, 'Would you like to install any remaining software updates?')
      system('sudo softwareupdate --install --all')
    end

    # Install the Xcode Command Line Tools.
    system('sudo xcode-select --install &>/dev/null')
    system('sudo sudo xcodebuild -license accept &>/dev/null')
  end

  ##############################################################################
  # Symlink all dotfiles
  ##############################################################################
  desc 'Link dotfiles into home directory'
  task :link_dotfiles do
    log(:blue, '=> Linking dotfiles into home directory')

    Dotfile.each(directory: 'configs') do |dotfile|
      case dotfile.status
      when :missing
        log(:green, "Linking #{dotfile}")
        dotfile.link!
      when :different
        log(:green, "Replacing #{dotfile}")
        dotfile.replace!
      end
    end
  end

  ##############################################################################
  # Symlink bin files
  ##############################################################################
  desc 'Link bin files'
  task :link_bins do
    log(:blue, '=> Linking bin files')

    bins = Dotfile.new('bin')

    case bins.status
    when :identical
      log(:green, "Identical #{bins}")
    when :missing
      log(:green, "Linking #{bins}")
      bins.link!
    when :different
      log(:green, "Replacing #{bins}")
      bins.replace!
    end
  end

  ##############################################################################
  # Install Oh My ZSH
  ##############################################################################
  desc 'Install Oh My ZSH'
  task :oh_my_zsh do
    log(:blue, '=> Installing Oh my ZSH')

    if File.directory?(File.join(ENV['HOME'], '.oh-my-zsh'))
      log(:green, 'Oh my ZSH already installed')
    else
      system('git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh')
      system('sudo sh -c "echo $(which zsh) >> /etc/shells"')
      system('chsh -s $(which zsh)')
    end

    # Copy ZSH theme - Uncomment if using custom theme
    # theme_from = File.expand_path('themes/ricardoruwer.zsh-theme')
    # theme_to = File.expand_path('~/.oh-my-zsh/themes/ricardoruwer.zsh-theme')

    # FileUtils.ln_s(theme_from, theme_to)
  end

  ##############################################################################
  # Install Homebrew and apps from Brewfile
  ##############################################################################
  desc 'Install Homebrew'
  task :homebrew do
    log(:blue, '=> Installing Homebrew')

    if installed?('brew')
      log(:green, 'Homebrew already installed')
    else
      system('/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"')
      Dotfile.new('Brewfile').replace!
    end

    confirm(:yellow, 'Please log in to Mac App Store manually before continuing')

    if ask(:red, 'Would you like to install all apps from Brewfile?')
      log(:blue, '=> Installing Homebrew apps from Brewfile')
      system('brew bundle --global')
      system('brew cleanup')
    end
  end

  ##############################################################################
  # Install asdf plugins
  ##############################################################################
  desc 'Install asdf plugins'
  task :asdf_plugins do
    log(:blue, '=> Installing asdf plugins')

    system('asdf plugin-add elasticsearch')
    system('asdf plugin-add elixir')
    system('asdf plugin-add erlang')
    system('asdf plugin-add golang')
    system('asdf plugin-add nodejs')
    system('asdf plugin-add postgres')
    system('asdf plugin-add redis')
    system('asdf plugin-add ruby')
    system('asdf plugin-add yarn')

    system('bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring')

    system('asdf install')
  end

  ##############################################################################
  # Install some shell improvements
  ##############################################################################
  desc 'Install Shell improvements'
  task :shell_improvements do
    log(:blue, '=> Installing fzf key bindings and completion')
    system('/usr/local/opt/fzf/install')
  end

  ##############################################################################
  # Configure itermocil
  ##############################################################################
  desc 'Configure itermocil'
  task :configure_itermocil do
    log(:blue, '=> Configuring itermocil')

    confirm(:yellow, 'Please open and log in to Google Backup & Sync before continuing')

    itermocil_from = File.expand_path('~/Google Drive/.itermocil')
    itermocil_to = File.expand_path('~/.itermocil')

    FileUtils.ln_s(itermocil_from, itermocil_to)
  end

  ##############################################################################
  # Configure Sublime Text
  ##############################################################################
  # desc 'Configure Sublime Text'
  # task :configure_sublime do
  #   log(:blue, '=> Configuring Sublime Text')

  #   confirm(:yellow, 'Please open and log in to Google Backup & Sync before continuing')

  #   sublime_from = File.expand_path('~/Google Drive/Sublime/User')
  #   sublime_to = File.expand_path('~/Library/Application Support/Sublime Text 3/Packages/User')

  #   FileUtils.rm_r(sublime_to)
  #   FileUtils.ln_s(sublime_from, sublime_to)

  #   log(:cyan, '* Install the PackageControl: https://packagecontrol.io/installation')
  # end

  ##############################################################################
  # Customize macOS preferences
  ##############################################################################
  desc 'Customize macOS preferences'
  task :macos_customization do
    log(:blue, '=> Customizing macOS preferences')

    system('./bin/customize_osx')

    log(:cyan, '* Please restart your computer for these changes to take effect')
  end
end

def log(color, message)
  colors = {
    black: "\e[0;30mMESSAGE\e[0m",
    red: "\e[0;31mMESSAGE\e[0m",
    green: "\e[0;32mMESSAGE\e[0m",
    yellow: "\e[0;33mMESSAGE\e[0m",
    blue: "\e[0;34mMESSAGE\e[0m",
    purple: "\e[0;35mMESSAGE\e[0m",
    cyan: "\e[0;36mMESSAGE\e[0m",
    white: "\e[0;37mMESSAGE\e[0m"
  }

  raise "#{color} not available" unless colors[color]

  message = colors[color].gsub('MESSAGE', message)

  puts(message)
end

def ask(color, question)
  log(color, "#{question} [yNaq]? ")

  case $stdin.gets.chomp
  when 'a'
    :always
  when 'y'
    true
  when 'q'
    exit
  else
    false
  end
end

def confirm(color, message)
  log(color, "#{message} [press RETURN to continue] ")

  $stdin.gets
end

def installed?(name)
  system("command -v #{name} &>/dev/null")
end

class Dotfile
  def self.each(directory: nil, &block)
    Dir[File.join([directory, '*'].compact)].each do |file|
      next if IGNORE.include?(file)

      if File.directory?(file)
        each(file, &block)
      else
        yield(new(file))
      end
    end
  end

  attr_reader :file

  def initialize(file)
    @file = file
  end

  def name
    ".#{File.basename(@file)}"
  end
  alias to_s name

  def target
    File.expand_path("~/#{name}")
  end

  def status
    if File.identical?(file, target)
      :identical
    elsif File.exist?(target) || File.symlink?(target)
      :different
    else
      :missing
    end
  end

  def link!(delete_first: false)
    ensure_target_directory

    log(:blue, "Linking #{self}")
    FileUtils.rm_rf(target) if delete_first
    FileUtils.ln_s(File.absolute_path(file), target)
  end

  def replace!
    link!(delete_first: true)
  end

  def ensure_target_directory
    directory = File.dirname(target)
    return if File.directory?(directory)

    log(:magenta, "Creating directory #{File.dirname(name)}")
    FileUtils.mkdir_p(directory)
  end
end

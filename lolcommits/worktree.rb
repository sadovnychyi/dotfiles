require "git"
require "lolcommits/backends/git_info"

module Lolcommits
  class GitInfo
    # Lolcommits 0.18.0 does not recognize linked Git worktrees because their
    # .git entry is a file. Remove this shim once worktree support is released:
    # https://github.com/lolcommits/lolcommits/issues/324
    def self.repo_root?(path = ".")
      Git.open(path)
      true
    rescue ArgumentError
      false
    end

    def self.local_name(path = ".")
      git_dir = Git.open(path).repo.path
      commondir = File.join(git_dir, "commondir")
      if File.file?(commondir)
        git_dir = File.expand_path(File.read(commondir).strip, git_dir)
      end
      File.basename(File.dirname(git_dir))
    end
  end
end

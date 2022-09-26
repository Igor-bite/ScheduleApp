# Warn about master branch
warn("Please target PRs to `develop` branch") if github.branch_for_base != "master"

# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn("PR is classed as Work in Progress") if github.pr_title.include? "[WIP]"

# Warn when there is a big PR
warn("Big PR") if git.lines_of_code > 500

# Info.plist file shouldn't change often. Leave warning if it changes.
is_plist_change = git.modified_files.include?("ScheduleApp/Configuration/Info.plist")

if is_plist_change
  warn "Plist changed, don't forget to localize your plist values"
end

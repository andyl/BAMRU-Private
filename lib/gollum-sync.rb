
class Gollum::Sync

  def self.to_backup
    wroot = Rails.root.to_s + "/wiki"
    system "cd #{wroot} ; /usr/bin/git fetch origin master"
    system "cd #{wroot} ; /usr/bin/git merge -s recursive -X theirs origin/master"
    system "cd #{wroot} ; /usr/bin/git push"
  end

end

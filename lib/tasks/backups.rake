require 'rake_util'

include RakeUtil

# ----- Rake Tasks -----

namespace :ops do
  namespace :backup do

    def backup_params
      {
        "wiki_full" => {
                :host   => "wiki.bamru.net",
                :target => "mediawiki",
                :copies => 2 },
        "wiki_data" => {
                :host   => "wiki.bamru.net",
                :target => %w(mediawiki/data mediawiki/extensions),
                :copies => 10 },
        "system" => {
                :host   => "bamru.net",
                :target => "a/BAMRU-Private/shared/system",
                :copies => 5 },
        "db"     => {
                :host   => "bamru.net",
                :target => "a/BAMRU-Private/shared/db/production.sqlite3",
                :copies => 20 }
      }
    end

    def backup(label)
      host       = `hostname`.chomp
      params     = backup_params[label]
      base_dir   = File.expand_path("~/.backup")
      time_stamp = Time.now.strftime("%y%m%d_%H%M%S")
      lbl_dir    = [base_dir, label].join('/')
      tgt_dir    = [base_dir, label, time_stamp].join('/')
      system "mkdir -p #{tgt_dir}"

      # ----- alternate commands for local and remote copying -----
      scp_cmd = Proc.new {|x| "scp -r -q #{params[:host]}:#{x} #{tgt_dir}"}
      cp_cmd  = Proc.new {|x| "cp -r /home/aleak/#{x} #{tgt_dir}"}
      pcmd = host == params[:host] ? cp_cmd : scp_cmd

      # ----- build a list of targets to copy -----
      target  = params[:target]
      targets = target.class == Array ? target : [target]

      # ----- copy each target -----
      puts "Backing up #{label}"
      targets.each do |z|
        cmd = pcmd.call(z)
        puts cmd
        system cmd
      end

      # ----- delete old backups if they exceed the copy limit -----
      list = Dir.glob(lbl_dir + '/*').sort.reverse
      list.each_with_index do |name, index|
        if index >= params[:copies]
          puts   "Removing old backup: #{name}"
          system "rm -r #{name}"
        end
      end
    end

    desc "Backup all Targets"
    task :all => [:wiki_full, :wiki_data, :system, :db] do
      puts "All targets backed up"
    end

    desc "Backup Full Wiki"
    task :wiki_full => 'environment' do
      backup("wiki_full")
    end

    desc "Backup Wiki Data"
    task :wiki_data => 'environment' do
      backup("wiki_data")
    end

    desc "Backup System Directory"
    task :system do
      backup("system")
    end

    desc "Backup Database"
    task :db do
      backup("db")
    end

  end
end

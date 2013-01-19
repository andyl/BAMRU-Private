require 'rake_util'
require 'ostruct'

include RakeUtil

# ----- Rake Tasks -----

namespace :ops do

  def backup_params
    {
      "sysdir" => {
        :targets => ["public/system"],
        :copies  => 5 },
      "db" => {
        :targets => ["db/data.yml", "db/schema.rb"],
        :copies  => 20 }
    }
  end

  def gen_opts(dataset)
    opt = OpenStruct.new
    opt.app        = "bnet"
    opt.host       = `hostname`.chomp
    opt.base_dir   = File.expand_path("~/.backup")
    opt.time_stamp = Time.now.strftime("%y%m%d_%H%M%S")
    opt.lbl_dir    = [opt.base_dir, opt.app, opt.host, dataset].join('/')
    opt.tgt_dir    = [opt.base_dir, opt.app, opt.host, dataset, opt.time_stamp].join('/')
    opt.cp_cmd     = Proc.new {|data_path| "cp -r #{data_path} #{opt.tgt_dir}"}
    opt.targets    = backup_params[dataset][:targets]
    opt.copies     = backup_params[dataset][:copies]
    opt
  end

  def backup(dataset)
    opts = gen_opts(dataset)
    system "mkdir -p #{opts.tgt_dir}"

    # ----- copy each target -----
    puts "Backing up #{dataset}"
    opts.targets.each do |path|
      cmd = opts.cp_cmd.call(path)
      puts cmd
      system cmd
    end

    # ----- delete old backups if they exceed the copy limit -----
    list = Dir.glob(opts.lbl_dir + '/*').sort.reverse
    list.each_with_index do |path, index|
      if index >= opts.copies
        puts   "Removing old backup: #{path}"
        system "rm -r #{path}"
      end
    end
  end


  namespace :backup do

    desc "Backup all Targets"
    task :all => [:sysdir, :db] do
      puts "All targets backed up"
    end

    desc "Backup System Directory"
    task :sysdir do
      backup("sysdir")
    end

    desc "Backup Database"
    task :db => "db:data:dump" do
      backup("db")
    end

  end

  namespace :restore do

  end

end

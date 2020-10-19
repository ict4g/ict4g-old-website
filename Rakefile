# coding: utf-8

require 'find'

task :default => :preview

# SOME EXPLANATION HERE

#
# --- NO NEED TO TOUCH ANYTHING BELOW THIS LINE ---
#

#
# Tasks start here
#

# return the newest element in dir as a pair [name, mtime]
def newest_file dir
  Find.find(dir).map { |x| [x, File.new(x).mtime] }.sort { |x,y| y[1] <=> x[1] }.first
end

desc "Preview the website (an alias for 'middleman')"
task :preview do
  system "middleman"
end

desc "Build, if source or data is newer than the build dir"
task :build do
  printf "Checking if I need to build ... "
  newest_source = newest_file "source"
  newest_data   = newest_file "data"
  newest_build  = File.exists?("build") ? newest_file("build") : ["not existent", Date.parse("1/1/1970")]

  if newest_source[1] > newest_build[1] or newest_data[1] > newest_build[1]
    printf "yes!\n"
    system "bundle exec middleman build"
  else
    printf "no!\n"
    puts "build directory is newer than source.  Use force_build to force a build."
  end
end

desc "Build!"
task :force_build do
  system "bundle exec middleman build"
end
  
desc "Deploy, if the newest file on build is newer than _last_deploy.txt" 
task :deploy => :build do
  printf "Checking if I need to deploy ... "
  newest_build = newest_file("build") # build exists, since this task depends on "build"

  if not File.exists?("_last_deploy.txt") or File.new("_last_deploy.txt").mtime < newest_build[1]
    printf "yes!\n"
    system "bundle exec middleman deploy"
    system "echo $(date) > _last_deploy.txt"
  else
    printf "no.\n"
    puts "_last_deploy.txt is newer than build.  Use force_deploy to force a deploy."
  end
end

desc "Deploy!"
task :force_deploy do
  system "bundle exec middleman deploy"
  system "echo $(date) > _last_deploy.txt"
end

desc "Check timestamps"
task :check_timestamps do
  results = []
  puts "Newest files: "
  ["source", "data", "build", "_last_deploy.txt"].each do |file|
    if File.exists? file
      result = newest_file file
      results << result
      puts "%20s" % result[0] + " => " + result[1].to_s
    else
      puts "%20s" % file + " => does not exist"
    end
  end
  newest = results.sort {|x,y| y[1] <=> x[1]}.first
  puts "The newest file of the bunch is: " + newest[0]
  
end

###
# Compass
###
# Change Compass configuration
compass_config do |config|
  config.output_style = :compact
  config.add_import_path "bower_components/foundation/scss"
end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout


# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }


# Methods defined in the helpers block are available in templates
helpers do
  def aurl url
    File.join(http_prefix, url)
  end

  def slugify (title)
    # strip characters and whitespace to create valid filenames, also lowercase
    if(title!=nil)
      return title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
    else 
      return title
    end
  end

  def mailto email="user@example.com", string="contact me"
    comp = email.split("@")
    
    # process string, if it is an email address
    if string.include?("@") then
      string_comp = string.split("@")

      string = "<script>a = [\"#{string_comp[1].gsub('.', " dot ")}\", \"#{string_comp[0]}\"]; document.write(a[1] + \" at \" + a[0]);</script><noscript>activate javascript to view email</noscript>"
    end

    %|<a href="my email when you click" rel="nofollow"
      onclick="str1='#{comp[0]}';str2='#{comp[1]}';this.href='mailto:' + str1 + '@' + str2">#{string}</a>|
  end

  def publications()
    @@b=BibTeX.open('ict4g.bib').convert(:latex)
    return @@b
  end
end

data.members.each do |member|
  proxy "/profile/#{slugify(member.name)}.html", "/profile/profile.html", 
        :locals => { :name => member.name, :role => member.role, :email => member.email,
                     :phone => member.phone, :github => member.github, :homepage => member.homepage,
                     :picture => member.picture , :short_bio => member.short_bio},
        :ignore => true
end

data.projects.each do |p|
  proxy "/projects/#{slugify(p.title)}.html", "/projects/project.html",
        :locals => { :title=> p.title, :acronym => p.acronym, :logo => p.logo, :source => p.source,
                     :tags => p.tags, :start_date => p.start_date, :end_date => p.end_date, :abstract => p.abstract,
                     :gallery => p.gallery, :description => p.description, :contact => p.contact, :website => p.website,
                     :page_team => p.team, :pubs => p.pubs},
        :ignore => true
end

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
# configure :development do
#   activate :livereload
# end

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

sprockets.append_path File.join root.to_s, 'bower_components'
# if you want to copy assets into the javascripts dir
#sprockets.import_asset 'foundation/js/foundation/foundation.orbit.js'
#sprockets.import_asset 'foundation/js/foundation/foundation.topbar.js'
#sprockets.import_asset "foundation/js/foundation.min.js"
#sprockets.import_asset 'jquery/dist/jquery.min.js'



configure :development do
  set :http_prefix, "/"
end

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  # ignore picture to avoid a problem related to pictures in posts (see: https://github.com/middleman/middleman/issues/818)
  activate :asset_hash, :ignore => [/.*\.jpg/, /.*\.png/]

  # Compress assets
  activate :gzip

  # Use relative URLs
  # activate :relative_assets

  # serve all urls from a custom url
  set :http_prefix, "/home"
end

require 'bib_helpers.rb'
activate :bib_helpers 

activate :blog do |blog|
  blog.name = "posts"
  blog.prefix = "posts"
end


activate :deploy do |deploy|
  # Deploy informations 
  system('date > _last_deploy.txt')
end


# slim for templating and keep the output pretty
require 'slim'
set :slim, :pretty => true

# some site-wide variables
set :site_title, "Site Title"
set :site_url, "site.url"
set :site_description, "Site description."
set :site_keywords, "site, key, words"

# primary asset paths
set :source, "source"
set :css_dir, "assets/css"
set :js_dir, "assets/js"
set :images_dir, "assets/img"
set :fonts_dir, "assets/fonts"
set :partials_dir, "templates/partials"
set :layouts_dir, "templates"
#set :build_dir, "build"
set :layout, "default"   # default layout name

# markdown options
set :markdown, :tables => true, :autolink => true, :fenced_code_blocks => true

# turn off SASS line comments
::Compass.configuration.sass_options = { :line_comments => false }

activate :livereload

# convert page.html.md to page/index.html
activate :directory_indexes

# Build config
configure :build do
  activate :relative_assets
  activate :minify_css
  activate :minify_javascript
  # activate :asset_hash #cachebuster
end

# Deploy config
# activate :deploy do |deploy|
#   deploy.method = :rsync
#   deploy.user = ""
#   deploy.host = ""
#   deploy.path = ""
#   deploy.after_build = false
# end
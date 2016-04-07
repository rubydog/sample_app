require File.expand_path('../../config/environment', __FILE__)

## Get requests
errors = []
post = Post.create title: 'Foo Bar', description: 'Lorem Ipsum'
[{url: 'posts_url',     params: [],   method: 'GET'},
 {url: 'new_post_url',  params: [],   method: 'GET'},
 {url: 'edit_post_url', params: post, method: 'GET'},
 {url: 'post_url',      params: post, method: 'GET'}].each do |route| 
   errors << route if `curl -X #{route[:method]} -s -o /dev/null -w "%{http_code}" #{Rails.application.routes.url_helpers.send(route[:url], route[:params], host: 'localhost', port: 3000)
}` !~ /200/
end

p errors

## Post requests
# .... 

## Test if all post rendering
ids = Post.all.select { |post| `curl -s -o /dev/null -w "%{http_code}" #{Rails.application.routes.url_helpers.post_url(post, host: 'localhost', port: 3000)
}`.to_i != 200}.map(&:id)

p ids
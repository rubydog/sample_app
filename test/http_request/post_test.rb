require File.expand_path('../../../config/environment', __FILE__)

post = Post.create title: 'Foo Bar', description: 'Lorem Ipsum'

## Get requests

errors = []
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

## Content testing
## Testing if Post page is displaying the right post object.
p "Content #{post.title} not found" unless `curl #{Rails.application.routes.url_helpers.post_url(post, host: 'localhost', port: 3000)}`.match(post.title)

## Test if all posts rendering
ids = Post.all.select { |post| `curl -s -o /dev/null -w "%{http_code}" #{Rails.application.routes.url_helpers.post_url(post, host: 'localhost', port: 3000)
}`.to_i != 200}.map(&:id)

p ids

## Content testing
## Testing if Post page is displaying the right post object.
`curl #{Rails.application.routes.url_helpers.post_url(post, host: 'localhost', port: 3000)}`.match('Foo Bar')
require File.expand_path('../../../config/environment', __FILE__)


## Get requests

post = Post.create title: 'foo bar', description: 'descriptuion'
errors = []
[{url: 'posts_url',     params: [],   method: 'GET'},
 {url: 'new_post_url',  params: [],   method: 'GET'},
 {url: 'edit_post_url', params: post, method: 'GET'},
 {url: 'post_url',      params: post, method: 'GET'}].each do |route|
   http_code = `curl -X #{route[:method]} -s -o /dev/null -w "%{http_code}" #{Rails.application.routes.url_helpers.send(route[:url], route[:params], host: 'localhost', port: 3000)
}`
  if http_code !~ /200/
    route[:http_code] = http_code
    errors.push(route)
  end
end

puts "List of failed url(s) -- #{errors}"

## Post requests
# ....

## Content testing

## Testing if Post page is displaying the right post object.
post = Post.create title: 'foo bar', description: 'descriptuion', active: true
expected_content  = [post.title, post.description, 'Active']
content_not_found = []
page_body = `curl -s #{Rails.application.routes.url_helpers.post_url(post, host: 'localhost', port: 3000)}`.to_s
expected_content.each do |content|
  if page_body !~ /#{content}/
    content_not_found.push(content)
  end
end

puts "List of content(s) not found on Post#show page with post id: #{post.id} -- #{content_not_found}"



## Test if all posts rendering
failed_ids = Post.all.select { |post| `curl -s -o /dev/null -w "%{http_code}" #{Rails.application.routes.url_helpers.post_url(post, host: 'localhost', port: 3000)
}`.to_i != 200}.map(&:id)

puts "List of post(s) with error in rendering -- #{failed_ids}"
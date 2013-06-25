
get '/admin/cms' do
	_tpl :_default
end

#submit comment
post '/cms/comment/:cpid' do

	#allow to comment
	ds = DB[:cms_post].filter(:cpid => params[:cpid])
	_throw L[:'the comment is closed'] unless ds.get(:status) == 0

	cms_comment_set_fields
	cms_comment_valid_fields
	@fields[:created] = Time.now
	DB[:cms_comment].insert(@fields)

	#update the post status
	update_fields = {}
	update_fields[:last_changed] = _user[:uid]
	update_fields[:comment_count] = ds.get(:comment_count) + 1
	ds.update(update_fields)

	redirect back
end

#submit post
post '/cms/edit' do
	cms_post_set_fields
	@fields[:created] = Time.now
	@fields[:changed] = Time.now
	DB[:cms_post].insert(@fields)
	redirect _url2("#{@_path[:cms_route]}")
end

post '/cms/setpost' do
	if params[:cpid] and params[:opt]
		setpost = _vars(:post_settings, :cms)
		if setpost[params[:opt].to_i] != nil
			params[:cpid].each do | cpid |
				eval("cms_setpost_#{setpost[params[:opt].to_i]}(#{cpid.to_i})")
			end
		end
	end
	redirect back
end

# ===================
# just copy the code to your script
# and change the route, such as '/cms/post' to '/my/path'
# ===================
# before do
# 	@_path[:cms_route] = '/cms/post'
# end
# 
# get '/cms/post' do
# 	cms_get_posts
# end
# 
# get '/cms/post/view/:ctid/:cpid/:title' do
# 	cms_get_post params[:cpid]
# end
# 
# get '/cms/post/edit' do
# 	cms_edit
# end
# 

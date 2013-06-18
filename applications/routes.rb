
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
post '/cms/form' do
	cms_post_set_fields
	@fields[:created] = Time.now
	@fields[:changed] = Time.now
	DB[:cms_post].insert(@fields)
	if @qs[:come_from]
		redirect @qs[:come_from]
	else
		redirect request.referer
	end
end

before '/cms/*' do
	_login?
end



get '/admin/cms' do
	_tpl :_default
end

#submit comment
post '/cms/comment/:cpid' do
	cms_allow_comment params[:cpid]
	cms_comment_set_fields
	cms_comment_valid_fields
	@fields[:created] = Time.now
	DB[:cms_comment].insert(@fields)
	redirect back
end

#submit post
post '/cms/form' do
	cms_post_set_fields
	@fields[:created] = Time.now
	@fields[:changed] = Time.now
	DB[:cms_post].insert(@fields)
	redirect params[:cms_route_path] + '/list/' + @fields[:ctid].to_s
end

before '/cms/*' do
	_login?
end

def cms_allow_comment cpid
	_throw L[:'the comment is closed'] unless DB[:cms_post].filter(:cpid => cpid).get(:status) == 0
end

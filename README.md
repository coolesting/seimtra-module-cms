## INTRODUCTION

a cms module of seimtra

## USAGES

just put the code to your script, and change the route, 
such as from '/cms/post' to '/my/path', that is it

	before do
		@_path[:cms_route] = '/cms/post'
	end

	get '/cms/post/list' do
		ctid = @qs.include?(:ctid) ? @qs[:ctid] : 1
		cms_get_list ctid
	end

	get '/cms/post/view/:ctid/:cpid/:title' do
		cms_get_post params[:cpid]
	end

	get '/cms/post/edit' do
		cms_edit
	end



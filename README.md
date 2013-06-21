## INTRODUCTION

a cms module of seimtra

## USAGES

just put the code to your script, and change the route as you want, 
such as from '/cms/post' to '/my/path', that is it

	before do
		@_path[:cms_route] = '/cms/post'
	end

	get '/cms/post' do
		ctid = @qs.include?(:ctid) ? @qs[:ctid] : 1
		cms_get_posts ctid
	end

	get '/cms/post/view/:ctid/:cpid/:title' do
		cms_get_post params[:cpid]
	end

	get '/cms/post/edit' do
		cms_edit
	end



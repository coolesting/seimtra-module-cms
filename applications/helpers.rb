helpers do

	#get posts by type
	def cms_get_posts ctid = 1, tpl = :cms_table
		@page_size = 20

		#regular post
		ds = DB[:cms_post].filter(:ctid => ctid.to_i).reverse(:cpid)
		Sequel.extension :pagination
		@res = ds.paginate(@page_curr, @page_size, ds.count)
		@page_count = @res.page_count

		#top post
		cpids = DB[:cms_postmeta].filter(:mkey => '1', :mval => ctid).map(:cpid)
		@top = DB[:cms_post].where(:cpid => cpids).all

		_tpl tpl
	end

	#get post by cpid
	def cms_get_post cpid = 1, tpl = :cms_body_post
		@res = {}
		ds = DB[:cms_post].filter(:cpid => cpid.to_i)

		unless ds.empty?
			@title 			= ds.get(:title) + " - " + @title
			@res 			= ds.first
			@description 	= ds.get(:title)
			_parser_init :no_intra_emphasis => true
		end
		_tpl tpl
	end

	def cms_get_comment cpid = 1
		@page_size = 9
		ds = DB[:cms_comment].filter(:cpid => cpid.to_i)
		Sequel.extension :pagination
		res = ds.paginate(@page_curr, @page_size, ds.count)
		@page_count = res.page_count
		res = res ? res : {}
	end

	def cms_edit
 		_login?
		_tpl :cms_edit
	end

end

helpers do

	#get posts by type
	def cms_get_posts ctid = 0, tpl = :cms_table

		if ctid == 0
			ctid = @qs.include?(:ctid) ? @qs[:ctid] : 1
		end
		@page_size = 20

		#regular post
		ds = DB[:cms_post].filter(:ctid => ctid.to_i).reverse(:cpid)
		Sequel.extension :pagination
		@res = ds.paginate(@page_curr, @page_size, ds.count)
		@page_count = @res.page_count

		#top post
		cpids = DB[:cms_postmeta].filter(:mkey => '1', :mval => ctid).map(:cpid)
		@top = DB[:cms_post].where(:cpid => cpids).all

		if tpl == :cms_table
			tpl = @qs[:tpl].to_sym if @qs.include?(:tpl)
		end
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

	#set the post as news
	def cms_setpost_news cpid
		postmeta = _vars :post_settings, :cms
		ds 	= DB[:cms_postmeta].filter(:cpid => cpid, :mkey => postmeta.index('news'))
		ctid = DB[:cms_post].filter(:cpid => cpid).get(:ctid)

		if ds.empty?
			DB[:cms_postmeta].insert(
				:cpid => cpid, 
				:mkey => postmeta.index('news'),
				:mval => ctid,
				:created => Time.now
			)
		else
			ds.delete
		end
	end

	#set the post to top of table
	def cms_setpost_top cpid
		postmeta = _vars :post_settings, :cms
		ds 	= DB[:cms_postmeta].filter(:cpid => cpid, :mkey => postmeta.index('top'))
		ctid = DB[:cms_post].filter(:cpid => cpid).get(:ctid)

		if ds.empty?
			DB[:cms_postmeta].insert(
				:cpid => cpid, 
				:mkey => postmeta.index('top'),
				:mval => ctid,
				:created => Time.now
			)
		else
			ds.delete
		end
	end

	#move the post to trash type
	def cms_setpost_trash cpid
		DB[:cms_post].filter(:cpid => cpid).update(:ctid => 2)
	end
	
end

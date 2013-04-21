helpers do

	def cms_get_comment cpid
		DB[:cms_comment].filter(:cpid => cpid.to_i).all
	end

	def cms_get_list ctid
		ds = DB[:cms_post].filter(:ctid => ctid).all
		@res = ds ? ds : {}
		_tpl :cms_list
	end

	def cms_get_post cpid
		ds = DB[:cms_post].filter(:cpid => cpid).first
		@res = ds ? ds : {}
		_tpl :cms_body
	end

	def cms_form
		_tpl :cms_form
	end

end

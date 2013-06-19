helpers do

	def cms_get_list ctid = 1
		@page_size = 20
		ds = DB[:cms_post].filter(:ctid => ctid.to_i).reverse(:cpid)
		Sequel.extension :pagination
		@res = ds.paginate(@page_curr, @page_size, ds.count)
		@page_count = @res.page_count
		_tpl :cms_list
	end

	def cms_get_post cpid = 1
		@res = {}
		tpl = "cms_body_page"
		ds = DB[:cms_post].filter(:cpid => cpid.to_i)

		unless ds.empty?
			@title 	= ds.get(:title) + " - " + @title
			@res 	= ds.first
			@description = ds.get(:title)
			tpls 	= _vars :post_form, :cms
			tpl 	= "cms_body_#{tpls[@res[:form_id]]}"
		end
		_tpl tpl.to_sym
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

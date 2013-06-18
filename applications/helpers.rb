helpers do

	def cms_setup options = {}
		if @qs.include?(:opt)
			if @qs[:opt] == 'form'
				cms_form
			elsif @qs[:opt] == 'post'
				cms_get_post
			else
				cms_get_list
			end
		else
			cms_get_list
		end
	end

	def cms_get_list ctid = 1
		@page_size = 20
		ctid = @qs.include?(:ctid) ? @qs[:ctid] : ctid
		ds = DB[:cms_post].filter(:ctid => ctid.to_i).reverse(:cpid)
		Sequel.extension :pagination
		@res = ds.paginate(@page_curr, @page_size, ds.count)
		@page_count = @res.page_count
		_tpl :cms_list
	end

	def cms_get_post cpid = 1
		cpid = @qs.include?(:cpid) ? @qs[:cpid] : cpid
		@res = {}
		tpl = "cms_body_page"
		ds = DB[:cms_post].filter(:cpid => cpid.to_i).first

		unless ds.empty?
			@res = ds
			tpls = _vars :post_form, :cms
			tpl = "cms_body_#{tpls[@res[:form_id]]}"
		end
		_tpl tpl.to_sym
	end

	def cms_get_comment cpid = 1
		@page_size = 9
		cpid = @qs.include?(:cpid) ? @qs[:cpid] : cpid
		ds = DB[:cms_comment].filter(:cpid => cpid.to_i)

		Sequel.extension :pagination
		res = ds.paginate(@page_curr, @page_size, ds.count)
		@page_count = res.page_count
		res = res ? res : {}
	end

	def cms_form
		@qs[:come_from] = request.referer unless @qs.include?(:come_from)
 		_login?
		_tpl :cms_edit
	end

end

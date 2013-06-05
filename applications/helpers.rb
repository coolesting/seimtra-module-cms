helpers do

	def cms_setup options = {}
		@cms_vars = options
		@cms_vars[:css] = '/cms/css/cms.css' unless @cms_vars.include? :css
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
		ctid = @qs.include?(:ctid) ? @qs[:ctid] : ctid
		ds = DB[:cms_post].filter(:ctid => ctid.to_i).reverse(:cpid).all
		@res = ds ? ds : {}
		_tpl :cms_list
	end

	def cms_get_comment cpid = 1
		cpid = @qs.include?(:cpid) ? @qs[:cpid] : cpid
		DB[:cms_comment].filter(:cpid => cpid.to_i).reverse(:ccid).all
	end

	def cms_get_post cpid = 1
		cpid = @qs.include?(:cpid) ? @qs[:cpid] : cpid
		ds = DB[:cms_post].filter(:cpid => cpid.to_i).first
		@res = ds ? ds : {}
		_tpl :cms_body
	end

	def cms_form
		@qs[:come_from] = request.referer unless @qs.include?(:come_from)
 		_login?
		_tpl :cms_form
	end

	def cms_allow_comment cpid
		_throw L[:'the comment is closed'] unless DB[:cms_post].filter(:cpid => cpid).get(:status) == 0
	end

end

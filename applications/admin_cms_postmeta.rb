#display
get '/admin/cms_postmeta' do

	@rightbar += [:new, :search]
	ds = DB[:cms_postmeta]

	#search content
	ds = ds.filter(@qs[:sw].to_sym => @qs[:sc]) if @qs[:sw] and @qs[:sc]

	#search condition
	if @rightbar.include? :search
		@search = {:cpid => 'cpid', :mkey => 'mkey', :mval => 'mval', :created => 'created', }
	end

	#order
	if @qs[:order]
		if @qs.has_key? :desc
			ds = ds.reverse_order(@qs[:order].to_sym)
			@qs.delete :desc
		else
			ds = ds.order(@qs[:order].to_sym)
			@qs[:desc] = 'yes'
		end
	end

	Sequel.extension :pagination
 	@cms_postmeta = ds.paginate(@page_curr, @page_size, ds.count)
 	@page_count = @cms_postmeta.page_count

	_tpl :admin_cms_postmeta

end

#new a record
get '/admin/cms_postmeta/new' do

	@title = L[:'create a new one '] + L[:'cms_postmeta']
	@rightbar << :save
	cms_postmeta_set_fields
	_tpl :admin_cms_postmeta_form

end

post '/admin/cms_postmeta/new' do

	cms_postmeta_set_fields
	cms_postmeta_valid_fields
	@fields[:created] = Time.now
	DB[:cms_postmeta].insert(@fields)
	redirect "/admin/cms_postmeta"

end

#delete the record
get '/admin/cms_postmeta/rm/:cpid' do

	_msg L[:'delete the record by id '] + params[:'cpid']
	DB[:cms_postmeta].filter(:cpid => params[:cpid].to_i).delete
	redirect "/admin/cms_postmeta"

end

#edit the record
get '/admin/cms_postmeta/edit/:cpid' do

	@title = L[:'edit the '] + L[:'cms_postmeta']
	@rightbar << :save
	@fields = DB[:cms_postmeta].filter(:cpid => params[:cpid]).all[0]
 	cms_postmeta_set_fields
 	_tpl :admin_cms_postmeta_form

end

post '/admin/cms_postmeta/edit/:cpid' do

	cms_postmeta_set_fields
	cms_postmeta_valid_fields
	DB[:cms_postmeta].filter(:cpid => params[:cpid].to_i).update(@fields)
	redirect "/admin/cms_postmeta"

end

helpers do

	#fill the @fields with the default value
	#the @fields will be write into database, or display by template to frontground
	def cms_postmeta_set_fields
		
		default_values = {
			:cpid		=> 1,
			:mkey		=> '',
			:mval		=> ''
		}

		default_values.each do | k, v |
			unless @fields.include? k
				@fields[k] = params[k] ? params[k] : v
			end
		end

	end

	def cms_postmeta_valid_fields
		
		#_throw(L[:'the field cannot be empty '] + L[:'cpid']) if @fields[:cpid] != 0
		
		_throw(L[:'the field cannot be empty '] + L[:'mkey']) if @fields[:mkey].strip.size < 1
		
		_throw(L[:'the field cannot be empty '] + L[:'mval']) if @fields[:mval].strip.size < 1
		
		#_throw(L[:'the field cannot be empty '] + L[:'created']) if @fields[:created].strip.size < 1
		
	end

end

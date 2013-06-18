#display
get '/admin/cms_type' do

	@rightbar += [:new, :search]
	ds = DB[:cms_type]

	#search content
	ds = ds.filter(@qs[:sw].to_sym => @qs[:sc]) if @qs[:sw] and @qs[:sc]

	#search condition
	if @rightbar.include? :search
		@search = {:ctid => 'ctid', :name => 'name', :order => 'order', :description => 'description', }
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
 	@cms_type = ds.paginate(@page_curr, @page_size, ds.count)
 	@page_count = @cms_type.page_count

	_tpl :admin_cms_type

end

#new a record
get '/admin/cms_type/new' do

	@title = L[:'create a new one '] + L[:'type']
	@rightbar << :save
	cms_type_set_fields
	_tpl :admin_cms_type_form

end

post '/admin/cms_type/new' do

	cms_type_set_fields
	cms_type_valid_fields
	DB[:cms_type].insert(@fields)
	redirect "/admin/cms_type"

end

#delete the record
get '/admin/cms_type/rm/:ctid' do

	_msg L[:'delete the record by id '] + params[:'ctid']
	DB[:cms_type].filter(:ctid => params[:ctid].to_i).delete
	redirect "/admin/cms_type"

end

#edit the record
get '/admin/cms_type/edit/:ctid' do

	@title = L[:'edit the '] + L[:'type']
	@rightbar << :save
	@fields = DB[:cms_type].filter(:ctid => params[:ctid]).all[0]
 	cms_type_set_fields
 	_tpl :admin_cms_type_form

end

post '/admin/cms_type/edit/:ctid' do

	cms_type_set_fields
	cms_type_valid_fields
	DB[:cms_type].filter(:ctid => params[:ctid]).update(@fields)
	redirect "/admin/cms_type"

end

helpers do

	#fill the @fields with the default value
	#the @fields will be write into database, or display by template to frontground
	def cms_type_set_fields
		
		default_values = {
			:name		=> '',
			:order		=> 1,
			:description=> ''
		}

		default_values.each do | k, v |
			unless @fields.include? k
				@fields[k] = params[k] ? params[k] : v
			end
		end

	end

	def cms_type_valid_fields
		
		_throw(L[:'the field cannot be empty '] + L[:'name']) if @fields[:name].strip.size < 1
		
		#_throw(L[:'the field cannot be empty '] + L[:'order']) if @fields[:order] != 0
		
	end

end

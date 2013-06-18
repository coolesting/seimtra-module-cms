#display
get '/admin/cms_post' do

	@rightbar += [:new, :search]
	ds = DB[:cms_post]

	#search content
	ds = ds.filter(@qs[:sw].to_sym => @qs[:sc]) if @qs[:sw] and @qs[:sc]

	#search condition
	if @rightbar.include? :search
		@search = {:cpid => 'cpid', :ctid => 'name', :uid => 'uid', :last_changed => 'last_changed', :form_id => 'form_id', :status => 'status', :title => 'title', :body => 'body', :created => 'created', :changed => 'changed', :comment_count => 'comment_count', }
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
 	@cms_post = ds.paginate(@page_curr, @page_size, ds.count)
 	@page_count = @cms_post.page_count

	_tpl :admin_cms_post

end

#new a record
get '/admin/cms_post/new' do

	@title = L[:'create a new one '] + L[:'post']
	@rightbar << :save
	cms_post_set_fields
	_tpl :admin_cms_post_form

end

post '/admin/cms_post/new' do

	cms_post_set_fields
	cms_post_valid_fields
	@fields[:created] = Time.now
	@fields[:changed] = Time.now
	DB[:cms_post].insert(@fields)
	redirect "/admin/cms_post"

end

#delete the record
get '/admin/cms_post/rm/:cpid' do

	_msg L[:'delete the record by id '] + params[:'cpid']
	DB[:cms_post].filter(:cpid => params[:cpid].to_i).delete
	redirect "/admin/cms_post"

end

#edit the record
get '/admin/cms_post/edit/:cpid' do

	@title = L[:'edit the '] + L[:'post']
	@rightbar << :save
	@fields = DB[:cms_post].filter(:cpid => params[:cpid]).all[0]
 	cms_post_set_fields
 	_tpl :admin_cms_post_form

end

post '/admin/cms_post/edit/:cpid' do

	cms_post_set_fields
	cms_post_valid_fields
	@fields[:changed] = Time.now
	DB[:cms_post].filter(:cpid => params[:cpid]).update(@fields)
	redirect "/admin/cms_post"

end

helpers do

	#fill the @fields with the default value
	#the @fields will be write into database, or display by template to frontground
	def cms_post_set_fields
		
		default_values = {
			:ctid			=> 1,
			:uid			=> _user[:uid],
			:form_id		=> 1,
			:last_changed	=> _user[:uid],
			:status			=> 0,
			:title			=> '',
			:body			=> '',
			:comment_count	=> 0
		}

		default_values.each do | k, v |
			unless @fields.include? k
				@fields[k] = params[k] ? params[k] : v
			end
		end

	end

	def cms_post_valid_fields
		
		field = _kv :cms_type, :ctid, :name
		_throw(L[:'the field does not exist '] + L[:'ctid']) unless field.include? @fields[:ctid].to_i

		#_throw(L[:'the field cannot be empty '] + L[:'uid']) if @fields[:uid] != 0

		#_throw(L[:'the field cannot be empty '] + L[:'status']) if @fields[:status] != 0
		
		_throw(L[:'the field cannot be empty '] + L[:'title']) if @fields[:title].strip.size < 1
		
		_throw(L[:'the field cannot be empty '] + L[:'body']) if @fields[:body].strip.size < 1
		
		_throw(L[:'the field cannot be empty '] + L[:'comment_count']) if @fields[:comment_count].strip.size < 1
		
	end

end

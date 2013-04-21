#display
get '/admin/cms_comment' do

	@rightbar += [:new, :search]
	ds = DB[:cms_comment]

	#search content
	ds = ds.filter(@qs[:sw].to_sym => @qs[:sc]) if @qs[:sw] and @qs[:sc]

	#search condition
	if @rightbar.include? :search
		@search = {:ccid => 'ccid', :cpid => 'cpid', :uid => 'uid', :body => 'body', :created => 'created', }
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
 	@cms_comment = ds.paginate(@page_curr, @page_size, ds.count)
 	@page_count = @cms_comment.page_count

	_tpl :admin_cms_comment

end

#new a record
get '/admin/cms_comment/new' do

	@title = L[:'create a new one '] + L[:'comment']
	@rightbar << :save
	cms_comment_set_fields
	_tpl :admin_cms_comment_form

end

post '/admin/cms_comment/new' do

	cms_comment_set_fields
	cms_comment_valid_fields
	@fields[:created] = Time.now
	DB[:cms_comment].insert(@fields)
	redirect "/admin/cms_comment"

end

#delete the record
get '/admin/cms_comment/rm/:ccid' do

	_msg L[:'delete the record by id '] + params[:'ccid']
	DB[:cms_comment].filter(:ccid => params[:ccid].to_i).delete
	redirect "/admin/cms_comment"

end

#edit the record
get '/admin/cms_comment/edit/:ccid' do

	@title = L[:'edit the '] + L[:'comment']
	@rightbar << :save
	@fields = DB[:cms_comment].filter(:ccid => params[:ccid]).all[0]
 	cms_comment_set_fields
 	_tpl :admin_cms_comment_form

end

post '/admin/cms_comment/edit/:ccid' do

	cms_comment_set_fields
	cms_comment_valid_fields
	DB[:cms_comment].filter(:ccid => params[:ccid]).update(@fields)
	redirect "/admin/cms_comment"

end

helpers do

	#fill the @fields with the default value
	#the @fields will be write into database, or display by template to frontground
	def cms_comment_set_fields
		
		default_values = {
			:cpid		=> 0,
			:uid		=> _user[:uid],
			:body		=> ''
		}

		default_values.each do | k, v |
			unless @fields.include? k
				@fields[k] = params[k] ? params[k] : v
			end
		end

	end

	def cms_comment_valid_fields
		
		#_throw(L[:'the field cannot be empty '] + L[:'cpid']) if @fields[:cpid] != 0
		
		#_throw(L[:'the field cannot be empty '] + L[:'uid']) if @fields[:uid] != 0
		
		_throw(L[:'the field cannot be empty '] + L[:'body']) if @fields[:body].strip.size < 1
		
	end

end

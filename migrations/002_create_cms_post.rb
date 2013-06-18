Sequel.migration do
	change do
		create_table(:cms_post) do
			primary_key :cpid
			Integer :ctid
			Integer :uid
			Integer :last_changed
			Integer :status
			String :title
			Text :body
			Datetime :created
			Datetime :changed
			Integer :comment_count
		end
	end
end

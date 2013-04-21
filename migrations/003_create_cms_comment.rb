Sequel.migration do
	change do
		create_table(:cms_comment) do
			primary_key :ccid
			Integer :cpid
			Integer :uid
			Text :body
			Datetime :created
		end
	end
end

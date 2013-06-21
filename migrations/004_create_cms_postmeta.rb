Sequel.migration do
	change do
		create_table(:cms_postmeta) do
			Integer :cpid
			String :mkey
			String :mval
			Datetime :created
		end
	end
end

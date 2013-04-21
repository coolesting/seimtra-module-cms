Sequel.migration do
	change do
		create_table(:cms_type) do
			primary_key :ctid
			String :name
			Integer :order
			String :description
		end
	end
end

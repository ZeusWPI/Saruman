class AddEventnameAndOrganisationname < ActiveRecord::Migration[4.2]
  def change
    rename_column :settings, :name, :event_name
    add_column :settings, :organisation_name, :string, null: false, default: ""
    s = Settings.instance
    s.update organisation_name: s.event_name
  end
end

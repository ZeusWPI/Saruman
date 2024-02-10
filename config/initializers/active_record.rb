Rails.application.config.after_initialize do
  ActiveRecord.yaml_column_permitted_classes += [
    Date,
    BigDecimal,
    ActiveSupport::TimeWithZone,
    Time,
    ActiveSupport::TimeZone,
    ActiveSupport::HashWithIndifferentAccess,
  ]
end

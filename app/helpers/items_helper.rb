module ItemsHelper
  def button_name object, category
    if object.persisted?
      'Save'
    else
      "Add #{category}"
    end
  end
end

module FlashHelper
  KEY_TO_FLASH_CLASS = {
    error: 'danger',
    warning: 'warning',
    alert: 'warning',
    notice: 'info',
    success: 'success',
  }.freeze

  def key_to_flash_class(key)
    "alert-#{KEY_TO_FLASH_CLASS.fetch(key.to_sym, 'dark')}"
  end
end

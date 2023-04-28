# frozen_string_literal: true

class GenerateBillingProposal
  include WickedPdf::PdfHelper

  def initialize(partner)
    @partner = partner

    @view = ActionView::Base.new(ActionController::Base.view_paths, {})
    @view.extend(ApplicationHelper)
    @view.extend(Rails.application.routes.url_helpers)
  end

  def call
    @reservations = @partner.reservations.approved

    WickedPdf.new.pdf_from_string(rendered_view)
  end


  private

  def rendered_view
    @view.render(
      pdf: 'bill.pdf',
      template: 'users/send_bill.pdf.erb',
      layout: false,
      locals: { partner: @partner, reservations: @reservations }
    )
  end
end

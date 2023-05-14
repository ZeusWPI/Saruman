# frozen_string_literal: true

class GenerateBillingProposal
  include WickedPdf::PdfHelper

  def initialize(partner)
    @partner = partner
  end

  def call
    @reservations = @partner.reservations.approved

    rendered_view
  end

  private

  def rendered_view
    ApplicationController.render(
      pdf: 'bill.pdf',
      template: 'billing/billing_proposal',
      layout: false,
      locals: { partner: @partner, reservations: @reservations }
    )
  end
end

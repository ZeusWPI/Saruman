# frozen_string_literal: true

class GenerateBillingProposal
  def initialize(partner)
    @partner = partner
  end

  def call
    @reservations = @partner.reservations.approved

    Grover.new(rendered_view, format: 'A4').to_pdf
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

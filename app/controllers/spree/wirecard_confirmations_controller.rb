require 'spree/wirecard_qpay_helpers'

module Spree
  class WirecardConfirmationsController < ApplicationController
    include WirecardQPAYHelpers

    skip_before_filter :verify_authenticity_token

    def create
      order = Order.find_by_number!(params[:order_id])
      payment = find_or_create_wirecard_qpay_payment(order, params)

      unless payment.completed?
        if payment.source.success?
          finalize_wirecard_qpay_payment(order, params)
        else
          fail_wirecard_qpay_payment(order, params)
        end
      end

      head(:ok)
    end
  end
end

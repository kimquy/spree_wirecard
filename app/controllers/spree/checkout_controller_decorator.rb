require 'wirecard'
require 'spree/billing_integration/wirecard/qpay'
require 'spree/wirecard_qpay_helpers'

module Spree
  CheckoutController.class_eval do
    include WirecardQPAYHelpers

    skip_before_filter :verify_authenticity_token, :only => [:wirecard_success, :wirecard_failure, :wirecard_cancel]

    def wirecard_qpay_payment_page
      @payment_method = PaymentMethod.find(params[:payment_method_id])
      render :layout => false
    end

    def wirecard_success
      payment = find_or_create_wirecard_qpay_payment(@order, params)

      @redirect_url = completion_route

      unless payment.completed?
        if payment.source.success?
          finalize_wirecard_qpay_payment(@order, payment)
        else
          fail_wirecard_qpay_payment(@order, payment)

          @redirect_url = checkout_state_path(:payment)
        end
      end

      render :wirecard_qpay_redirect, :layout => false
    end

    def wirecard_failure
      @redirect_url = checkout_state_path(:payment)
      render :wirecard_qpay_redirect, :layout => false
    end

    def wirecard_cancel
      @redirect_url = checkout_state_path(:payment)
      render :wirecard_qpay_redirect, :layout => false
    end
  end
end

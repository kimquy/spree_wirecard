require 'wirecard/request'

Spree::Order.class_eval do
  def wirecard_qpay_params(payment_method, params = {})
    wirecard_qpay_request(payment_method, params).params
  end

  def wirecard_qpay_request(payment_method, params = {})
    Wirecard::Request.new(payment_method, params.merge(amount: total, orderDescription: "Order #{number}"))
  end
end

module Spree
  class BillingIntegration::Wirecard::QPAY < PaymentMethod
    preference :customer_id, :string
    preference :secret, :string
    preference :language, :string, :default => 'EN'
    preference :currency, :string, :default => 'EUR'
    preference :payment_type, :string, :default => 'SELECT'

    attr_accessible :preferred_customer_id, :preferred_secret,
                    :preferred_language, :preferred_currency, :preferred_payment_type

  end
end

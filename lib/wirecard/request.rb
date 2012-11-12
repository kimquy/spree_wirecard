# encoding: utf-8

module Wirecard
  class Request
    attr_accessor :payment_method, :params

    def initialize(payment_method, params = {})
      self.payment_method = payment_method
      self.params = params.symbolize_keys.reverse_merge(
        :customerId  => payment_method.preferences[:customer_id],
        :secret      => payment_method.preferences[:secret],
        :currency    => payment_method.preferences[:currency],
        # FIXME use I18n.locale by default if it's available for QPAY
        :language    => payment_method.preferences[:language],
        :paymentType => payment_method.preferences[:payment_type],
      )
      generate_fingerprint
    end

    def generate_fingerprint
      fingerprint_parts  = params.values_at(:secret, :customerId)
      fingerprint_parts += params.values_at(*fingerprint_params)
      fingerprint_parts += [fingerprint_order.join(',')]

      fingerprint_seed = fingerprint_parts.join
      fingerprint = Wirecard.md5(fingerprint_seed)
      params.merge!(:requestFingerprint => fingerprint, :requestFingerprintOrder => fingerprint_order.join(','))
      # params.merge!(:requestFingerprintSeed => fingerprint_seed) if Rails.env.development?

      fingerprint
    end

    def fingerprint_params
      @fingerprint_params ||= begin
        fingerprint_params = %w[amount currency language orderDescription successURL].map(&:to_sym)
        fingerprint_params << :confirmURL if params.include?(:confirmURL)
        fingerprint_params
      end
    end

    def fingerprint_order
      @fingerprint_order ||= (%w[secret customerId] + fingerprint_params + %w[requestFingerprintOrder]).map(&:to_sym)
    end
  end
end

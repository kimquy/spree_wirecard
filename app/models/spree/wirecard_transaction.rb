require 'wirecard/response'

module Spree
  class WirecardTransaction < ActiveRecord::Base
    has_many :payments, :as => :source

    serialize :params, Hash

    validate :check_fingerprint

    attr_accessor :payment_method

    def self.create_from_params(payment_method, params)
      build_from_params(payment_method, params).tap(&:save!)
    end

    def self.build_from_params(payment_method, params)
      new do |wirecard_transaction|
        wirecard_transaction.payment_method = payment_method
        wirecard_transaction.params = params
      end
    end

    def params=(params)
      @response = Wirecard::Response.new(payment_method, params)

      self.order_number = @response.order_number
      self.amount = @response.amount
      self.currency = @response.currency
      self.payment_type = @response.payment_type

      super
    end

    def success?
      @response.success?
    end

  private

    def check_fingerprint
      errors[:base] << 'Invalid respone fingerprint.' unless @response.has_valid_fingerprint?
    end

  end
end
